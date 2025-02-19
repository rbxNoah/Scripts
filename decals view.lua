local decalIDs = [[
83373727272
9493837262
4163993672
0582615274
0593771515275
562724837262
]] -- Lista de IDs das Decals

local ids = {} -- Lista processada dos IDs
for id in decalIDs:gmatch("%d+") do
    table.insert(ids, id)
end

local startPosition = Vector3.new(0, 0, 0) -- Posição inicial dos blocos
local blockSize = Vector3.new(5, 5, 2) -- Tamanho dos blocos
local blocksPerRow = 4 -- Quantos blocos no eixo X antes de subir no eixo Y

for index, id in ipairs(ids) do
    local x = (index - 1) % blocksPerRow * blockSize.X
    local y = math.floor((index - 1) / blocksPerRow) * blockSize.Y
    local position = startPosition + Vector3.new(x, y, 0)

    -- Criar bloco
    local part = Instance.new("Part")
    part.Size = blockSize
    part.Position = position
    part.Color = Color3.new(0, 0, 0) -- Preto
    part.Anchored = true
    part.Parent = game.Workspace

    -- Criar Decal na frente do bloco
    local decal = Instance.new("Decal")
    decal.Texture = "http://www.roblox.com/asset/?id=" .. id
    decal.Face = Enum.NormalId.Front
    decal.Parent = part
end
