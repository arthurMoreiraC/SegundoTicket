--!strict
local module = {}
module.__index = module
local typeModule = require(game.ReplicatedStorage.Types.QuestsType)

local datas = {}

function module.new(player: Player?)
	local self = setmetatable({}, module)
	self.data = {}
	self.player = player
	
	return self
end

type selfType = typeof(module.new())

function module:progress(key: string, data: typeModule.ProgressTableData, amount: number)
	local self = self :: selfType
	if not data then return end
	
	data.Progress += amount
	if data.Progress >= data.MaxProgress then
		data.Completed = true
		data.Progress = data.MaxProgress
	end

	self.data[key] = data
end

function module:check(Key: string)
	local self = self :: selfType
	return self.data[Key].Completed
end
return module
