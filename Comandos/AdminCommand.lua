-- Comando /god (imortalidade)
module.god = function(player)
    local char = player.Character
    if char then
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.Health = humanoid.MaxHealth
            humanoid.Died:Connect(function()
                humanoid.Health = humanoid.MaxHealth
            end)
            SendMessage(player, "Você agora é imortal.")
        end
    end
end

-- Comando /kill (matar jogador)
module.kill = function(player, targetName)
    local target = Players:FindFirstChild(targetName)
    if target then
        local targetHumanoid = target.Character and target.Character:FindFirstChildOfClass("Humanoid")
        if targetHumanoid then
            targetHumanoid.Health = 0
            SendMessage(player, "Você matou " .. target.Name)
        end
    end
end

-- Comando /tp (teleportar jogador)
module.tp = function(player, targetName)
    local target = Players:FindFirstChild(targetName)
    if target then
        player.Character:SetPrimaryPartCFrame(target.Character.PrimaryPart.CFrame)
        SendMessage(player, "Você foi teleportado para " .. target.Name)
    end
end

-- Comando /kick (expulsar jogador)
module.kick = function(player, targetName)
    local target = Players:FindFirstChild(targetName)
    if target then
        target:Kick("Você foi expulso por um administrador.")
        SendMessage(player, target.Name .. " foi expulso.")
    end
end

-- Comando /explode (explodir jogador)
module.explode = function(player, targetName)
    local target = Players:FindFirstChild(targetName)
    if target then
        local explosion = Instance.new("Explosion")
        explosion.Position = target.Character.PrimaryPart.Position
        explosion.Parent = Workspace
        explosion.Hit:Connect(function(hit)
            if hit.Parent == target.Character then
                hit:Destroy()
            end
        end)
        SendMessage(player, "Você explodiu " .. target.Name)
    end
end

-- Comando /fire (colocar fogo no jogador)
module.fire = function(player, targetName)
    local target = Players:FindFirstChild(targetName)
    if target then
        local char = target.Character
        if char then
            local fire = Instance.new("Fire")
            fire.Parent = char
            fire.Size = 5
            fire.Heat = 15
            SendMessage(player, "Você colocou fogo em " .. target.Name)
        end
    end
end

-- Comando /drop (dropar itens)
module.drop = function(player)
    local backpack = player.Backpack
    for _, item in pairs(backpack:GetChildren()) do
        if item:IsA("Tool") then
            item.Parent = Workspace
            item.CFrame = player.Character.HumanoidRootPart.CFrame * CFrame.new(0, 5, 0)
        end
    end
    SendMessage(player, "Você dropou todos os seus itens.")
end

-- Comando /day (configurar o dia)
module.day = function(player)
    Lighting.ClockTime = 12
    SendMessage(player, "Você configurou o horário para o dia.")
end

-- Comando /night (configurar a noite)
module.night = function(player)
    Lighting.ClockTime = 0
    SendMessage(player, "Você configurou o horário para a noite.")
end

-- Comando /freeze (congelar jogador)
module.freeze = function(player, targetName)
    local target = Players:FindFirstChild(targetName)
    if target then
        local char = target.Character
        if char then
            local freeze = Instance.new("BodyPosition")
            freeze.MaxForce = Vector3.new(10000, 10000, 10000)
            freeze.D = 500
            freeze.P = 10000
            freeze.Parent = char.PrimaryPart
            SendMessage(player, target.Name .. " foi congelado.")
        end
    end
end

-- Comando /invisible (ficar invisível)
module.invisible = function(player)
    local char = player.Character
    if char then
        char:FindFirstChildOfClass("HumanoidRootPart").Transparency = 1
        for _, part in pairs(char:GetChildren()) do
            if part:IsA("BasePart") then
                part.Transparency = 1
            end
        end
        SendMessage(player, "Você agora está invisível.")
    end
end

-- Comando /visible (ficar visível)
module.visible = function(player)
    local char = player.Character
    if char then
        char:FindFirstChildOfClass("HumanoidRootPart").Transparency = 0
        for _, part in pairs(char:GetChildren()) do
            if part:IsA("BasePart") then
                part.Transparency = 0
            end
        end
        SendMessage(player, "Você agora está visível.")
    end
end

