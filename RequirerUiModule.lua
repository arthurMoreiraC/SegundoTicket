
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player.PlayerGui
local canvas = playerGui:WaitForChild("Quests").Canvas
local buttonsFrame = canvas:WaitForChild("Buttons")
local questModule = require(script:WaitForChild("QuestsUi"))
local greenId = "rbxassetid://129798833312212"
local grayId = "rbxassetid://90049723824961"
local connections = {}

local function changeStroke(button: ImageButton, enabled: boolean)
	if not button then return end
	
	local textLabel = button:FindFirstChildWhichIsA("TextLabel")
	if not textLabel then return end
	
	local stroke = textLabel:FindFirstChildWhichIsA("UIStroke")
	if stroke then
		stroke.Enabled = enabled
	end
end

local function cleanImages()
	for _, imageBut: ImageButton? in buttonsFrame:GetChildren() do
		if not imageBut:IsA("ImageButton") then continue end
		
		changeStroke(imageBut, false)
		imageBut.Image = grayId
	end
end

local function setupButton(keyword: string?)

	local button: ImageButton = buttonsFrame:FindFirstChild(keyword)
	if not button then return end
	if not connections[keyword] then
		connections[keyword] = button.Activated:Connect(function()
			cleanImages()
			changeStroke(button, true)
			button.Image = greenId

			questModule.RenderQuests(keyword)
		end)
	end

end

local classes = {
	"Daily",
	"Weekly",
	"Special"
}
game.ReplicatedStorage.Events.Quests.ChangeUi.OnClientEvent:Connect(function()
	questModule.RenderQuests()
	
	for _, class: string in classes do
		setupButton(class)
	end
end)
