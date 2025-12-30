Enemy = Object:extend()

function Enemy:new(x, y, w, h)
	Enemy.super.new(self)

    if type(x) == "table" then
        local args = x
        x = args.x
        y = args.y
		w = args.w
		h = args.h
    end

    self.position = Vector.new(x or 0, y or 0)
    self.size = Vector.new(w or 100, h or 100)
    self.speed = 1
    self.maxHealth = 100
	self.currentHealth = self.maxHealth

	table.insert(self.tags, "enemy")
end

function Enemy:draw()
	love.graphics.setColor(1, 0, 0)
    love.graphics.rectangle("line", self.position.x, self.position.y, self.size.x, self.size.y)
end

function Enemy:move(x, y)
    self.position = Vector.__add(self.position, Vector.new(x * self.speed, -y * self.speed))
end

function Enemy:onHit()
	self:ChangeHealth(-10)
end

function Enemy:ChangeHealth(amount)
    self.currentHealth = math.clamp(0, self.currentHealth + amount, self.maxHealth)

	if self.currentHealth == 0 then
		EnemiesAlive = EnemiesAlive - 1
		self.destroyed = true
	end
end

return Enemy
