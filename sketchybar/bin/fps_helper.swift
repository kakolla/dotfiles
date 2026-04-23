import Foundation
import ScreenCaptureKit
import CoreMedia
import CoreVideo
import AppKit


// count display frame updates on main display each second, push to gpu_fps item in sketchybar
// use ScreenCaptureKit with SCFrameStatus - .complete means new content, .idle no change

let sketchybar = "/opt/homebrew/bin/sketchybar"
let item = "gpu_fps"

func push(_ fps: Int) {
    let task = Process()
    task.executableURL = URL(fileURLWithPath: sketchybar)
    task.arguments = ["--set", item, "label=\(fps) FPS"]
    task.standardOutput = FileHandle.nullDevice
    task.standardError = FileHandle.nullDevice
    try? task.run()
}

final class FrameCounter: NSObject, SCStreamOutput, SCStreamDelegate {
    let lock = NSLock()
    var count = 0

    func stream(_ stream: SCStream,
                didOutputSampleBuffer sampleBuffer: CMSampleBuffer,
                of type: SCStreamOutputType) {
        guard type == .screen,
              let arr = CMSampleBufferGetSampleAttachmentsArray(sampleBuffer, createIfNecessary: false) as? [[SCStreamFrameInfo: Any]],
              let attachments = arr.first,
              let raw = attachments[.status] as? Int,
              let status = SCFrameStatus(rawValue: raw),
              status == .complete
        else { return }
        lock.lock()
        count += 1
        lock.unlock()
    }

    func reset() {
        lock.lock()
        count = 0
        lock.unlock()
    }

    func stream(_ stream: SCStream, didStopWithError error: Error) {
        let ns = error as NSError
        let msg = "fps_helper: stream stopped: domain=\(ns.domain) code=\(ns.code) desc=\(ns.localizedDescription) — restarting in 2s\n"
        FileHandle.standardError.write(Data(msg.utf8))
        DispatchQueue.global().asyncAfter(deadline: .now() + 2.0) {
            Task { await startStream(counter: self) }
        }
    }
}

let counter = FrameCounter()
var activeStream: SCStream?

func startStream(counter: FrameCounter) async {
    do {
        let content = try await SCShareableContent.excludingDesktopWindows(
            false, onScreenWindowsOnly: true)
        let mainID = CGMainDisplayID()
        guard let display = content.displays.first(where: { $0.displayID == mainID })
                            ?? content.displays.first else {
            FileHandle.standardError.write(Data("fps_helper: no display\n".utf8))
            exit(1)
        }

        let filter = SCContentFilter(display: display, excludingWindows: [])
        let config = SCStreamConfiguration()
        config.width = 64
        config.height = 64
        config.pixelFormat = kCVPixelFormatType_32BGRA
        config.showsCursor = false
        config.capturesAudio = false
        config.queueDepth = 8
        config.minimumFrameInterval = CMTime(value: 1, timescale: 120)

        let stream = SCStream(filter: filter, configuration: config, delegate: counter)
        activeStream = stream
        let sampleQueue = DispatchQueue(label: "fps.samples")
        try stream.addStreamOutput(counter, type: .screen,
                                   sampleHandlerQueue: sampleQueue)
        try await stream.startCapture()
    } catch {
        let ns = error as NSError
        let msg = "fps_helper: start failed: domain=\(ns.domain) code=\(ns.code) desc=\(ns.localizedDescription) — retrying in 3s\n"
        FileHandle.standardError.write(Data(msg.utf8))
        try? await Task.sleep(nanoseconds: 3_000_000_000)
        await startStream(counter: counter)
    }
}

Task {
    await startStream(counter: counter)
}

// Rebuild the stream on wake — SCK connections go stale across sleep.
NSWorkspace.shared.notificationCenter.addObserver(
    forName: NSWorkspace.didWakeNotification,
    object: nil,
    queue: .main
) { _ in
    Task {
        if let s = activeStream {
            try? await s.stopCapture()
        }
        activeStream = nil
        counter.reset()
        await startStream(counter: counter)
    }
}

let windowSeconds = 5.0
let timer = DispatchSource.makeTimerSource(queue: DispatchQueue.global())
timer.schedule(deadline: .now() + windowSeconds, repeating: windowSeconds)
timer.setEventHandler {
    counter.lock.lock()
    let c = counter.count
    counter.count = 0
    counter.lock.unlock()
    push(Int((Double(c) / windowSeconds).rounded()))
}
timer.resume()

RunLoop.main.run()
