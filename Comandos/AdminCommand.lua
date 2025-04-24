local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local module = {}

-- Lista de administradores permitidos
local ADMINS = {
    ["mest_x"] = true,
    ["rbxV1P3R"] = true
}

-- Função para verificar permissão
local function IsAdmin(player)
    return ADMINS[player.Name] or player:GetAttribute("IsAdmin") == true
end

-- Função para executar comandos com verificação
local function ExecuteCommand(player, commandFunc, ...)
    if IsAdmin(player) then
        commandFunc(player, ...)
    else
        SendMessage(player, "🚫 Você não tem permissão para usar este comando!")
    end
end

-- Função de mensagem
function SendMessage(player, message)
    local msg = Instance.new("Message")
    msg.Text = tostring(message)
    msg.Parent = player:FindFirstChildOfClass("PlayerGui") or Workspace
    delay(2, function() msg:Destroy() end)
end

-- Função para encontrar jogador pelo nome parcial
local function FindPlayer(name)
    name = name:lower()
    for _, player in ipairs(Players:GetPlayers()) do
        if player.Name:lower():find(name) == 1 then
            return player
        end
    end
    return nil
end

-- Comandos Administrativos --

-- Comando /god (imortalidade)
module.god = function(player)
    ExecuteCommand(player, function(player)
        local char = player.Character
        if char then
            local humanoid = char:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.Health = humanoid.MaxHealth
                if not humanoid:GetAttribute("GodMode") then
                    humanoid:SetAttribute("GodMode", true)
                    humanoid.Died:Connect(function()
                        if humanoid:GetAttribute("GodMode") then
                            humanoid.Health = humanoid.MaxHealth
                        end
                    end)
                    SendMessage(player, "🛡️ Você agora é imortal!")
                else
                    humanoid:SetAttribute("GodMode", false)
                    SendMessage(player, "🛡️ Imortalidade desativada!")
                end
            end
        end
    end)
end

-- Comando /fly (voar)
module.fly = function(player)
    ExecuteCommand(player, function(player)
        local char = player.Character
        if char then
            local humanoid = char:FindFirstChildOfClass("Humanoid")
            if humanoid then
                if not humanoid:FindFirstChild("FlyController") then
                    -- Código para ativar voo
                    local bodyGyro = Instance.new("BodyGyro")
                    bodyGyro.Name = "FlyController"
                    bodyGyro.P = 10000
                    bodyGyro.D = 1000
                    bodyGyro.MaxTorque = Vector3.new(10000, 10000, 10000)
                    bodyGyro.CFrame = char.HumanoidRootPart.CFrame
                    bodyGyro.Parent = char.HumanoidRootPart

                    local bodyVelocity = Instance.new("BodyVelocity")
                    bodyVelocity.Name = "FlyVelocity"
                    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
                    bodyVelocity.MaxForce = Vector3.new(10000, 10000, 10000)
                    bodyVelocity.Parent = char.HumanoidRootPart

                    humanoid.PlatformStand = true
                    
                    SendMessage(player, "🦅 Modo voo ativado! Use W/A/S/D/Q/E para voar")
                else
                    -- Código para desativar voo
                    humanoid.PlatformStand = false
                    char.HumanoidRootPart:FindFirstChild("FlyController"):Destroy()
                    char.HumanoidRootPart:FindFirstChild("FlyVelocity"):Destroy()
                    SendMessage(player, "🦅 Modo voo desativado!")
                end
            end
        end
    end)
end

-- Comando /kill (matar jogador)
module.kill = function(player, targetName)
    ExecuteCommand(player, function(player, targetName)
        local target = FindPlayer(targetName)
        if target then
            local targetHumanoid = target.Character and target.Character:FindFirstChildOfClass("Humanoid")
            if targetHumanoid then
                targetHumanoid.Health = 0
                SendMessage(player, "💀 Você matou "..target.Name)
                SendMessage(target, "💀 Você foi morto por "..player.Name)
            end
        else
            SendMessage(player, "❌ Jogador não encontrado!")
        end
    end, targetName)
end

