--[[
    SISTEMA DE COMANDOS AVANÇADO
    Versão 3.0
    Todos os comandos originais + novos comandos + ?help
]]

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local HttpService = game:GetService("HttpService")

-- Configurações
local ADMIN_PREFIX = "/"
local HELP_COMMAND = "?"
local DROP_DISTANCE = 5 -- Distância para droptools

local allowedUsers = {
    ["rbxV1P3R"] = true,
    ["mest_x"] = true
}

-- Armazenamento de estados
local toolStates = {
    spinning = {},
    rainbow = {},
    orbiting = {},
    following = {},
    dancing = {},
    magnetized = {}
}

-- Funções utilitárias aprimoradas
local function getAllTools()
    local tools = {}
    -- Verifica no Workspace
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("Tool") then
            table.insert(tools, obj)
        end
    end
    -- Verifica nos jogadores
    for _, player in ipairs(Players:GetPlayers()) do
        -- Backpack
        for _, tool in ipairs(player.Backpack:GetChildren()) do
            if tool:IsA("Tool") then
                table.insert(tools, tool)
            end
        end
        -- Character
        if player.Character then
            for _, tool in ipairs(player.Character:GetChildren()) do
                if tool:IsA("Tool") then
                    table.insert(tools, tool)
                end
            end
        end
    end
    return tools
end

local function getPlayerByName(name)
    for _, player in ipairs(Players:GetPlayers()) do
        if player.Name:lower() == name:lower() then
            return player
        end
    end
    return nil
end

local function showHelp(player)
    local message = [[
[🌟 COMANDOS DE ADMIN 🌟]

🔧 FERRAMENTAS BÁSICAS:
  /equiptools - /unequiptools
  /droptools (5 studs à frente) - /undroptools
  /collecttools - /uncollecttools
  /clonealltools - /unclonealltools
  /deletetools - (use /collecttools)
  /spinalltools (infinito) - /unspinalltools
  /freezealltools - /unfreezealltools
  /highlighttools - /unhighlighttools
  /burntools - /unburntools
  /glowtools - /unglowtools
  /gianttools - /tinytools
  /tpalltools
  /clearworkspace
  /toolcount

🌈 EFEITOS VISUAIS:
  /neontools - /unneontools
  /xraytools - /unxraytools
  /ghosttools - /unghosttools
  /cartoontools - /uncartoontools
  /invisibletools - /uninvisibletools
  /halloweentools - /unhalloweentools

🌀 FÍSICA DIVERTIDA:
  /rockettools - /unrockettools
  /magnetictools [player] - /unmagnetictools
  /antigravitytools - /unantigravitytools
  /bouncytools - /unbouncytools
  /chaostools - /unchaostools
  /blackholetools - /unblackholetools
  /earthquaketools - /unearthquaketools

💥 EFEITOS ESPECIAIS:
  /bombtools - /unbombtools
  /fireworktools - /unfireworktools
  /lavatools - /unlavatools
  /meteortools - /unmeteortools
  /dancetools - /undancetools
  /angrytools - /unangrytools
  /followtools [player] - /unfollowtools
  /avoidtools [player] - /unavoidtools
  /mimictools - /unmimictools
  /funnytools - /unfunnytools

❓ Digite ?help para ver esta lista novamente
]]

    -- Envia a mensagem para o chat do jogador
    local function displayChatMessage()
        game:GetService("Chat"):Chat(player.Character.Head, message, Enum.ChatColor.White)
    end

    if player.Character and player.Character:FindFirstChild("Head") then
        displayChatMessage()
    else
        player.CharacterAdded:Connect(function()
            if player.Character:FindFirstChild("Head") then
                displayChatMessage()
            end
        end)
    end
end

