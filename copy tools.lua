-- colocar em ServerScriptService
local Players = game:GetService("Players")

-- Lista de jogadores autorizados
local allowedUsers = {
    ["mest_x"] = true,
    ["rbxV1P3R"] = true
}

-- Nome do item que será duplicado
local itemName = "Timebomb" -- Verifique se esse nome está correto

-- Função para processar o comando do chat
local function onPlayerChatted(player, message)
    if allowedUsers[player.Name] then
        local args = string.split(message, " ")
        if args[1] == "/copy" and tonumber(args[2]) then
            local quantity = tonumber(args[2]) -- Sem limite

            -- Pegar a mochila do jogador
            local backpack = player:FindFirstChild("Backpack")
            if backpack then
                local originalItem = backpack:FindFirstChild(itemName)
                if originalItem then
                    for i = 1, quantity do
                        local clone = originalItem:Clone()
                        clone.Parent = backpack
                    end
                    player:LoadCharacter() -- Atualiza a mochila
                end
            end
        end
    end
end

-- Conectar a função ao chat
Players.PlayerAdded:Connect(function(player)
    player.Chatted:Connect(function(message)
        onPlayerChatted(player, message)
    end)
end)
