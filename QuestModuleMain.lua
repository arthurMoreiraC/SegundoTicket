--Este código quebra um pouco do open/closed principle do SOLID, apenas pois esse sistema é bem simples, e não geraria problemas em alterá-lo diretamente.

--!strict
local Players = game:GetService("Players")
local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")

local bindablesFolder = ServerStorage.Bindables.QuestBindables
local event = ReplicatedStorage.Events.Quests.ChangeUi
local profile = require(ServerScriptService.ProfileHandler)
local typeModule = require(ReplicatedStorage.Types.QuestsType)
local progressModule = require(script.Progress)
local functionsModule = require(script.Functions)
local Quests = {}
Quests.__index = Quests
local progresses = {}
local activeQuests = {}

function Quests.new(player: Player?, QuestData: typeModule.template?)
	if not player or not QuestData then return end

	local self = setmetatable({}, Quests)
	self.player = player
	self.description = QuestData.Description
	self.name = QuestData.Name
	self.class = QuestData.Class
	self.completed = false
	self.progress = QuestData.Progress
	self.imagesNames = QuestData.RewardsImagesNames
	
	if not progresses[player] then
		progresses[player] = {}
	end
	progresses[player][self.name] = progressModule.new(player)
	
	for i, progressionType: typeModule.progressTypes in ipairs(typeModule.progressTypes) do
		if self.progress[progressionType] then
			local event: BindableEvent = bindablesFolder:FindFirstChild(event.Name.. " ".. player.Name) or bindablesFolder[progressionType]:Clone()
			event.Name = event.Name.. " ".. player.Name
			
			game.Players.PlayerRemoving:Connect(function(playerQuitting)
				if playerQuitting == player then
					event:Destroy()
				end
			end)
			
			if QuestData.Progress[progressionType].Completed == true then 	game.ReplicatedStorage.Events.Quests.ChangeUi:FireClient(self.player) return end
			event.Event:Connect(function(Amount)
				self:progressQuest(progressionType, Amount)
			end)
		end
	end
	local data = profile.GetData(player)
	
	if not data.Quests then
		data.Quests = {}
	end
	local find = false
	if #data.Quests > 0 then
		for key, quest in pairs(data.Quests) do
			for key, value in pairs(quest) do
				if key == "Name" and value == self.name then
					find = true
				end
			end
		end
	end
	
	
	if not find then
		table.insert(data.Quests, {
			Name = self.name,
			Description = self.description,
			Class = self.class,
			Progress = self.progress,
			RewardsImagesNames = self.imagesNames,
			Completed = self.completed,
		})
	end
	
	profile.SetValue(player, "Quests", data.Quests)
	event:FireClient(player, data.Quests)

	return self
end


function Quests:progressQuest(Type: typeModule.progressTypes, amount: number)
	if not self.progress[Type] then return end
	
	progresses[self.player][self.name]:progress(self.name, self.progress[Type], amount)
	
	
	
	if progresses[self.player][self.name]:check(self.name) then
		self:reward()
	end
	
	local data = profile.GetData(self.player)

	local find
	if #data.Quests > 0 then
		for i, quest in ipairs(data.Quests) do
			for key, value in pairs(quest) do
				if key == "Name" and value == self.name then
					find = i
				end
			end
		end
	end

	if find ~= nil then
		table.remove(data.Quests, find)
	end

	table.insert(data.Quests, {
		Name = self.name,
		Description = self.description,
		Class = self.class,
		Progress = self.progress,
		RewardsImagesNames = self.imagesNames,
		Completed = self.completed,
	})
	
	profile.SetValue(self.player, "Quests", data.Quests)
	
	game.ReplicatedStorage.Events.Quests.ChangeUi:FireClient(self.player)
end

function Quests:reward()
	if functionsModule[self.class][self.name] then
		functionsModule[self.class][self.name](self.player)
		self.completed = true
	else
		warn("CallBack não encontrada para", self.name)
	end
end

return Quests
