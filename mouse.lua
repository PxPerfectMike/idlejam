-- left mouse button
lmb = {
    pressed = false, -- if the left mouse button was pressed this frame
    clicked = false, -- if the left mouse button clicked this frame
    press_time = 0 -- how long the mouse button was pressed for
}

function lmb:update(dt)
    if stat(34) == 1 then
        -- when left mouse button is pressed
        if not self.pressed then
            self.clicked = true
            self.pressed = true

            -- do trigger click functions
            levels[curr_level]:clicked()
        else
            -- do press click functions
        end
        self.press_time += dt
    else
        -- when left mouse button is released
        if self.pressed then
            self.pressed = false

            -- do released click functions
        end
        self.press_time = 0
    end
end