-- Comando /tp (teleportar para jogador)
module.tp = function(player, targetName)
    ExecuteCommand(player, function(player, targetName)
        local target = FindPlayer(targetName)
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            player.Character:MoveTo(target.Character.HumanoidRootPart.Position)
            SendMessage(player, "🔮 Você foi teleportado para "..target.Name)
        else
            SendMessage(player, "❌ Jogador não encontrado ou sem personagem!")
        end
    end, targetName)
end

-- Comando /bring (trazer jogador)
module.bring = function(player, targetName)
    ExecuteCommand(player, function(player, targetName)
        local target = FindPlayer(targetName)
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            target.Character:MoveTo(player.Character.HumanoidRootPart.Position)
            SendMessage(player, "🔮 Você trouxe "..target.Name)
            SendMessage(target, "🔮 Você foi trazido por "..player.Name)
        else
            SendMessage(player, "❌ Jogador não encontrado ou sem personagem!")
        end
    end, targetName)
end

-- Comando /kick (expulsar jogador)
module.kick = function(player, targetName)
    ExecuteCommand(player, function(player, targetName)
        local target = FindPlayer(targetName)
        if target then
            target:Kick("🚪 Você foi expulso por "..player.Name)
            SendMessage(player, "🚪 Você expulsou "..target.Name)
        else
            SendMessage(player, "❌ Jogador não encontrado!")
        end
    end, targetName)
end

-- Comando /freeze (congelar jogador)
module.freeze = function(player, targetName)
    ExecuteCommand(player, function(player, targetName)
        local target = FindPlayer(targetName)
        if target and target.Character then
            local char = target.Character
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.Anchored = not part.Anchored
                end
            end
            local status = char:FindFirstChildOfClass("BasePart").Anchored and "❄️ congelado" or "🔥 descongelado"
            SendMessage(player, string.format("%s foi %s", target.Name, status))
            SendMessage(target, string.format("Você foi %s por %s", status, player.Name))
        else
            SendMessage(player, "❌ Jogador não encontrado ou sem personagem!")
        end
    end, targetName)
end

-- Comando /speed (alterar velocidade)
module.speed = function(player, speedValue)
    ExecuteCommand(player, function(player, speedValue)
        local speed = tonumber(speedValue) or 16
        local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = speed
            SendMessage(player, "🏃‍♂️ Sua velocidade foi alterada para "..speed)
        end
    end, speedValue)
end

-- Comando /clone (cria uma cópia NPC do seu personagem)
module.clone = function(player)
    ExecuteCommand(player, function(player)
        local char = player.Character
        if char then
            local clone = char:Clone()
            clone.Parent = Workspace
            clone:SetPrimaryPartCFrame(char.PrimaryPart.CFrame * CFrame.new(5, 0, 0))
            SendMessage(player, "👥 Clone criado com sucesso!")
        end
    end)
end

-- Comando /removetool [nome-da-ferramenta] (remove uma ferramenta do inventário)
module.removetool = function(player, toolName)
    ExecuteCommand(player, function(player, toolName)
        local tool = player.Backpack:FindFirstChild(toolName) or player.Character:FindFirstChild(toolName)
        if tool and tool:IsA("Tool") then
            tool:Destroy()
            SendMessage(player, "🗑️ Ferramenta '"..toolName.."' removida!")
        else
            SendMessage(player, "❌ Ferramenta '"..toolName.."' não encontrada no seu inventário!")
        end
    end, toolName)
end

-- Comando /resetallmap (reinicia o mapa sem apagar itens essenciais)
module.resetallmap = function(player)
    ExecuteCommand(player, function(player)
        -- Preserva spawn points e outros objetos críticos
        local preservedParts = {}
        for _, obj in ipairs(Workspace:GetChildren()) do
            if obj:IsA("BasePart") and (obj.Name:find("Spawn") or obj.Name:find("Floor")) then
                table.insert(preservedParts, obj:Clone())
            end
        end

        -- Limpa o workspace (exceto personagens)
        for _, obj in ipairs(Workspace:GetChildren()) do
            if not obj:IsA("Model") or not Players:GetPlayerFromCharacter(obj) then
                obj:Destroy()
            end
        end

        -- Recria os itens preservados
        for _, part in ipairs(preservedParts) do
            part.Parent = Workspace
        end

        SendMessage(player, "🌍 Mapa reiniciado com sucesso!")
    end)
