Time_Dilation = .1

gameObjects = {}

function love.load()
    Object = require "lib.classic"
	Vector = require "lib.Vector"

    Player = require "src.player"
    Projectile = require "src.projectile"

    player = Player()
    testProjectile = Projectile(500, 250)

	table.insert(gameObjects, player)
	table.insert(gameObjects, testProjectile)
end

function love.update(dt)
	dt = dt * Time_Dilation
	
	HandlePlayerMovement()
	GameObjectUpdate(dt)
end

function love.draw()
	GameObjectDraw()
end

function GameObjectUpdate(dt)
	for i = 1, #gameObjects do
		local obj = gameObjects[i]

		if obj.update then
			obj:update(dt)
		end

		if obj.destroyed then
			table.remove(gameObjects, i)
		end
	end
end

function GameObjectDraw()
	for i = 1, #gameObjects do
		local obj = gameObjects[i]

		if obj.draw then
			obj:draw()
		end
	end
end

function HandlePlayerMovement()
    local isMoving = false

    if love.keyboard.isDown("w") then
        player:move(0, 1)
        isMoving = true
    end
    if love.keyboard.isDown("a") then
        player:move(-1, 0)
        isMoving = true
    end
    if love.keyboard.isDown("s") then
        player:move(0, -1)
        isMoving = true
    end
    if love.keyboard.isDown("d") then
        player:move(1, 0)
        isMoving = true
    end
    if isMoving then
        Time_Dilation = 1
    else
        Time_Dilation = 0.1
    end
end
