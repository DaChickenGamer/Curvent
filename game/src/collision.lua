function AABB(a, b)
    return a.position.x < b.position.x + b.size.x and
           b.position.x < a.position.x + a.size.x and
           a.position.y < b.position.y + b.size.y and
           b.position.y < a.position.y + a.size.y
end
