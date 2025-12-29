Projectile = Object.extend(Object)

function Projectile:new(x, y)
    self.speed = 50
    self.size = 10
    self.position = Vector.new(x or 0, y or 0)
    self.velocity = Vector.new(self.speed, 0)
end

function Projectile:update(dt)
    self.position = self.position + self.velocity * dt
end

function Projectile:draw()
    love.graphics.circle("fill", self.position.x, self.position.y, self.size)
end

return Projectile