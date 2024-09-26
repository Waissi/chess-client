table.delete = function(tab, element)
    for key, value in pairs(tab) do
        if value == element then
            table.remove(tab, key)
            return
        end
    end
end

table.combine = function(tab1, tab2)
    local tab = {}
    for index, value in pairs(tab1) do
        if type(index) == "number" then
            tab[#tab + 1] = value
        else
            tab[index] = value
        end
    end
    for index, value in pairs(tab2) do
        if type(index) == "number" then
            tab[#tab + 1] = value
        else
            tab[index] = value
        end
    end
    return tab
end
