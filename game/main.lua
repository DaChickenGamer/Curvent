Time_Dilation = .1

gameObjects = {}

function love.load()
    Object = require "lib.classic"
	Vector = require "lib.Vector"

	require "src.collision"
	require "lib.generalmath"

    Player = require "src.player"
	Enemy = require "src.enemy"
    Projectile = require "src.projectile"

	table.insert(gameObjects, Player({x=250, y=100}))

	table.insert(gameObjects, Projectile(0, 100))
	table.insert(gameObjects, Projectile(0, 200))
	table.insert(gameObjects, Projectile(0, 300))

	table.insert(gameObjects, Enemy({x = 500}))
end

function love.update(dt)
	dt = dt * Time_Dilation
	
	HandlePlayerMovement()
	GameObjectUpdate(dt)
	CollisionCheck()
end

function love.draw()
	GameObjectDraw()
end

function GameObjectUpdate(dt)
	for i = #gameObjects, 1, -1 do
		local obj = gameObjects[i]

		if obj.update then
			obj:update(dt)
		end

		if obj.destroyed then
			table.remove(gameObjects, i)
		end
	end
end

function CollisionCheck()
	for i = 1, #gameObjects do
		local a = gameObjects[i]

		for j = i + 1, #gameObjects do
			local b = gameObjects[j]

			if AABB(a, b) then
				if a.onCollision then a:onCollision(b) end
				if b.onCollision then b:onCollision(a) end
			end
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
    local playerObj = nil

    for _, obj in ipairs(gameObjects) do
        if obj:compareTag("player") then
            playerObj = obj
            break
        end
    end

    if not playerObj then
        return
    end

    local isMoving = false

    if love.keyboard.isDown("w") then
        playerObj:move(0, 1)
        isMoving = true
    end
    if love.keyboard.isDown("a") then
        playerObj:move(-1, 0)
        isMoving = true
    end
    if love.keyboard.isDown("s") then
        playerObj:move(0, -1)
        isMoving = true
    end
    if love.keyboard.isDown("d") then
        playerObj:move(1, 0)
        isMoving = true
    end

    Time_Dilation = isMoving and 1 or 0.1
end
