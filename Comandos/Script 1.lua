local allowedUsers = {
	rbxV1P3R = true,
	mest_x = true
}

local player = game.Players.LocalPlayer
if not allowedUsers[player.Name] then return end

local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local backpack = player:WaitForChild("Backpack")
local tools = {}
local godMode = false

-- Equipar Tools automaticamente
for _, tool in ipairs(backpack:GetChildren()) do
	if tool:IsA("Tool") then
		tool.Parent = character
		table.insert(tools, tool)

		if tool:FindFirstChild("Handle") then
			tool.Handle.CanCollide = false
		end
	end
end

backpack.ChildAdded:Connect(function(child)
	if child:IsA("Tool") then
		child.Parent = character
		table.insert(tools, child)

		if child:FindFirstChild("Handle") then
			child.Handle.CanCollide = false
		end
	end
end)

-- /drop
local function dropAllBombs()
	local rootPart = character:FindFirstChild("HumanoidRootPart")
	if not rootPart then return end

	for i, tool in ipairs(tools) do
		if tool:IsA("Tool") and tool:FindFirstChild("Handle") then
			tool.Parent = workspace
			tool.Handle.CFrame = rootPart.CFrame * CFrame.new(0, 5 + i, 0)
			tool.Handle.Velocity = Vector3.new(0, 0, 0)
		end
	end

	tools = {}
end

-- /god
local function toggleGodMode()
	godMode = not godMode
end

game:GetService("RunService").Stepped:Connect(function()
	if godMode and humanoid.Health <= 0 then
		humanoid.Health = humanoid.MaxHealth
	end
end)

-- /collet e /copy
local function teleportToTools()
	local rootPart = character:FindFirstChild("HumanoidRootPart")
	if not rootPart then return end

	local originalPosition = rootPart.CFrame

	for _, obj in pairs(workspace:GetChildren()) do
		if obj:IsA("Tool") and obj:FindFirstChild("Handle") then
			rootPart.CFrame = obj.Handle.CFrame
			wait(0)
		end
	end

	rootPart.CFrame = originalPosition
end

-- Comandos do chat
player.Chatted:Connect(function(msg)
	msg = msg:lower()

	if msg == "/drop" then
		dropAllBombs()
	elseif msg == "/god" then
		toggleGodMode()
	elseif msg == "/collet" or msg == "/copy" then
		teleportToTools()
	end
end)
