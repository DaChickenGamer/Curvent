Player = Object:extend()

function Player:new()
	Player.super.new(self)

    self.position = Vector.new(100, 100)
    self.size = Vector.new(200, 150)
    self.speed = 1
    self.maxHealth = 100
	self.currentHealth = self.maxHealth

	table.insert(self.tags, "player")
end

function Player:draw()
    love.graphics.rectangle("line", self.position.x, self.position.y, self.size.x, self.size.y)
end

function Player:move(x, y)
    self.position = Vector.__add(self.position, Vector.new(x * self.speed, -y * self.speed))
end

function Player:ChangeHealth(amount)
    self.currentHealth = math.clamp(0, self.currentHealth + amount, self.maxHealth)

	if self.currentHealth == 0 then
		self.destroyed = true
	end
end

return Player
