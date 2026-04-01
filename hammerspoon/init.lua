-- init.lua
-- Hammerspoon configuration
-- Load modules
pcall(function() dofile(os.getenv("HOME").."/.hammerspoon/secrets.lua") end)

-- my modules 
require("spellcheck")
require("spellcheck_local")

require("commandk")
require("zoom_meeting_controls")

-- Display a message when config is loaded
hs.alert.show("Hammerspoon config loaded")