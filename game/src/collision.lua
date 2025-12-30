function AABB(a, b)
    return a.position.x < b.position.x + b.size.x and
           b.position.x < a.position.x + a.size.x and
           a.position.y < b.position.y + b.size.y and
           b.position.y < a.position.y + a.size.y
end

function AABB_Box(box, obj)
    return not (
        box.x + box.w < obj.position.x or
        box.x > obj.position.x + obj.size.x or
        box.y + box.h < obj.position.y or
        box.y > obj.position.y + obj.size.y
    )
end
