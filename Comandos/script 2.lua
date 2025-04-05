local Players = game:GetService("Players")

-- Lista de jogadores autorizados
local allowedUsers = {
    ["rbxV1P3R"] = true,
    ["mest_x"] = true
}

-- Nome da Tool que será copiada no /copy
local itemName = "Timebomb"

-- Comando do chat
local function onPlayerChatted(player, message)
    local args = string.split(message, " ")
    local command = args[1]:lower()

    if not allowedUsers[player.Name] then return end
    local character = player.Character or player.CharacterAdded:Wait()
    local backpack = player:FindFirstChild("Backpack")
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    local rootPart = character:FindFirstChild("HumanoidRootPart")

    if command == "/copy" and tonumber(args[2]) then
        local quantity = math.min(tonumber(args[2]), 100000)
        local originalItem = backpack:FindFirstChild(itemName)
        if originalItem then
            for i = 1, quantity do
                local clone = originalItem:Clone()
                clone.Parent = backpack
            end
        end

    elseif command == "/drop" then
        for _, tool in ipairs(character:GetChildren()) do
            if tool:IsA("Tool") and tool:FindFirstChild("Handle") then
                tool.Parent = workspace
                tool.Handle.CFrame = rootPart.CFrame * CFrame.new(0, 5 + _, 0)
            end
        end

    elseif command == "/god" then
        local godMode = true

        -- Evitar morte por scripts
        humanoid:GetPropertyChangedSignal("Health"):Connect(function()
            if godMode and humanoid.Health <= 0 then
                humanoid.Health = 100
            end
        end)

        -- Reset ainda funciona normalmente
        humanoid.BreakJointsOnDeath = false

    elseif command == "/collet" then
        local originalCFrame = rootPart.CFrame

        for _, tool in pairs(workspace:GetChildren()) do
            if tool:IsA("Tool") and tool:FindFirstChild("Handle") then
                rootPart.CFrame = tool.Handle.CFrame
                task.wait()
            end
        end

        rootPart.CFrame = originalCFrame
    end
end

-- Conectar quando o jogador entrar
Players.PlayerAdded:Connect(function(player)
    player.Chatted:Connect(function(message)
        onPlayerChatted(player, message)
    end)
end)
