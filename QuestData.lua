local module = {}

local typeModule = require(game.ReplicatedStorage.Types.QuestsType)

module["Daily Quest 1"] = {
	Name = "Daily Quest 1",
	Description = "The world needs your help! Enemies are atacking civilians, take care of them!",
	Class = "Daily",
	Progress = {
		["DealDamage"] = {
			["Progress"] = 0,
			["MaxProgress"] = 10000,
			["Completed"] = false
		}
	},
	RewardsImagesNames = {"Coin", "Exp"}
} :: typeModule.template

module["Daily1"] = {
	Name = "Daily1",
	Description = "template",
	Class = "Daily",
	Progress = {
		["DealDamage"] = {
			["Progress"] = 0,
			["MaxProgress"] = 10000,
			["Completed"] = false
		}
	},
	RewardsImagesNames = {"Coin", "Exp"}
} :: typeModule.template
return module
