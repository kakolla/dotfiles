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



