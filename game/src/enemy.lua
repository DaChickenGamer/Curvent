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
    self.size = Vector.new(w or 32, h or 32)
    self.speed = .1
    self.maxHealth = 100
	self.currentHealth = self.maxHealth

	self.path = nil
    self.pathIndex = 1
    self.repathTimer = 0

	table.insert(self.tags, "enemy")
end

function Enemy:update(dt)
    self.repathTimer = self.repathTimer - dt
    if self.repathTimer <= 0 then
        self:calculatePath()
        self.repathTimer = 0.5
    end

    self:followPath(dt)
end

function Enemy:calculatePath()
    local playerObj = nil

    for _, obj in ipairs(gameObjects) do
        if obj:compareTag("player") then
            playerObj = obj
            break
        end
    end

    if not playerObj then return end

    local sx, sy = WorldToTile(self.position.x, self.position.y)
    local tx, ty = WorldToTile(playerObj.position.x, playerObj.position.y)

    local path = pathfinder:getPath(sx, sy, tx, ty)
    if path then
        self.path = {}
        for node, _ in path:iter() do
            table.insert(self.path, node)
        end
		
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

function Enemy:followPath(dt)
    if not self.path then return end

    local node = self.path[self.pathIndex]
    if not node then return end

    local nx, ny = node:getPos()
    local wx, wy = TileToWorld(nx, ny)

    local dir = Vector.new(wx - self.position.x, wy - self.position.y)

    if dir:magnitude() < 2 then
        self.pathIndex = self.pathIndex + 1
        return
    end

    dir:normalize()
    self.position = self.position + dir * self.speed * 60 * dt
end


function Enemy:draw()
	love.graphics.setColor(1, 0, 0)
    love.graphics.rectangle("line", self.position.x, self.position.y, self.size.x, self.size.y)
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
