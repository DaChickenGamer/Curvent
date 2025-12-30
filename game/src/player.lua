Player = Object:extend()

function Player:new(x, y, w, h)
	Player.super.new(self)

    if type(x) == "table" then
        local args = x
        x = args.x
        y = args.y
		w = args.w
		h = args.h
    end

    self.position = Vector.new(x or 0, y or 0)
    self.size = Vector.new(w or 100, h or 100)
	self.facing = Vector.new(1, 0)
    self.speed = 1
    self.maxHealth = 100
	self.currentHealth = self.maxHealth

	self.attackCooldown = 0
	self.attackDelay = .3

	table.insert(self.tags, "player")
end

function Player:update(dt)
	if self.attackCooldown > 0 then
		self.attackCooldown = self.attackCooldown - dt
	end
end

function Player:draw()
	if self.attackCooldown > 0 then
		love.graphics.setColor(0, .5, 0)
	else
		love.graphics.setColor(.5, 1, .5)
	end

    love.graphics.rectangle("line", self.position.x, self.position.y, self.size.x, self.size.y)
end

function Player:move(x, y)
    local moveVec = Vector.new(x, -y)

    if moveVec.x ~= 0 or moveVec.y ~= 0 then
        self.facing = moveVec:normalize()
    end

    self.position = self.position + moveVec * self.speed
end

function Player:attack()
	if self.attackCooldown > 0 then return end

    local attackRange = 5
    local attackSize = 20

    local hitX = self.position.x + self.facing.x * attackRange
    local hitY = self.position.y + self.facing.y * attackRange

    local hitbox = {
        x = hitX,
        y = hitY,
        w = attackSize,
        h = attackSize
    }

    self:checkAttackHitbox(hitbox)

	self.attackCooldown = self.attackDelay
end

function Player:onHit()
	self:ChangeHealth(-10)
end


function Player:ChangeHealth(amount)
    self.currentHealth = math.clamp(0, self.currentHealth + amount, self.maxHealth)

	if self.currentHealth == 0 then
		self.destroyed = true
	end
end

function Player:checkAttackHitbox(hitbox)
    for _, obj in ipairs(gameObjects) do
        if obj ~= self and obj.tags and table.find(obj.tags, "enemy") then
            if AABB_Box(hitbox, obj) then
                if obj.onHit then
                    obj:onHit(self)
                end
            end
        end
    end
end

return Player