end

-- Comando /stealtool [nome-do-jogador] (rouba a primeira ferramenta do inventário de outro jogador)
module.stealtool = function(player, targetName)
    ExecuteCommand(player, function(player, targetName)
        local target = FindPlayer(targetName)
        if target then
            local targetTool = target.Backpack:FindFirstChildOfClass("Tool") or target.Character:FindFirstChildOfClass("Tool")
            if targetTool then
                targetTool:Clone().Parent = player.Backpack
                SendMessage(player, "🦹 Você roubou a ferramenta '"..targetTool.Name.."' de "..target.Name)
            else
                SendMessage(player, "❌ "..target.Name.." não possui ferramentas no inventário!")
            end
        else
            SendMessage(player, "❌ Jogador '"..targetName.."' não encontrado!")
        end
    end, targetName)
end

--[[ Comando /unjail [nome-do-jogador] (liberta um jogador preso - versão alternativa)
module.unjail = function(player, targetName)
    ExecuteCommand(player, function(player, targetName)
        local target = FindPlayer(targetName)
        if target then
            local jail = Workspace:FindFirstChild(target.Name.."_Jail")
            if jail then
                jail:Destroy()
                SendMessage(player, "🔓 Você libertou "..target.Name.." da prisão!")
                SendMessage(target, "🔓 Você foi libertado por "..player.Name)
            else
                SendMessage(player, "❌ "..target.Name.." não está preso!")
            end
        else
            SendMessage(player, "❌ Jogador '"..targetName.."' não encontrado!")
        end
    end, targetName)
end ]]--

-- Comando /jump (alterar altura do pulo)
module.jump = function(player, jumpValue)
    ExecuteCommand(player, function(player, jumpValue)
        local jump = tonumber(jumpValue) or 50
        local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.JumpPower = jump
            SendMessage(player, "🦘 Seu pulo foi alterado para "..jump)
        end
    end, jumpValue)
end

-- Comando /invisible (ficar invisível)
module.invisible = function(player)
    ExecuteCommand(player, function(player)
        local char = player.Character
        if char then
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.Transparency = part.Transparency == 1 and 0 or 1
                end
            end
            local status = char:FindFirstChildOfClass("BasePart").Transparency == 1 and "👻 invisível" or "👀 visível"
            SendMessage(player, "Você está agora "..status)
        end
    end)
end

-- Comando /admin (dar admin para alguém)
module.admin = function(player, targetName)
    -- Apenas os admins originais podem usar este comando
    if ADMINS[player.Name] then
        local target = FindPlayer(targetName)
        if target then
            target:SetAttribute("IsAdmin", true)
            SendMessage(player, "👑 Você deu admin para "..target.Name)
            SendMessage(target, "👑 Você recebeu permissões de admin de "..player.Name)
        else
            SendMessage(player, "❌ Jogador não encontrado!")
        end
    else
        SendMessage(player, "🚫 Você não tem permissão para usar este comando!")
    end
end

-- Comando /unadmin (remover admin de alguém)
module.unadmin = function(player, targetName)
    -- Apenas os admins originais podem usar este comando
    if ADMINS[player.Name] then
        local target = FindPlayer(targetName)
        if target then
            target:SetAttribute("IsAdmin", false)
            SendMessage(player, "👑 Você removeu admin de "..target.Name)
            SendMessage(target, "👑 Suas permissões de admin foram removidas por "..player.Name)
        else
            SendMessage(player, "❌ Jogador não encontrado!")
        end
    else
        SendMessage(player, "🚫 Você não tem permissão para usar este comando!")
    end
end

-- Comando /reset (resetar personagem)
module.reset = function(player)
    ExecuteCommand(player, function(player)
        local char = player.Character
        if char then
            char:BreakJoints()
            SendMessage(player, "🔄 Seu personagem foi resetado")
        end
    end)
end

-- Comando /day (definir para dia)
module.day = function(player)
    ExecuteCommand(player, function(player)
        Lighting.ClockTime = 14
        Lighting.GlobalShadows = false
        SendMessage(player, "☀️ Hora definida para dia")
    end)
end

