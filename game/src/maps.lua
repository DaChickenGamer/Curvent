local TILE = {
    ["#"] = "tile",
    ["."] = "empty",
    ["P"] = "player",
    ["E"] = "enemy"
}

TILE_SIZE = 32

local mapOrder = { "level1", "level2", "level3", "level4", "level5" }
local enemyTypePerLevel = { "wave", "arc", "spiral", "homing", "richochet" }
local currentMapIndex = 0

TotalEnemies = 0
EnemiesAlive = 0
LoadingMap = false

function NextMap()
    currentMapIndex = currentMapIndex % #mapOrder + 1
    LoadMapFile(mapOrder[currentMapIndex])
end

function LoadMap(map)
	LoadingMap = true
	GameObjects = {}
	TotalEnemies = 0

	jumperGrid = Grid(BuildJumperGrid(map))
    pathfinder = Pathfinder(jumperGrid, "ASTAR", 0)
    pathfinder:setMode("ORTHOGONAL")

    for y, row in ipairs(map) do
        for x = 1, #row do
            local char = row:sub(x, x)
            local worldX = (x - 1) * TILE_SIZE
            local worldY = (y - 1) * TILE_SIZE

            if char == "#" then
                table.insert(GameObjects, Tile(worldX, worldY, TILE_SIZE, TILE_SIZE))
            elseif char == "P" then
                table.insert(GameObjects, Player(worldX, worldY, TILE_SIZE, TILE_SIZE))
            elseif char == "E" then
				local enemyType = enemyTypePerLevel[currentMapIndex] or "wave"
                table.insert(GameObjects, Enemy(worldX, worldY, TILE_SIZE, TILE_SIZE, enemyType))
				TotalEnemies = TotalEnemies + 1
            end
        end
    end

	EnemiesAlive = TotalEnemies
	LoadingMap = false
end

function BuildJumperGrid(map)
    local grid = {}

    for y, row in ipairs(map) do
        grid[y] = {}
        for x = 1, #row do
            local char = row:sub(x, x)
            -- 1 = blocked, 0 = walkable
            grid[y][x] = (char == "#") and 1 or 0
        end
    end

    return grid
end

function LoadMapFile(name)
    local map = require("src.maps." .. name)
    LoadMap(map)
end


function WorldToTile(x, y)
    return math.floor(x / TILE_SIZE) + 1, math.floor(y / TILE_SIZE) + 1
end

function TileToWorld(x, y)
    return (x - 1) * TILE_SIZE, (y - 1) * TILE_SIZE
end
