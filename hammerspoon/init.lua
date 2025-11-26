-- init.lua
-- Hammerspoon configuration
-- Load modules
pcall(function() dofile(os.getenv("HOME").."/.hammerspoon/secrets.lua") end)

-- my modules 
require("spellcheck")
require("commandk")

-- Display a message when config is loaded
hs.alert.show("Hammerspoon config loaded")