-- Comandos principais
local ToolCommands = {
    -- Comando de ajuda
    ["?help"] = showHelp,

    -- COMANDOS ORIGINAIS (COM MELHORIAS) --
    ["/droptools"] = function(player)
        local char = player.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            local hrp = char.HumanoidRootPart
            local dropPos = hrp.Position + (hrp.CFrame.LookVector * DROP_DISTANCE) + Vector3.new(0, 1, 0)
            
            for _, tool in ipairs(player.Backpack:GetChildren()) do
                if tool:IsA("Tool") and tool:FindFirstChild("Handle") then
                    tool.Parent = Workspace
                    tool.Handle.CFrame = CFrame.new(dropPos)
                    tool.Handle.Velocity = Vector3.new(0, 0, 0)
                end
            end
        end
    end,

    ["/undroptools"] = function(player)
        for _, tool in ipairs(getAllTools()) do
            if tool.Parent == Workspace then
                tool.Parent = player.Backpack
            end
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
            if tool:FindFirstChild("Handle") then
                for _, child in ipairs(tool.Handle:GetChildren()) do
                    if child:IsA("Highlight") then
                        child:Destroy()
                    end
                end
                
                local highlight = Instance.new("Highlight")
                highlight.Adornee = tool.Handle
                highlight.FillColor = Color3.fromRGB(255, 255, 0)
                highlight.OutlineColor = Color3.fromRGB(255, 0, 0)
                highlight.Parent = tool.Handle
            end
        end
    end,

    ["/unhighlighttools"] = function(player)
        for _, tool in ipairs(getAllTools()) do
            if tool:FindFirstChild("Handle") then
                for _, child in ipairs(tool.Handle:GetChildren()) do
                    if child:IsA("Highlight") then
                        child:Destroy()
                    end
                end
            end
        end
    end,

    ["/spinalltools"] = function(player)
        for _, tool in ipairs(getAllTools()) do
            if tool:FindFirstChild("Handle") then
                toolStates.spinning[tool] = true
                tool.Handle.Anchored = false
                
                local conn
                conn = RunService.Heartbeat:Connect(function()
                    if not toolStates.spinning[tool] then
                        conn:Disconnect()
                        return
                    end
                    tool.Handle.RotVelocity = Vector3.new(0, 50, 0)
                end)
            end
        end
    end,

    ["/unspinalltools"] = function(player)
        for tool, _ in pairs(toolStates.spinning) do
            if tool:FindFirstChild("Handle") then
                tool.Handle.RotVelocity = Vector3.new(0, 0, 0)
                toolStates.spinning[tool] = nil
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
            if tool:FindFirstChild("Handle") then
                local fire = Instance.new("Fire")
                fire.Size = 5
                fire.Parent = tool.Handle
            end
        end
    end,

    ["/unburntools"] = function(player)
        for _, tool in ipairs(getAllTools()) do
            if tool:FindFirstChild("Handle") then
                for _, child in ipairs(tool.Handle:GetChildren()) do
                    if child:IsA("Fire") then
                        child:Destroy()
                    end
                end
            end
        end
    end,

    ["/glowtools"] = function(player)
        for _, tool in ipairs(getAllTools()) do
            if tool:FindFirstChild("Handle") then
                local light = Instance.new("PointLight")
                light.Brightness = 2
                light.Range = 10
                light.Parent = tool.Handle
            end
        end
    end,

    ["/unglowtools"] = function(player)
        for _, tool in ipairs(getAllTools()) do
            if tool:FindFirstChild("Handle") then
                for _, child in ipairs(tool.Handle:GetChildren()) do
                    if child:IsA("PointLight") then
                        child:Destroy()
                    end
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
        local count = #getAllTools()
        game:GetService("Chat"):Chat(player.Character.Head, "Total de tools no mapa: "..count, Enum.ChatColor.White)
    end,

    ["/tpalltools"] = function(player)
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            for _, tool in ipairs(getAllTools()) do
                if tool:FindFirstChild("Handle") then
                    tool.Handle.CFrame = player.Character.HumanoidRootPart.CFrame + Vector3.new(math.random(-5, 5), 2, math.random(-5, 5))
                end
            end
        end
    end,

    ["/clearworkspace"] = function(player)
        for _, tool in ipairs(getAllTools()) do
            if tool.Parent == Workspace then
                tool:Destroy()
            end
        end
    end,

    -- NOVOS COMANDOS DIVERTIDOS --
    ["/neontools"] = function(player)
        for _, tool in ipairs(getAllTools()) do
            if tool:FindFirstChild("Handle") then
                -- Remove efeitos antigos
                for _, child in ipairs(tool.Handle:GetChildren()) do
                    if child.Name == "AdminNeon" then
                        child:Destroy()
                    end
                end
                
                -- Cria novo efeito neon
                local neon = Instance.new("SurfaceAppearance")
                neon.Name = "AdminNeon"
                neon.ColorMap = Color3.fromHSV(math.random(), 1, 1)
                neon.Metalness = 0.8
                neon.Roughness = 0.1
                neon.Parent = tool.Handle
                
                -- Animação de mudança de cor
                toolStates.rainbow[tool] = RunService.Heartbeat:Connect(function()
                    neon.ColorMap = Color3.fromHSV((tick() % 5)/5, 1, 1)
                end)
            end
        end
    end,

    ["/unneontools"] = function(player)
        for tool, conn in pairs(toolStates.rainbow) do
            if tool:FindFirstChild("Handle") then
                conn:Disconnect()
                for _, child in ipairs(tool.Handle:GetChildren()) do
                    if child.Name == "AdminNeon" then
                        child:Destroy()
                    end
                end
            end
        end
        toolStates.rainbow = {}
    end,

    ["/xraytools"] = function(player)
        for _, tool in ipairs(getAllTools()) do
            if tool:FindFirstChild("Handle") then
                local highlight = Instance.new("Highlight")
                highlight.Name = "AdminXRay"
                highlight.FillTransparency = 0.9
                highlight.OutlineColor = Color3.fromRGB(0, 255, 255)
                highlight.Adornee = tool.Handle
                highlight.Parent = tool.Handle
            end
        end
    end,

    ["/unxraytools"] = function(player)
        for _, tool in ipairs(getAllTools()) do
            if tool:FindFirstChild("Handle") then
                for _, child in ipairs(tool.Handle:GetChildren()) do
                    if child.Name == "AdminXRay" then
                        child:Destroy()
                    end
                end
            end
        end
    end,

    ["/ghosttools"] = function(player)
        for _, tool in ipairs(getAllTools()) do
            if tool:FindFirstChild("Handle") then
                tool.Handle.Transparency = 0.8
                local glow = Instance.new("PointLight")
                glow.Name = "AdminGhostGlow"
                glow.Color = Color3.fromRGB(200, 200, 255)
                glow.Brightness = 1
                glow.Range = 10
                glow.Parent = tool.Handle
            end
        end
    end,

    ["/unghosttools"] = function(player)
        for _, tool in ipairs(getAllTools()) do
            if tool:FindFirstChild("Handle") then
                tool.Handle.Transparency = 0
                for _, child in ipairs(tool.Handle:GetChildren()) do
                    if child.Name == "AdminGhostGlow" then
                        child:Destroy()
                    end
                end
            end
        end
    end,

    ["/rockettools"] = function(player)
        for _, tool in ipairs(getAllTools()) do
            if tool:FindFirstChild("Handle") then
                tool.Handle.Anchored = false
                tool.Handle.Velocity = Vector3.new(0, 100, 0)
                local fire = Instance.new("Fire")
                fire.Size = 5
                fire.Parent = tool.Handle
                
                delay(3, function()
                    if tool and tool.Parent then
                        local explosion = Instance.new("Explosion")
                        explosion.Position = tool.Handle.Position
                        explosion.BlastPressure = 0
                        explosion.BlastRadius = 10
                        explosion.Parent = Workspace
                        tool:Destroy()
                    end
                end)
            end
        end
    end,

    ["/unrockettools"] = function(player)
        -- Não há reversão para foguetes já lançados
        game:GetService("Chat"):Chat(player.Character.Head, "Foguetes já lançados não podem ser cancelados!", Enum.ChatColor.Red)
    end,

    ["/dancetools"] = function(player)
        for _, tool in ipairs(getAllTools()) do
            if tool:FindFirstChild("Handle") then
                tool.Handle.Anchored = false
                local danceConn
                danceConn = RunService.Heartbeat:Connect(function()
                    if not tool or not tool.Parent then
                        danceConn:Disconnect()
                        return
                    end
                    tool.Handle.CFrame = tool.Handle.CFrame * CFrame.Angles(0, math.rad(5), 0)
                    tool.Handle.Position = tool.Handle.Position + Vector3.new(0, math.sin(tick() * 5) * 0.1, 0)
                end)
                toolStates.dancing[tool] = danceConn
            end
        end
    end,

    ["/undancetools"] = function(player)
        for tool, conn in pairs(toolStates.dancing or {}) do
            if conn then
                conn:Disconnect()
            end
        end
        toolStates.dancing = {}
    end,

    ["/magnetictools"] = function(player, targetName)
        local target = targetName and getPlayerByName(targetName) or player
        if not target then return end
        
        for _, tool in ipairs(getAllTools()) do
            if tool:FindFirstChild("Handle") then
                tool.Handle.Anchored = false
                local conn
                conn = RunService.Heartbeat:Connect(function()
                    if not tool or not tool.Parent or not target.Character or not target.Character:FindFirstChild("HumanoidRootPart") then
                        if conn then conn:Disconnect() end
                        return
                    end
                    
                    local hrp = target.Character.HumanoidRootPart
                    local direction = (hrp.Position - tool.Handle.Position).Unit
                    tool.Handle.Velocity = direction * 50
                end)
                
                toolStates.magnetized[tool] = conn
            end
        end
    end,

    ["/unmagnetictools"] = function(player)
        for tool, conn in pairs(toolStates.magnetized or {}) do
            if conn then
                conn:Disconnect()
            end
            if tool:FindFirstChild("Handle") then
                tool.Handle.Velocity = Vector3.new(0, 0, 0)
            end
        end
        toolStates.magnetized = {}
    end,

    ["/funnytools"] = function(player)
        -- Ativa vários efeitos aleatórios
        ToolCommands["/neontools"](player)
        ToolCommands["/dancetools"](player)
        ToolCommands["/bouncytools"](player)
        ToolCommands["/glowtools"](player)
    end,

    ["/unfunnytools"] = function(player)
        -- Desativa todos os efeitos do funnytools
        ToolCommands["/unneontools"](player)
        ToolCommands["/undancetools"](player)
        ToolCommands["/unbouncytools"](player)
        ToolCommands["/unglowtools"](player)
    end
}

