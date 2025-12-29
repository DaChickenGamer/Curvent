function love.load()
	Object = require "lib.classic"
	require "src.player"

	Player = Player()
end

function love.update(dt)
end

function love.draw()
	Player:draw()
end

function love.keypressed(key)
	if key == "w" then
		Player:move(0, 10)
	end

	if key == "a" then
		Player:move(-10, 0)
	end

	if key == "s" then
		Player:move(0, -10)
	end

	if key == "d" then
		Player:move(10, 0)
	end
end