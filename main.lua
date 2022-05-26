
getgenv().Cache = Cache or {}

function ttostring(table, indent)
    local result = "{"
    local indent = indent or 1

    for k, v in pairs(table) do
        result = result .. "\n" .. string.rep("  ", indent)

        if type(k) == "string" then
            result = result .. string.format("[\"%s\"] = ", k)
        elseif type(k) == "number" then
            result = result .. string.format('[%d] = ', k)
        end

        if type(v) == "table" then
            result = result .. (#v == 0 and "{}" or ttostring(v, indent + 1))
        elseif type(v) == "boolean" then
            result = result .. tostring(v)
        elseif type(v) == "number" then
            result = result .. v
        else
            result = result .. string.format('"%s"', tostring(v))
        end

        result = result .. ","
    end

    if result ~= "{" then
        result = result:sub(1, -2)
    end

    return result .. string.format("\n%s}", string.rep("  ", indent - 1))
end

local Garbage = {}

Garbage.find = function(Query)
    local Result = {}

    for _, Function in next, getgc() do
        if type(Function) == "function" and islclosure(Function) and not is_synapse_function(Function) and not (getfenv(Function).script and (getfenv(Function).script.RobloxLocked or getfenv(Function).script:IsDescendantOf(game.Chat) or getfenv(Function).script.Name == "FreecamScript")) then
            for _, f in next, {"getconstants", "getupvalues"} do
                for i, v in next, getgenv()[f](Function) do
                    if type(v) == "string" then
                        if string.match(string.lower(v), string.lower(Query)) then
                            if not table.find(Result, Function) then
                                table.insert(Result, Function)
                            end
                        end
                    end
                end
            end
        end
    end

    return Result
end

Garbage.dump = function(Query)
    local Result = {}

    for _, Function in next, find(Query) do
        for i, v in next, getupvalues(Function) do
            table.insert(Result, v)

            if type(v) == "table" then
                warn(string.format("%s = %s", tostring(v), ttostring(v)))
            end
        end
    end

    return Result
end

Garbage.setupvalue = function(Query, Index, Value, Changed)
    local Functions = Cache[Query] or find(Query)

    for _, Function in next, Functions do
        for _, upvalue in next, getupvalues(Function) do
            if type(upvalue) == "table" and rawget(upvalue, Index) then
                if Changed then
                    upvalue[index] = nil

                    setmetatable(upvalue, {
                        __newindex = function(self, i, v)
                            if not i == index then
                                rawset(self, i, v)
                            end
                        end,
                        __index = function(self, v)
                            if v == index then
                                return Value
                            else
                                return rawget(self, v)
                            end
                        end
                    })
                end

                upvalue[Index] = Value
            end
        end
    end

    Cache[Query] = Functions
end

return Garbage
