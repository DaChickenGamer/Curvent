local TILE = {
    ["#"] = "tile",
    ["."] = "empty",
    ["P"] = "player",
    ["E"] = "enemy"
}

TILE_SIZE = 32

local mapOrder = { "level1", "level2", "level3", "level4", "level5" }
local currentMapIndex = 0

TotalEnemies = 0
EnemiesAlive = 0
LoadingMap = false

function NextMap()
	gameObjects = {}
    currentMapIndex = currentMapIndex % #mapOrder + 1
    LoadMapFile(mapOrder[currentMapIndex])
end

function LoadMap(map)
	LoadingMap = true

    for y, row in ipairs(map) do
        for x = 1, #row do
            local char = row:sub(x, x)
            local worldX = (x - 1) * TILE_SIZE
            local worldY = (y - 1) * TILE_SIZE

            if char == "#" then
                table.insert(gameObjects, Tile(worldX, worldY, TILE_SIZE, TILE_SIZE))
            elseif char == "P" then
                table.insert(gameObjects, Player(worldX, worldY, TILE_SIZE, TILE_SIZE))
            elseif char == "E" then
                table.insert(gameObjects, Enemy(worldX, worldY, TILE_SIZE, TILE_SIZE))
				TotalEnemies = TotalEnemies + 1
            end
        end
    end

	EnemiesAlive = TotalEnemies
	LoadingMap = false
end

function LoadMapFile(name)
    local map = require("src.maps." .. name)
    LoadMap(map)
end
