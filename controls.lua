--=======================================================================================
-- control class
control = {
    pressed = false, -- if the button was pressed this frame
    clicked = false, -- if the button was clicked this frame
    press_time = 0, -- how long the mouse button was pressed for

    active = function() return false end,
    trigger = function() end,
    press = function() end,
    release = function() end
}
control.__index = control
--=======================================================================================
-- global table of all controls
controls = { active = false, names = {} }

-- how long to hold a button for it to be considered a press
__press_time = 0.3

--=======================================================================================
-- control functions
function control:set(name, conditional, functions)
    assert(type(name) == 'string', 'there needs to be a "name" string!')
    assert(type(conditional) == 'function', "conditional needs to be a function!")
    assert(type(conditional()) == 'boolean', "conditional must return a boolean value!")
    assert(type(functions) == 'table', "functions must be a table!")

    for k, v in pairs(functions) do
        assert(type(k) == 'string')

        if k == 'trigger' or k == 'press' or k == 'release' then
            assert(type(v) == 'function', name .. " was given an inapropriate " .. k .. " value. must be function!")
        else
            assert(false, name .. " was given an unwarented key")
        end
    end

    if controls[name] == nil then add(controls.names, name) end
    controls[name] = setmetatable(functions or {}, self)
    controls[name].active = conditional

    return name
end

function control:update(dt)
    if self:active() then
        -- when left mouse button is pressed
        if not self.pressed then
            self.clicked = true
            self.pressed = true

            -- do trigger button functions
            self:trigger()
        else
            self.press_time += dt

            -- do press button functions
            if self.press_time >= __press_time then
                self:press()
            end
        end
    elseif self.pressed then
        -- when left mouse button is released
        self.pressed = false
        self.press_time = 0

        -- do released button functions
        self:release()
    end
end
--=======================================================================================

--=======================================================================================
-- controls functions
function controls:set_active(active)
    assert(type(active) == 'boolean', "active must be a boolean")
    self.active = active
end

function controls:update(dt)
    if self.active then
        for i = 1, #self.names do
            self[self.names[i]]:update(dt)
        end
    end
end

function controls:reset()
    if self.active then
        for i = 1, #self.names do
            self[self.names[i]].clicked = false
        end
    end
end
--=======================================================================================