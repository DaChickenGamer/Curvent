Time_Dilation = .1

function love.load()
    Object = require "lib.classic"
	Vector = require "lib.Vector"

    Player = require "src.player"
    Projectile = require "src.projectile"

    player = Player()
    testProjectile = Projectile(500, 250)
end

function love.update(dt)
	  dt = dt * Time_Dilation
	
	  HandlePlayerMovement()
	  testProjectile:update(dt)
end

function love.draw()
	player:draw()
	testProjectile:draw()
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