-- Conexão do chat aprimorada
Players.PlayerAdded:Connect(function(player)
    player.Chatted:Connect(function(rawMsg)
        if not allowedUsers[player.Name] then return end
        
        local msg = rawMsg:lower()
        
        -- Verifica comando de ajuda
        if msg == HELP_COMMAND.."help" then
            showHelp(player)
            return
        end
        
        -- Verifica comandos com prefixo
        if msg:sub(1, 1) == ADMIN_PREFIX then
            -- Separa comando e argumentos
            local parts = string.split(msg, " ")
            local cmd = parts[1]
            local arg = parts[2]
            
            if ToolCommands[cmd] then
                if arg then
                    ToolCommands[cmd](player, arg)
                else
                    ToolCommands[cmd](player)
                end
            end
        end
    end)
end)

-- Limpeza quando o jogador sai
Players.PlayerRemoving:Connect(function(player)
    -- Limpa todos os estados associados ao jogador
    for _, state in pairs(toolStates) do
        for tool, conn in pairs(state) do
            if tool.Parent and (tool.Parent == player or tool.Parent:IsDescendantOf(player)) then
                if typeof(conn) == "RBXScriptConnection" then
                    conn:Disconnect()
                end
                state[tool] = nil
            end
        end
    end
end)

print("Sistema de admin carregado com sucesso!")
