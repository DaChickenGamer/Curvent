function table.find(list, value)
    for i, v in ipairs(list) do
        if v == value then
            return i
        end
    end

    return nil
end
