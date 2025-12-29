Player = Object.extend(Object)

function Player:new()
    self.position = Vector.new(0, 0)
    self.size = Vector.new(200, 150)
    self.speed = 1
    self.currentHealth = 100
    self.maxHealth = 100
end

function Player:draw()
    love.graphics.rectangle("line", self.position.x, self.position.y, self.size.x, self.size.y)
end

function Player:move(x, y)
    self.position = Vector.__add(self.position, Vector.new(x * self.speed, -y * self.speed))
end

function Player:ChangeHealth(amount)
    self.currentHealth = math.clamp(0, amount, self.maxHealth)
end

return Player