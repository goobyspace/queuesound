local _, core = ...;
core.utils = {};

core.utils.dump = function(o)
    if type(o) == 'table' then
        local s = '{ '
        for k, v in pairs(o) do
            if type(k) ~= 'number' then k = '"' .. k .. '"' end
            s = s .. '[' .. k .. '] = ' .. core.utils.dump(v) .. ','
        end
        return s .. '} '
    else
        return tostring(o)
    end
end