-- Comando /speed (ajustar velocidade do jogador)
module.speed = function(player, value)
    local char = player.Character
    if char then
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = tonumber(value)
            SendMessage(player, "Sua velocidade foi ajustada para " .. value)
        end
    end
end

-- Comando /jump (ajustar pulo do jogador)
module.jump = function(player, value)
    local char = player.Character
    if char then
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.JumpHeight = tonumber(value)
            SendMessage(player, "Sua altura de pulo foi ajustada para " .. value)
        end
    end
end

-- Comando /reset (resetar personagem)
module.reset = function(player)
    local char = player.Character
    if char then
        char:BreakJoints()
        SendMessage(player, "Seu personagem foi resetado.")
    end
end

-- Comando /clone (clonar jogador)
module.clone = function(player)
    local char = player.Character
    if char then
        local clonedChar = char:Clone()
        clonedChar.Parent = Workspace
        clonedChar:SetPrimaryPartCFrame(player.Character.PrimaryPart.CFrame * CFrame.new(5, 0, 0))
        SendMessage(player, "Seu personagem foi clonado.")
    end
end

-- Comando /jail (prender jogador)
module.jail = function(player, targetName)
    local target = Players:FindFirstChild(targetName)
    if target then
        local char = target.Character
        if char then
            local jail = Instance.new("Part")
            jail.Size = Vector3.new(10, 10, 10)
            jail.Position = char.HumanoidRootPart.Position
            jail.Anchored = true
            jail.BrickColor = BrickColor.new("Bright red")
            jail.Parent = Workspace
            target.Character:SetPrimaryPartCFrame(jail.CFrame)
            SendMessage(player, target.Name .. " foi preso.")
        end
    end
end

-- Comando /unjail (libertar jogador)
module.unjail = function(player, targetName)
    local target = Players:FindFirstChild(targetName)
    if target then
        local char = target.Character
        if char then
            local jail = Workspace:FindFirstChild(target.Name .. "_Jail")
            if jail then
                jail:Destroy()
                SendMessage(player, target.Name .. " foi libertado da prisão.")
            end
        end
    end
end

-- Comando /admin (dar permissões de admin)
module.admin = function(player)
    player:SetAttribute("IsAdmin", true)
    SendMessage(player, "Você agora é um administrador.")
end

-- Comando /unadmin (remover permissões de admin)
module.unadmin = function(player)
    player:SetAttribute("IsAdmin", false)
    SendMessage(player, "Você não é mais um administrador.")
end

-- Comando /resetallmap (resetar o mapa)
module.resetallmap = function(player)
    -- Apagar todas as partes e ferramentas no mapa
    for _, obj in pairs(Workspace:GetChildren()) do
        if obj:IsA("BasePart") or obj:IsA("Tool") then
            obj:Destroy()
        end
    end
    SendMessage(player, "O mapa foi resetado para o padrão.")
end

-- Comando /givetool (dar uma ferramenta ao jogador)
module.givetool = function(player, toolName)
    local tool = ReplicatedStorage:FindFirstChild(toolName)
    if tool then
        local newTool = tool:Clone()
        newTool.Parent = player.Backpack
        SendMessage(player, "Você recebeu a ferramenta: " .. toolName)
    end
end

-- Comando /removetool (remover uma ferramenta do jogador)
module.removetool = function(player, toolName)
    local tool = player.Backpack:FindFirstChild(toolName)
    if tool then
        tool:Destroy()
        SendMessage(player, "A ferramenta " .. toolName .. " foi removida.")
    end
end

-- Comando /givetool (dar uma ferramenta ao jogador)
module.givetool = function(player, toolName)
    local tool = ReplicatedStorage:FindFirstChild(toolName)
    if tool then
        local newTool = tool:Clone()
        newTool.Parent = player.Backpack
        SendMessage(player, "Você recebeu a ferramenta: " .. toolName)
    end
end

-- Comando /removetool (remover uma ferramenta do jogador)
module.removetool = function(player, toolName)
    local tool = player.Backpack:FindFirstChild(toolName)
    if tool then
        tool:Destroy()
        SendMessage(player, "A ferramenta " .. toolName .. " foi removida.")
    end
end

-- Comando /clearinventory (limpar o inventário do jogador)
module.clearinventory = function(player)
    for _, item in pairs(player.Backpack:GetChildren()) do
        if item:IsA("Tool") then
            item:Destroy()
        end
    end
    SendMessage(player, "Seu inventário foi limpo.")
