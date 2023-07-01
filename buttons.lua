-- these are meant for visuals only this button class does not take care of sensing if it is clicked or not
--=======================================================================================
-- button class
-- dx and dy are delta x and delta y, basically how much you want to move the main sensing part of the button over by
button = {
    coords = { x = 0, y = 0, w = 1, h = 1, dx = 0, dy = 0 },
    state = 1,
    visable = true,
    sprites = { { x = 0, y = 0, w = 1, h = 1 } }
}
button.__index = button
--=======================================================================================
-- global table of all buttons
buttons = { names = {} }

-- control functions
function button:new(name, coords, sprites)
    assert(type(name) == 'string', 'there needs to be a "name" string!')

    assert(type(coords) == 'table', "coordinates must be given as a table!")

    assert(type(sprites) == 'table', "sprites must be given as a table!")

    local required_variables = 0
    local comp_type = 'number'

    for k, v in pairs(coords) do
        assert(type(k) == 'string')

        if k == 'x' or k == 'y' or k == 'w' or k == 'h' or k == 'dx' or k == 'dy' then
            if k == 'x' or k == 'y' then required_variables += 1 end

            assert(type(v) == comp_type, name .. " was given an inapropriate " .. k .. " value. must be " .. comp_type .. "!")
        else
            assert(false, name .. " was given an unwarented key")
        end
    end

    assert(required_variables == 2, name .. "'s inputed coords is missing an x and/or y!")

    for k, v in pairs(sprites) do
        assert(type(k) == 'number')
        assert(type(v) == 'table')

        required_variables = 0

        for _k, _v in pairs(v) do
            assert(type(_k) == 'string')

            if _k == 'x' or _k == 'y' or _k == 'w' or _k == 'h' then
                required_variables += 1
                assert(type(_v) == comp_type, "one of " .. name .. "'s inputed sprites was given an inapropriate " .. _k .. " value. must be " .. comp_type .. "!")
            else
                assert(false, "one of " .. name .. "'s inputed sprites was given an unwarented key")
            end
        end

        assert(required_variables == 4, "one of " .. name .. "'s inputed sprites is missing an x, y, w, and/or h!")
    end

    if buttons[name] == nil then add(buttons.names, name) end

    buttons[name] = setmetatable({}, self)
    buttons[name].coords = coords
    buttons[name].sprites = sprites

    return name
end

function button:draw()
    local sprite = self.sprites[self.state]
    local pos = self.coords
    sspr(sprite.x, sprite.y, sprite.w, sprite.h, pos.x, pos.y)
end

function buttons:set_state(name, state)
    local button_data = self[name]
    assert(button_data)
    assert(type(state) == 'number')
    local int = state % #button_data.sprites
    if int == 0 then int = #button_data.sprites end

    self[name].state = state
end

function button:is_in(x, y)
    local pos = self.coords
    pos.x += pos.dx or 0
    pos.y += pos.dy or 0
    return x >= pos.x
            and x <= pos.x + pos.w
            and y >= pos.y
            and y <= pos.y + pos.h
end

function button:move(x, y)
    assert(type(x) == 'number')
    assert(type(y) == 'number')

    self.coords.x = x
    self.coords.y = y
end

function buttons:move(name, x, y)
    assert(type(name) == 'string')
    assert(buttons[name])

    buttons[name]:move(x, y)
end

function buttons:get_coordinates(name)
    assert(type(name) == 'string')
    assert(buttons[name])

    return buttons[name]:get_coordinates()
end

function buttons:draw(name)
    if name then
        assert(type(name) == 'string')
        assert(buttons[name])

        buttons[name]:draw()
    else
    end
end

function buttons:is_in(name, x, y)
    assert(type(name) == 'string')
    assert(buttons[name])

    return buttons[name]:is_in(x, y)
end