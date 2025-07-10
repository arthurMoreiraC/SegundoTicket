--!strict
local module = {}

local ServerScriptService = game:GetService("ServerScriptService")
local profile = require(ServerScriptService.ProfileHandler)

module.Daily = {
	["Daily1"] = function(player: Player)
		print(player.Name, "completou Daily1!")
	end,
	["Daily Quest 1"] = function(player: Player)
		print(player.Name, "completou Daily Quest 1!")
	end,
}


return module
