--[[
    Sistema de Comandos de Admin (somente rbxV1P3R e mest_x)
    Comandos relacionados a ferramentas (tools) - Total: 50 comandos + reversões /un
]]

local allowedUsers = {
    ["rbxV1P3R"] = true,
    ["mest_x"] = true
}

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local function getAllTools()
    local tools = {}
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("Tool") then
            table.insert(tools, obj)
        end
    end
    return tools
end

local ToolCommands = {
    ["/droptools"] = function(player)
        for _, tool in ipairs(player.Backpack:GetChildren()) do
            if tool:IsA("Tool") then
                tool.Parent = Workspace
                tool.Handle.Position = player.Character.HumanoidRootPart.Position + Vector3.new(0, 5, 0)
            end
        end
    end,
    ["/undroptools"] = function(player)
        for _, tool in ipairs(getAllTools()) do
            tool.Parent = player.Backpack
        end
    end,
    ["/equiptools"] = function(player)
        for _, tool in ipairs(player.Backpack:GetChildren()) do
            if tool:IsA("Tool") then
                tool.Parent = player.Character
            end
        end
    end,
    ["/unequiptools"] = function(player)
        for _, tool in ipairs(player.Character:GetChildren()) do
            if tool:IsA("Tool") then
                tool.Parent = player.Backpack
            end
        end
    end,
    ["/collecttools"] = function(player)
        for _, tool in ipairs(getAllTools()) do
            tool.Parent = player.Backpack
        end
    end,
    ["/uncollecttools"] = function(player)
        for _, tool in ipairs(player.Backpack:GetChildren()) do
            if tool:IsA("Tool") then
                tool.Parent = Workspace
            end
        end
    end,
    ["/clonealltools"] = function(player)
        for _, tool in ipairs(getAllTools()) do
            local clone = tool:Clone()
            clone.Parent = player.Backpack
        end
    end,
    ["/unclonealltools"] = function(player)
        for _, tool in ipairs(player.Backpack:GetChildren()) do
            if tool:IsA("Tool") then
                tool:Destroy()
            end
        end
    end,
    ["/deletetools"] = function(player)
        for _, tool in ipairs(player.Backpack:GetChildren()) do
            if tool:IsA("Tool") then
                tool:Destroy()
            end
        end
    end,
    ["/undeletetools"] = function(player)
        player:Kick("Comando '/undeletetools' indisponível. Use '/collecttools' para recuperar.")
    end,
    ["/highlighttools"] = function(player)
        for _, tool in ipairs(getAllTools()) do
            local highlight = Instance.new("Highlight")
            highlight.Adornee = tool
            highlight.FillColor = Color3.new(1, 1, 0)
            highlight.OutlineColor = Color3.new(1, 0, 0)
            highlight.Parent = tool
        end
    end,
    ["/unhighlighttools"] = function(player)
        for _, tool in ipairs(getAllTools()) do
            for _, child in ipairs(tool:GetChildren()) do
                if child:IsA("Highlight") then
                    child:Destroy()
                end
            end
        end
    end,
    ["/spinalltools"] = function(player)
        for _, tool in ipairs(getAllTools()) do
            if tool:FindFirstChild("Handle") then
                tool.Handle.RotVelocity = Vector3.new(0, 50, 0)
            end
        end
    end,
    ["/unspinalltools"] = function(player)
        for _, tool in ipairs(getAllTools()) do
            if tool:FindFirstChild("Handle") then
                tool.Handle.RotVelocity = Vector3.new(0, 0, 0)
            end
        end
    end,
    ["/freezealltools"] = function(player)
        for _, tool in ipairs(getAllTools()) do
            if tool:FindFirstChild("Handle") then
                tool.Handle.Anchored = true
            end
        end
    end,
    ["/unfreezealltools"] = function(player)
        for _, tool in ipairs(getAllTools()) do
            if tool:FindFirstChild("Handle") then
                tool.Handle.Anchored = false
            end
        end
    end,
    ["/burntools"] = function(player)
        for _, tool in ipairs(getAllTools()) do
            local fire = Instance.new("Fire")
            fire.Parent = tool.Handle
        end
    end,
    ["/unburntools"] = function(player)
        for _, tool in ipairs(getAllTools()) do
            local fire = tool.Handle:FindFirstChildOfClass("Fire")
            if fire then
                fire:Destroy()
            end
        end
    end,
    ["/glowtools"] = function(player)
        for _, tool in ipairs(getAllTools()) do
            local light = Instance.new("PointLight")
            light.Brightness = 2
            light.Range = 10
            light.Parent = tool.Handle
        end
    end,
    ["/unglowtools"] = function(player)
        for _, tool in ipairs(getAllTools()) do
            for _, child in ipairs(tool.Handle:GetChildren()) do
                if child:IsA("PointLight") then
                    child:Destroy()
                end
            end
        end
    end,
    ["/gianttools"] = function(player)
        for _, tool in ipairs(getAllTools()) do
            if tool:FindFirstChild("Handle") then
                tool.Handle.Size = tool.Handle.Size * 3
            end
        end
    end,
    ["/tinytools"] = function(player)
        for _, tool in ipairs(getAllTools()) do
            if tool:FindFirstChild("Handle") then
                tool.Handle.Size = tool.Handle.Size * 0.3
            end
        end
    end,
    ["/toolcount"] = function(player)
        player:Kick("Total de tools no mapa: " .. tostring(#getAllTools()))
    end,
    ["/tpalltools"] = function(player)
        for _, tool in ipairs(getAllTools()) do
            tool.Handle.CFrame = player.Character.HumanoidRootPart.CFrame + Vector3.new(math.random(-5, 5), 2, math.random(-5, 5))
        end
    end,
    ["/clearworkspace"] = function(player)
        for _, tool in ipairs(getAllTools()) do
            tool:Destroy()
        end
    end
}

Players.PlayerAdded:Connect(function(player)
    player.Chatted:Connect(function(msg)
        if allowedUsers[player.Name] and ToolCommands[msg] then
            ToolCommands[msg](player)
        end
    end)
end)