-- Comando /night (definir para noite)
module.night = function(player)
    ExecuteCommand(player, function(player)
        Lighting.ClockTime = 0
        Lighting.GlobalShadows = true
        SendMessage(player, "🌙 Hora definida para noite")
    end)
end

-- Comando /time (definir hora específica)
module.time = function(player, timeValue)
    ExecuteCommand(player, function(player, timeValue)
        local time = tonumber(timeValue)
        if time and time >= 0 and time <= 24 then
            Lighting.ClockTime = time
            SendMessage(player, "⏰ Hora definida para "..time)
        else
            SendMessage(player, "❌ Hora inválida! Use entre 0 e 24")
        end
    end, timeValue)
end

-- Comando /fire (colocar fogo no jogador)
module.fire = function(player, targetName)
    ExecuteCommand(player, function(player, targetName)
        local target = FindPlayer(targetName)
        if target and target.Character then
            local char = target.Character
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") and not part:FindFirstChildOfClass("Fire") then
                    local fire = Instance.new("Fire")
                    fire.Size = 5
                    fire.Heat = 10
                    fire.Parent = part
                end
            end
            SendMessage(player, "🔥 Você colocou fogo em "..target.Name)
            SendMessage(target, "🔥 "..player.Name.." colocou fogo em você!")
        else
            SendMessage(player, "❌ Jogador não encontrado ou sem personagem!")
        end
    end, targetName)
end

-- Comando /unfire (remover fogo do jogador)
module.unfire = function(player, targetName)
    ExecuteCommand(player, function(player, targetName)
        local target = FindPlayer(targetName)
        if target and target.Character then
            local char = target.Character
            for _, fire in ipairs(char:GetDescendants()) do
                if fire:IsA("Fire") then
                    fire:Destroy()
                end
            end
            SendMessage(player, "🧯 Você removeu o fogo de "..target.Name)
            SendMessage(target, "🧯 "..player.Name.." removeu o fogo de você!")
        else
            SendMessage(player, "❌ Jogador não encontrado ou sem personagem!")
        end
    end, targetName)
end

-- Comando /explode (explodir jogador)
module.explode = function(player, targetName)
    ExecuteCommand(player, function(player, targetName)
        local target = FindPlayer(targetName)
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            local explosion = Instance.new("Explosion")
            explosion.Position = target.Character.HumanoidRootPart.Position
            explosion.BlastPressure = 100000
            explosion.BlastRadius = 10
            explosion.Parent = Workspace
            SendMessage(player, "💣 Você explodiu "..target.Name)
            SendMessage(target, "💣 Você foi explodido por "..player.Name)
        else
            SendMessage(player, "❌ Jogador não encontrado ou sem personagem!")
        end
    end, targetName)
end

-- Comando /heal (curar jogador)
module.heal = function(player, targetName)
    ExecuteCommand(player, function(player, targetName)
        local target = targetName and FindPlayer(targetName) or player
        if target and target.Character then
            local humanoid = target.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.Health = humanoid.MaxHealth
                SendMessage(player, "❤️ Você curou "..target.Name)
                if target ~= player then
                    SendMessage(target, "❤️ Você foi curado por "..player.Name)
                end
            end
        else
            SendMessage(player, "❌ Jogador não encontrado ou sem personagem!")
        end
    end, targetName)
end

-- Comando /tools (pegar todas as ferramentas)
module.tools = function(player)
    ExecuteCommand(player, function(player)
        for _, tool in ipairs(Workspace:GetChildren()) do
            if tool:IsA("Tool") then
                tool.Parent = player.Backpack
            end
        end
        SendMessage(player, "🛠️ Você pegou todas as ferramentas do mapa")
    end)
end

-- Comando /clear (limpar inventário)
module.clear = function(player)
    ExecuteCommand(player, function(player)
        for _, item in ipairs(player.Backpack:GetChildren()) do
            if item:IsA("Tool") then
                item:Destroy()
            end
        end
        SendMessage(player, "🗑️ Seu inventário foi limpo")
    end)
end

