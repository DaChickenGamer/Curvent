Tile = Object:extend()

function Tile:new(x, y, w, h)
	Tile.super.new(self)

    if type(x) == "table" then
        local args = x
        x = args.x
        y = args.y
		w = args.w
		h = args.h
    end

    self.position = Vector.new(x or 0, y or 0)
    self.size = Vector.new(w or 100, h or 100)

	table.insert(self.tags, "tile")
end

function Tile:draw()
	love.graphics.setColor(.3, .3, 0)
    love.graphics.rectangle("line", self.position.x, self.position.y, self.size.x, self.size.y)
end

return Tile