end

-- Comando /droptool (dropar uma ferramenta do inventário do jogador)
module.droptool = function(player, toolName)
    local tool = player.Backpack:FindFirstChild(toolName)
    if tool then
        tool.Parent = Workspace
        tool.CFrame = player.Character.HumanoidRootPart.CFrame * CFrame.new(0, 5, 0)
        SendMessage(player, "Você droppou a ferramenta: " .. toolName)
    end
end

-- Comando /clonetool (clonar uma ferramenta do inventário do jogador)
module.clonetool = function(player, toolName)
    local tool = player.Backpack:FindFirstChild(toolName)
    if tool then
        local clonedTool = tool:Clone()
        clonedTool.Parent = player.Backpack
        SendMessage(player, "Você clonou a ferramenta: " .. toolName)
    end
end

-- Comando /disabletools (desabilitar ferramentas no mapa)
module.disabletools = function(player)
    for _, item in pairs(Workspace:GetChildren()) do
        if item:IsA("Tool") then
            item:Destroy()
        end
    end
    SendMessage(player, "Todas as ferramentas no mapa foram desabilitadas.")
end

-- Comando /enabletools (habilitar ferramentas no mapa)
module.enabletools = function(player)
    -- Supondo que as ferramentas estão armazenadas em ReplicatedStorage
    for _, item in pairs(ReplicatedStorage:GetChildren()) do
        if item:IsA("Tool") then
            local newTool = item:Clone()
            newTool.Parent = Workspace
        end
    end
    SendMessage(player, "Todas as ferramentas foram habilitadas no mapa.")
end

-- Comando /randomtool (dar uma ferramenta aleatória ao jogador)
module.randomtool = function(player)
    local tool = ReplicatedStorage:GetChildren()[math.random(1, #ReplicatedStorage:GetChildren())]
    if tool:IsA("Tool") then
        local newTool = tool:Clone()
        newTool.Parent = player.Backpack
        SendMessage(player, "Você recebeu uma ferramenta aleatória: " .. tool.Name)
    end
end

-- Comando /stealtool (roubar ferramenta de outro jogador)
module.stealtool = function(player, targetName)
    local target = Players:FindFirstChild(targetName)
    if target then
        for _, item in pairs(target.Backpack:GetChildren()) do
            if item:IsA("Tool") then
                item:Clone().Parent = player.Backpack
                SendMessage(player, "Você roubou a ferramenta " .. item.Name .. " de " .. target.Name)
            end
        end
    end
end

-- Comando /recolhetools (pegar todas as ferramentas do mapa e adicionar ao inventário)
module.recolhetools = function(player)
    for _, item in pairs(Workspace:GetChildren()) do
        if item:IsA("Tool") then
            item.Parent = player.Backpack
            item.CFrame = player.Character.HumanoidRootPart.CFrame
        end
    end
    SendMessage(player, "Você recolheu todas as ferramentas no mapa.")
end

-- Comando /equiptools (equipar todas as ferramentas do inventário)
module.equiptools = function(player)
    for _, item in pairs(player.Backpack:GetChildren()) do
        if item:IsA("Tool") then
            item.Parent = player.Character
        end
    end
    SendMessage(player, "Você equipou todas as ferramentas do seu inventário.")
end

-- Comando /admin (dar permissões de admin)
module.admin = function(player)
    player:SetAttribute("IsAdmin", true)
    SendMessage(player, "Você agora é um administrador.")
end

-- Comando /unadmin (remover permissões de admin)
module.unadmin = function(player)
    player:SetAttribute("IsAdmin", false)
    SendMessage(player, "Você não é mais um administrador.")
end

-- Comando /resetallmap (resetar o mapa)
module.resetallmap = function(player)
    -- Apagar todas as partes e ferramentas no mapa
    for _, obj in pairs(Workspace:GetChildren()) do
        if obj:IsA("BasePart") or obj:IsA("Tool") then
            obj:Destroy()
        end
    end
    SendMessage(player, "O mapa foi resetado para o padrão.")
end

-- Função de mensagem para o chat
function SendMessage(player, message)
    local msg = Instance.new("Message")
    msg.Text = message
    msg.Parent = game.Workspace
    wait(2)
    msg:Destroy()
end
