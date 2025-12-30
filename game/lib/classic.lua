local Object = {}
Object.__index = Object


function Object:new()
	self.position = self.position or Vector.new(0, 0)
    self.size = self.size or Vector.new(16, 16)

	self.tags = {}
	self.destroyed = false
end


function Object:extend()
  local cls = {}
  for k, v in pairs(self) do
    if k:find("__") == 1 then
      cls[k] = v
    end
  end
  cls.__index = cls
  cls.super = self
  setmetatable(cls, self)
  return cls
end


function Object:implement(...)
  for _, cls in pairs({...}) do
    for k, v in pairs(cls) do
      if self[k] == nil and type(v) == "function" then
        self[k] = v
      end
    end
  end
end


function Object:is(T)
  local mt = getmetatable(self)
  while mt do
    if mt == T then
      return true
    end
    mt = getmetatable(mt)
  end
  return false
end


function Object:__tostring()
  return "Object"
end


function Object:__call(...)
  local obj = setmetatable({}, self)
  obj:new(...)
  return obj
end

function Object:onCollision(other)

end

function Object:compareTag(tag)
	for i = 1, #self.tags do
		if self.tags[i] == tag then
			return true
		end
	end

	return false
end

return Object
