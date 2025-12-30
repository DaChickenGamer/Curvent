Projectile = Object:extend()

function Projectile:new(x, y)
	Projectile.super.new(self)

    if type(x) == "table" then
        local args = x
        x = args.x
        y = args.y
    end

    self.speed = 50
    self.size = Vector.new(10, 10)
    self.position = Vector.new(x or 0, y or 0)
    self.velocity = Vector.new(self.speed, 0)

	table.insert(self.tags, "projectile")
end

function Projectile:update(dt)
    self.position = self.position + self.velocity * dt
end

function Projectile:draw()
	love.graphics.setColor(1, 0, 0)
    love.graphics.circle("fill", self.position.x, self.position.y, self.size.x)
end

function Projectile:onCollision(other)
	if not other:compareTag("player") then return end

	other:onHit(-10)
	self.destroyed = true
end

return Projectile
