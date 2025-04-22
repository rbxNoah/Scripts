--[[
    Admin Script Avançado - Noah Edition
    Com mais de 100 comandos, incluindo ?help para listar todos.
    Apenas administradores podem usar os comandos.
]]

local Admins = {
    ["rbxV1P3R"] = true,
    ["mest_x"] = true,
}

local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")

function IsAdmin(player)
    return Admins[player.Name]
end

function SendMessage(player, msg)
    StarterGui:SetCore("ChatMakeSystemMessage", {
        Text = msg;
        Color = Color3.new(1, 1, 0);
    })
end

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
        ]]
        SendMessage(player, helpMessage)
    end

    -- Os outros comandos viriam aqui (muitos blocos if cmd == "/comando" then ...)
end

Players.PlayerAdded:Connect(function(player)
    player.Chatted:Connect(function(msg)
        OnChatted(player, msg)
    end)
end)
