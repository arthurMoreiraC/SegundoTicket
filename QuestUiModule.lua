--!strict
local module = {}
local questDataModule = require(game.ReplicatedStorage.Misc.Quests.Data)
local player = game.Players.LocalPlayer
local playerGui = player.PlayerGui
local canvas = playerGui:WaitForChild("Quests").Canvas
local imageModule = require(game.ReplicatedStorage:WaitForChild("Misc").ImageIds)
local uiModule = require(game.ReplicatedStorage:WaitForChild("Misc").Ui)

local function cleanScrolling(scrolling: ScrollingFrame)
	for i, v in ipairs(scrolling:GetChildren()) do
		if v:IsA("GuiObject") then
			v:Destroy()
		end
	end
end

local function createRewardImagesInfo(imageTable, infoFrame)
	for i, value: string in ipairs(imageTable) do
		local imageId = imageModule[value]
		if imageId then
			local rewardImage = script.RewardInfo:Clone()
			rewardImage.Icon.Image = imageId
			rewardImage.Parent = infoFrame.RewardsFrame
		else
			warn("image nao encontrada para", value)
		end
	end
end

local function createRewardImagesQuest(imageTable, questLabel)
	for i, value: string in ipairs(imageTable) do
		local imageId = imageModule[value]
		if imageId then
			local rewardImage = script.RewardQuest:Clone()
			rewardImage.Icon.Image = imageId
			rewardImage.Parent = questLabel.RewardsFrame
		else
			warn("image nao encontrada para", value)
		end
	end
end

local function ClaimQuest(claimButton, questName: string)
	if claimButton:GetAttribute("Claim") then
		game.ReplicatedStorage.Events.Quests.Claim:FireServer(questName)
		uiModule.Prompt(player, questName.." Claimed!", 1)
	end
end
local function onQuestClick(questName: string)
	
	local data = game.ReplicatedStorage.Events.GetData:InvokeServer()
	local quests = data.Quests
	local infoFrame = canvas.Info
	local claimButton = canvas.Info.Claim
	

	for i, quest in ipairs(quests) do
		if quest.Name == questName then
			infoFrame.NameText.Text = quest.Name
			infoFrame.Description.Text = quest.Description
			
			for class, data in pairs(quest.Progress) do
				local progressFrame = script:WaitForChild("ProgressLabel"):Clone()
				progressFrame.Progress.Text = uiModule.abbreviateNumber(data.Progress) .. "/" .. uiModule.abbreviateNumber(data.MaxProgress)
				progressFrame.Progress.CompleteGradient.Enabled = data.Progress == data.MaxProgress
				progressFrame.Parent = infoFrame.Progress
			end
			
			local imageTable = data.RewardsImagesNames or questDataModule[quest.Name].RewardsImagesNames
			if imageTable then
				createRewardImagesInfo(imageTable, infoFrame)
			end
			
			local canClaimImage = claimButton.CanClaim.Value
			local cantClaimImage = claimButton.CantClaim.Value
			
			claimButton:SetAttribute("Claim", quest.Completed)
			claimButton.Image = quest.Completed and canClaimImage or cantClaimImage
			
			claimButton.Activated:Connect(function()
				ClaimQuest(claimButton, questName)
			end)
		end
	end
end

function module.RenderQuests(keyword: string?)
	local data = game.ReplicatedStorage.Events.GetData:InvokeServer()
	local quests = data.Quests
	local scrolling = canvas:WaitForChild("Scrolling")
	
	cleanScrolling(scrolling)
	
	for i, quest in ipairs(quests) do
		if keyword and quest.Class ~= keyword then continue end
		local questLabel = script:WaitForChild("Quest"):Clone()
		questLabel.NameText.Text = quest.Name
		questLabel.Activated:Connect(function()
			onQuestClick(quest.Name)
		end)
		local bool = false
		for class, data in pairs(quest.Progress) do
			if bool == true then break end
			bool = true
			questLabel.ProgressLabel.Progress.Text = uiModule.abbreviateNumber(data.Progress) .. "/" .. uiModule.abbreviateNumber(data.MaxProgress)
			if data.Progress == data.MaxProgress then
				questLabel.ProgressLabel.Progress.CompleteGradient.Enabled = true
			end
		end
		local imageTable = data.RewardsImagesNames or questDataModule[quest.Name].RewardsImagesNames
		if imageTable then
			createRewardImagesQuest(imageTable, questLabel)
		else
			warn("image table nao encontrada para", quest.Name)
		end
		
		questLabel.Parent = scrolling
	end
	print("rendering")
end

return module
