#!/usr/bin/env sh
set -euo pipefail
DIR="$(cd "$(dirname "$0")" && pwd)"
swiftc -O "$DIR/fps_helper.swift" -o "$DIR/fps_helper" \
  -framework Foundation -framework CoreGraphics -framework CoreVideo \
  -framework CoreMedia -framework ScreenCaptureKit
echo "built $DIR/fps_helper"