-- Comando /jail (prender jogador)
module.jail = function(player, targetName)
    ExecuteCommand(player, function(player, targetName)
        local target = FindPlayer(targetName)
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            -- Verifica se já existe uma jaula
            local jail = Workspace:FindFirstChild(target.Name.."_Jail")
            if jail then
                jail:Destroy()
                SendMessage(player, "🏰 Você libertou "..target.Name.." da prisão")
                SendMessage(target, "🏰 Você foi libertado da prisão por "..player.Name)
            else
                -- Cria uma nova jaula
                jail = Instance.new("Model")
                jail.Name = target.Name.."_Jail"
                
                local base = Instance.new("Part")
                base.Size = Vector3.new(10, 1, 10)
                base.Anchored = true
                base.Position = target.Character.HumanoidRootPart.Position - Vector3.new(0, 3, 0)
                base.Parent = jail
                
                for i = 1, 4 do
                    local wall = Instance.new("Part")
                    wall.Size = Vector3.new(1, 8, 10)
                    wall.Anchored = true
                    wall.Position = base.Position + Vector3.new(i%2==0 and 4.5 or -4.5, 4, i>2 and 4.5 or -4.5)
                    if i%2 == 1 then
                        wall.Size = Vector3.new(10, 8, 1)
                    end
                    wall.Parent = jail
                end
                
                jail.Parent = Workspace
                target.Character:MoveTo(base.Position + Vector3.new(0, 3, 0))
                
                SendMessage(player, "🏰 Você prendeu "..target.Name)
                SendMessage(target, "🏰 Você foi preso por "..player.Name)
            end
        else
            SendMessage(player, "❌ Jogador não encontrado ou sem personagem!")
        end
    end, targetName)
end

-- Comando /gravity (alterar gravidade)
module.gravity = function(player, gravityValue)
    ExecuteCommand(player, function(player, gravityValue)
        local gravity = tonumber(gravityValue) or 196.2
        Workspace.Gravity = gravity
        SendMessage(player, "🌍 Gravidade alterada para "..gravity)
    end, gravityValue)
end

-- Comando /players (listar jogadores online)
module.players = function(player)
    ExecuteCommand(player, function(player)
        local playerList = {}
        for _, plr in ipairs(Players:GetPlayers()) do
            table.insert(playerList, plr.Name)
        end
        SendMessage(player, "👥 Jogadores online: "..table.concat(playerList, ", "))
    end)
end

-- Comando /cmds (mostrar comandos disponíveis)
module.cmds = function(player)
    ExecuteCommand(player, function(player)
        local commands = {
            "/god - Ativa/desativa imortalidade",
            "/fly - Ativa/desativa modo voo",
            "/kill [jogador] - Mata um jogador",
            "/tp [jogador] - Teleporta para um jogador",
            "/bring [jogador] - Traz um jogador para você",
            "/kick [jogador] - Expulsa um jogador",
            "/freeze [jogador] - Congela/descongela um jogador",
            "/speed [valor] - Altera sua velocidade",
            "/clone (cria uma cópia NPC do seu personagem)",
            "/removetool [nome-da-ferramenta] (remove uma ferramenta do inventário)",
            "/resetallmap (reinicia o mapa sem apagar itens essenciais)",
            "/stealtool [nome-do-jogador] (rouba a primeira ferramenta do inventário de outro jogador)",
            "/jump [valor] - Altera altura do pulo",
            "/invisible - Fica invisível/visível",
            "/reset - Reseta seu personagem",
            "/day - Define para dia",
            "/night - Define para noite",
            "/time [hora] - Define hora específica (0-24)",
            "/fire [jogador] - Coloca fogo em um jogador",
            "/unfire [jogador] - Remove fogo de um jogador",
            "/explode [jogador] - Explode um jogador",
            "/heal [jogador] - Cura um jogador (ou você)",
            "/tools - Pega todas as ferramentas do mapa",
            "/clear - Limpa seu inventário",
            "/jail [jogador] - Prende/solta um jogador",
            "/gravity [valor] - Altera a gravidade",
            "/players - Lista jogadores online",
            "/cmds - Mostra esta lista de comandos"
        }
        
        SendMessage(player, "📜 Lista de comandos disponíveis:")
        for _, cmd in ipairs(commands) do
            wait(0.5)
            SendMessage(player, cmd)
        end
    end)
end

return module
