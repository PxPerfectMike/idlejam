--[[
function err_check(condition, string, err_type)
    local err_types = {
        'invalid input',
        'missing variable',
        'incorrect variable type'
    }
    local msg = 'check err.txt for full details'
    local divider = '===========================================================================\n'
    if err_type and err_type > 0 and err_type <= #err_types then
        -- the detailed plain text information
        string = divider
                .. err_types[err_type] .. ":\n" .. string .. '\n' .. divider
        -- the assert message
        msg = '[' .. err_types[err_type] .. "]\n" .. msg
    else
        string = '' .. divider .. string .. '\n' .. divider
    end

    printh(string, "err.txt", true)
    assert(condition, msg)
end

]]

--[[
-- at give value_place, round the number num up
function round_up_long_num(num, value_place)
    local index = num.decimal - value_place + 1
    if num.values[index] and num.values[index] >= 5 then
        local i = index - 1
        while i >= 1 and num.values[i] == 9 do
            num.values[i] = 0
            i = i - 1
        end
        if i < 1 then
            -- need to add an additional place
            add(num.values, 1)
            num.decimal = num.decimal + 1
        else
            num.values[i] = num.values[i] + 1
        end
    end
    -- remove all places below the rounding place
    for i = index, #num.values do

    end
    return num
end
]]

function exp(x)
    --2.718281828459
    --return pow(2.71828, x)
end

function newtonRaphsonLog(x)
    -- this determines the accuracy of the result
    local epsilon = 0.00001

    local guess = x

    while abs(exp(guess) - x) > epsilon do
        guess = guess - (exp(guess) - x) / exp(guess)
        print(guess, 0, 0, 7)
    end

    return guess
end

function ln(x)
    local n = 1000
    -- The larger this value, the more accurate the result.
    local a = (x - 1) / (x + 1)
    local sum = 0

    for i = 0, n do
        local term = 2 * a ^ (2 * i + 1) / (2 * i + 1)
        sum = sum + term
    end

    return sum
end