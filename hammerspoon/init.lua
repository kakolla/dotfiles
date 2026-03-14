-- Scroll down (like moving scrollbar down)
hs.hotkey.bind({"ctrl"}, "v", function()
  for i = 1, 2 do
    hs.eventtap.scrollWheel({0, -2}, {}, "line")  -- scroll down
    hs.timer.usleep(8000)
  end
end)

-- Optional: Scroll up
hs.hotkey.bind({"ctrl"}, "m", function()
  for i = 1, 2 do
    hs.eventtap.scrollWheel({0, 2}, {}, "line")  -- scroll up
    hs.timer.usleep(8000)
  end
end)



-- screen watcher, on monitor change restart sketchybar -> restart aerospace
-- https://www.hammerspoon.org/docs/hs.screen.watcher.html
hs.screen.watcher.new(function()
    hs.timer.doAfter(2, function()
        hs.execute("/opt/homebrew/bin/brew services restart sketchybar")
    end)
end):start()