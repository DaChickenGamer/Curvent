Projectile = Object:extend()

function Projectile:new(x, y, projectileType)
	Projectile.super.new(self)

    if type(x) == "table" then
        local args = x
        x = args.x
        y = args.y
		projectileType = args.projectileType
    end

    self.speed = 50
    self.size = Vector.new(10, 10)
    self.position = Vector.new(x or 0, y or 0)

    -- pathfinding fields for homing projectiles that avoid obstacles
    self.path = nil
    self.pathIndex = 1
    self.repathTimer = 0
    self.repathInterval = 0.25 -- seconds between path recalculations

    self.bounces = 0
    self.maxBounces = 3
    self.restitution = 0.8

    self.velocity = Vector.new(self.speed, 0)

	self.projectileType = projectileType or "wave"
	table.insert(self.tags, "projectile")
end

function Projectile:update(dt)
	self:ProjectilePathway(dt)
	
	self.position = self.position + self.velocity * dt
end

function Projectile:ProjectilePathway(dt)
	if self.projectileType == "wave" then
		self.velocity.y = math.sin(love.timer.getTime() * 10) * 100
	end

	if self.projectileType == "arc" then
		self.velocity.y = self.velocity.y + 9.81 * 10 * dt
	end

	if self.projectileType == "spiral" then
		local angle = love.timer.getTime() * Time_Dilation * 10
		local amplitude = 300
		local frequency = 1

		local dirx = self.velocity.x >= 0 and 1 or -1
		self.velocity.x = dirx * self.speed

		self.velocity.y = math.sin(angle * frequency) * amplitude
	end

	if self.projectileType == "homing" then
		local playerObj = nil

		for _, obj in ipairs(GameObjects) do
			if obj:compareTag("player") then
				playerObj = obj
				break
			end
		end

		if playerObj then
			local direction = (playerObj.position - self.position):normalize()
			self.velocity = direction * self.speed
		end
	end

	if self.projectileType == "homing_astar" then
		self.repathTimer = self.repathTimer - dt
		if self.repathTimer <= 0 then
			self:calculateAstarPath()
			self.repathTimer = self.repathInterval or 0.25
		end

		if self.path and #self.path > 0 then
			local node = self.path[self.pathIndex]
			if node then
				local nx, ny = node:getPos()
				local wx, wy = TileToWorld(nx, ny)
				local dir = Vector.new(wx - self.position.x, wy - self.position.y)
				if dir:magnitude() < 4 then
					self.pathIndex = self.pathIndex + 1
				else
					dir:normalize()
					self.velocity = dir * self.speed / 5
				end
			end
		end
	end
end

function Projectile:calculateAstarPath()
	local playerObj = nil
	for _, obj in ipairs(GameObjects) do
		if obj:compareTag("player") then
			playerObj = obj
			break
		end
	end
	if not playerObj then return end

	local sx, sy = WorldToTile(self.position.x, self.position.y)
	local tx, ty = WorldToTile(playerObj.position.x, playerObj.position.y)

	local newPath = pathfinder:getPath(sx, sy, tx, ty)
	if newPath then
		self.path = {}
		for node, _ in newPath:iter() do
			table.insert(self.path, node)
		end
		-- set the pathIndex to the closest node to current position
		local closestIdx = 1
		local minDistSq = math.huge
		for i, node in ipairs(self.path) do
			local nx, ny = node:getPos()
			local wx, wy = TileToWorld(nx, ny)
			local dx = wx - self.position.x
			local dy = wy - self.position.y
			local distSq = dx*dx + dy*dy
			if distSq < minDistSq then
				minDistSq = distSq
				closestIdx = i
			end
		end
		self.pathIndex = closestIdx
	end
end

function Projectile:draw()
	love.graphics.setColor(1, 0, 0)
    love.graphics.circle("fill", self.position.x, self.position.y, self.size.x)
end

function Projectile:onCollision(other)
	if other:compareTag("tile") then
		if self.projectileType == "richochet" then
			local px = self.position.x + self.size.x * 0.5
			local py = self.position.y + self.size.y * 0.5
			local tx = other.position.x + other.size.x * 0.5
			local ty = other.position.y + other.size.y * 0.5

			local dx = px - tx
			local dy = py - ty

			local hw = (self.size.x + other.size.x) * 0.5
			local hh = (self.size.y + other.size.y) * 0.5

			local overlapX = hw - math.abs(dx)
			local overlapY = hh - math.abs(dy)

			if overlapX < overlapY then
				local push = overlapX + 1
				if dx > 0 then
					self.position.x = self.position.x + push
				else
					self.position.x = self.position.x - push
				end
				self.velocity.x = -self.velocity.x * (self.restitution or 1)
			else
				local push = overlapY + 1
				if dy > 0 then
					self.position.y = self.position.y + push
				else
					self.position.y = self.position.y - push
				end
				self.velocity.y = -self.velocity.y * (self.restitution or 1)
			end

			self.bounces = (self.bounces or 0) + 1
			local speed = 0
			if self.velocity and self.velocity.magnitude then
				speed = self.velocity:magnitude()
			end
			if self.bounces >= (self.maxBounces or 3) or speed < 10 then
				self.destroyed = true
			end
		else
			self.destroyed = true
		end

		return
	end

	if not other:compareTag("player") then return end

	other:onHit(-10)
	self.destroyed = true
end

return Projectile
