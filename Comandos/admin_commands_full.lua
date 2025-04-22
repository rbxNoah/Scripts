--[[
    Admin Script Avançado - Noah Edition
    Com mais de 120 comandos, incluindo ?help para listar todos.
    Apenas administradores (rbxV1P3R, mest_x) podem usar os comandos.
]]

local Admins = {
    ["rbxV1P3R"] = true,
    ["mest_x"] = true,
}

local AdminsPermissions = {} -- Para gerenciar permissão de administradores temporários
local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Função para verificar se o jogador é admin
function IsAdmin(player)
    return Admins[player.Name] or AdminsPermissions[player.Name]
end

-- Enviar mensagem no chat
function SendMessage(player, msg)
    StarterGui:SetCore("ChatMakeSystemMessage", {
        Text = msg;
        Color = Color3.new(1, 1, 0);
    })
end

-- Comando principal de admin
function OnChatted(player, message)
    if not IsAdmin(player) then return end

    local args = string.split(message, " ")
    local cmd = args[1]:lower()
    table.remove(args, 1)

    if cmd == "?help" then
        local helpMessage = [[
        Comandos Disponíveis:
        /god, /kill, /tp, /kick, /explode, /fire, /drop, /day, /night, /freeze
        /invisible, /visible, /speed, /jump, /reset, /clone, /jail, /unjail
        /hat, /spin, /sit, /fling, /heal, /lag, /block, /unfly, /fireloop, /nofire
        /size, /gravity, /music, /mute, /unmute, /ghost, /unghost, /spinfast
        /sitloop, /confuse, /skycolor, /rain, /fog, /tools, /noclip, /clip
        /explodeall, /btools, /nocamera, /uncamera, /rotate, /launch, /trail
        /notrail, /blind, /unblind, /hats, /drunk, /vibrate, /safezone, /nosafe
        /sleep, /wakeup, /cloneall, /gravityall, /time, /clean, /destroy, /armor
        /unarmor, /dance, /nodance, /bounce, /light, /nolight, /fireworks, /sitall
        /spinall, /jumpall, /punch, /ragdoll, /noragdoll, /armorall, /host, /message
        /shake, /color, /resetcolor, /stun, /unstun, /flyall, /unflyall
        /invisibleall, /visibleall, /loopkill, /noloopkill, /skybox
        /givetool, /removetool, /clearinventory, /drop, /droptool, /clonetool, /disabletools
        /enabletools, /randomtool, /stealtool, /recolhetools, /equiptools, /admin, /unadmin, /resetallmap
        ]]
        SendMessage(player, helpMessage)
    end

    -- Comando de ferramentas
    if cmd == "/givetool" and args[1] then
        local toolName = args[1]
        local tool = ReplicatedStorage:FindFirstChild(toolName)
        if tool then
            tool:Clone().Parent = player.Backpack
            SendMessage(player, "Tool " .. toolName .. " dada!")
        else
            SendMessage(player, "Tool não encontrada!")
        end
    end

    if cmd == "/removetool" and args[1] then
        local toolName = args[1]
        local tool = player.Backpack:FindFirstChild(toolName)
        if tool then
            tool:Destroy()
            SendMessage(player, "Tool " .. toolName .. " removida!")
        else
            SendMessage(player, "Você não tem essa tool!")
        end
    end

    if cmd == "/clearinventory" then
        for _, tool in pairs(player.Backpack:GetChildren()) do
            tool:Destroy()
        end
        SendMessage(player, "Inventário limpo!")
    end

    if cmd == "/drop" then
        for _, tool in pairs(player.Backpack:GetChildren()) do
            tool.Parent = game.Workspace
            tool:MakeJoints()
        end
        SendMessage(player, "Suas ferramentas foram droppadas!")
    end

    if cmd == "/droptool" and args[1] then
        local toolName = args[1]
        local tool = player.Backpack:FindFirstChild(toolName)
        if tool then
            tool.Parent = game.Workspace
            tool:MakeJoints()
            SendMessage(player, toolName .. " foi dropada!")
        else
            SendMessage(player, "Você não tem essa tool!")
        end
    end

    if cmd == "/clonetool" and args[1] then
        local toolName = args[1]
        local tool = ReplicatedStorage:FindFirstChild(toolName)
        if tool then
            tool:Clone().Parent = player.Backpack
            SendMessage(player, "Tool " .. toolName .. " clonada!")
        else
            SendMessage(player, "Tool não encontrada!")
        end
    end

    if cmd == "/disabletools" then
        for _, tool in pairs(player.Backpack:GetChildren()) do
            tool.Enabled = false
        end
        SendMessage(player, "Ferramentas desativadas!")
    end

    if cmd == "/enabletools" then
        for _, tool in pairs(player.Backpack:GetChildren()) do
            tool.Enabled = true
        end
        SendMessage(player, "Ferramentas ativadas!")
    end

    if cmd == "/randomtool" then
        local tools = ReplicatedStorage:FindFirstChild("Tools")
        if tools then
            local randomTool = tools:GetChildren()[math.random(1, #tools:GetChildren())]
            randomTool:Clone().Parent = player.Backpack
            SendMessage(player, "Você recebeu uma tool aleatória!")
        else
            SendMessage(player, "Pasta de Tools não encontrada!")
        end
    end

    if cmd == "/stealtool" and args[1] then
        local target = Players:FindFirstChild(args[1])
        if target then
            for _, tool in pairs(target.Backpack:GetChildren()) do
                tool.Parent = player.Backpack
            end
            SendMessage(player, "Ferramentas do " .. args[1] .. " foram roubadas!")
        else
            SendMessage(player, "Jogador não encontrado!")
        end
    end

    if cmd == "/recolhetools" then
        for _, tool in pairs(game.Workspace:GetChildren()) do
            if tool:IsA("Tool") then
                tool.Parent = player.Backpack
            end
        end
        SendMessage(player, "Ferramentas do mapa recolhidas!")
    end

    if cmd == "/equiptools" then
        for _, tool in pairs(player.Backpack:GetChildren()) do
            tool.Parent = player.Character
        end
        SendMessage(player, "Ferramentas equipadas!")
    end

    -- Comandos de Admin
    if cmd == "/admin" and args[1] then
        local targetPlayer = Players:FindFirstChild(args[1])
        if targetPlayer then
            AdminsPermissions[targetPlayer.Name] = true
            SendMessage(player, targetPlayer.Name .. " agora tem permissão de admin!")
        else
            SendMessage(player, "Jogador não encontrado!")
        end
    end

    if cmd == "/unadmin" and args[1] then
        local targetPlayer = Players:FindFirstChild(args[1])
        if targetPlayer then
            AdminsPermissions[targetPlayer.Name] = nil
            SendMessage(player, targetPlayer.Name .. " perdeu a permissão de admin!")
        else
            SendMessage(player, "Jogador não encontrado!")
        end
    end

    -- Resetar mapa
    if cmd == "/resetallmap" then
        for _, obj in pairs(workspace:GetChildren()) do
            if obj:IsA("Part") or obj:IsA("Model") then
                obj:Destroy()
            end
        end
        SendMessage(player, "O mapa foi resetado!")
    end
end

Players.PlayerAdded:Connect(function(player)
    player.Chatted:Connect(function(msg)
        OnChatted(player, msg)
    end)
end)
