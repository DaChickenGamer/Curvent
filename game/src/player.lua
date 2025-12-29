Player = Object.extend(Object)

function Player:new()
    self.x = 100
    self.y = 100
    self.width = 200
    self.height = 150
    self.speed = 100
    self.currentHealth = 100
    self.maxHealth = 100
end

function Player:draw()
    love.graphics.rectangle("line", self.x, self.y, self.width, self.height)
end

function Player:move(x, y)
    self.x = self.x + x
    self.y = self.y - y
end

function Player:ChangeHealth(amount)
    self.currentHealth = Clamp(amount, 0, self.maxHealth)
end