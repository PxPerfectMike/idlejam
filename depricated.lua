-- left mouse button
lmb = {
    pressed = false, -- if the left mouse button was pressed this frame
    clicked = false, -- if the left mouse button clicked this frame
    press_time = 0 -- how long the mouse button was pressed for
    --[[
    functions = {
        trigger = { names = {} },
        press = { names = {} },
        release = { names = {} }
    }
    ]]
}

function lmb:update(dt)
    if stat(34) == 1 then
        -- when left mouse button is pressed
        if not self.pressed then
            self.clicked = true
            self.pressed = true

            -- do trigger click functions

            --[[
            local functions = self.functions.trigger

            for i = 1, #functions.names do
                local name = functions.names[i]
                functions[name]()
            end
            ]]
        else
            -- do press click functions
            --[[
            local functions = self.functions.press

            for i = 1, #functions.names do
                local name = functions.names[i]
                functions[name]()
            end
            ]]
        end
        self.press_time += dt
    else
        -- when left mouse button is released
        if self.pressed then
            self.pressed = false

            -- do released click functions
            --[[
            local functions = self.functions.release

            for i = 1, #functions.names do
                local name = functions.names[i]
                functions[name]()
            end
            ]]
        end
        self.press_time = 0
    end
end

--[[
function lmb:set_trigger_function(name, func)
    assert(type(name) == 'string')
    assert(type(func) == 'function')

    if self.functions.trigger[name] == nil then
        add(self.functions.trigger.names, name)
    end

    self.functions.trigger[name] = func
end

function lmb:set_press_function(name, func)
    assert(type(name) == 'string')
    assert(type(func) == 'function')

    if self.functions.press[name] == nil then
        add(self.functions.press.names, name)
    end

    self.functions.press[name] = func
end

function lmb:set_release_function(name, func)
    assert(type(name) == 'string')
    assert(type(func) == 'function')

    if self.functions.release[name] == nil then
        add(self.functions.release.names, name)
    end

    self.functions.release[name] = func
end
]]

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