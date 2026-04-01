local originalFrame = nil

hs.hotkey.bind({"cmd", "ctrl", "alt"}, "H", function()
  local zoomWindow = hs.window.find("zoom share statusbar window")
  if zoomWindow then
    if originalFrame then
      zoomWindow:setFrame(originalFrame)
      originalFrame = nil
    else
      originalFrame = zoomWindow:frame()
      local screen = zoomWindow:screen()
      local frame = zoomWindow:frame()
      frame.x = screen:frame().w + 3000
      frame.y = screen:frame().h + 3000
      zoomWindow:setFrame(frame)
    end
  end
end)