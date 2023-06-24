mathtest = false

-- chat variables
chat_spawn_timer = 0
chat_spawn_interval = 1 -- in seconds
chat_spawn_chance = 0.9 -- percentage chance to spawn a chat
max_chat_count = 14
function move_chat_down()
    for i, c in pairs(chat) do
        c.y += 8 -- adjust this value to control how much sprites move down
    end
end

-- pico state hooks
State = {
    _state = {},
    set_state_self_inner = function(self, name, value)
        self._state[name] = value
    end
}

function set_state(name, value)
    State:set_state_self_inner(name, value)
end

function get_state(name)
    return State._state[name]
end

function _init()
    if not mathtest then
        cls()
        sky_speed = 0.3 -- initial sky speed
        palt(14, true) -- pink color as transparency is true
        palt(0, false) -- black color as transparency is false

        -- initialize ground with enough sprites to fill the screen
        for i = 0, 15 do
            ------------>changed both ground_table indexes from 1 to level
            add(ground, { x = i * 8, frame = ground_table[level].frames[flr(rnd(#ground_table[level].frames)) + 1] })
        end

        -- initialize sky with enough sprites to fill the screen
        for i = 0, 15 do
            for j = 1, 12 do
                -- for each sprite, select a random frame from the corresponding row in the sky_table
                add(sky, { x = i * 8, y = sky_arr[j], frame = sky_table[j].frames[flr(rnd(#sky_table[j].frames)) + 1], row = j })
            end
        end
    else
        --------> separate for animation/math testing
        run_tests()
    end
end

function _update()
    if not mathtest then
        character_switch()
        speed_switch()
        animation(character_table[level].frames, speed)
    end

    -- Increase timer by frame duration
    chat_spawn_timer += 1 / 30
    -- assuming 30 frames per second

    -- Check if it's time to possibly spawn a new chat sprite
    if chat_spawn_timer >= chat_spawn_interval then
        -- Reset timer
        chat_spawn_timer = 0
        
        -- Remove chat sprite at the bottom
        if #chat == 14 then
            del(chat, chat[1])
        end
        -- Chance to spawn a new chat sprite
        if rnd() < chat_spawn_chance and #chat < max_chat_count then
            -- Move existing chat sprites down
            move_chat_down()
            -- Spawn new chat sprite at the top
            add(chat, { x = 97, y = 26, frame = chat_table.frames[flr(rnd(#chat_table.frames)) + 1] })
        end
    end
end

function _draw()
    if not mathtest then
        cls()

        -- draw sky sprites
        for i, s in pairs(sky) do
            spr(s.frame, s.x, s.y, 1, 1)
            s.x -= sky_speed -- use sky_speed here instead of speed
            -- if a sprite goes off screen on the left, move it to the right side and change its frame
            if s.x < -8 then
                s.x = s.x + 128
                -- select a new sprite from the correct row
                s.frame = sky_table[s.row].frames[flr(rnd(#sky_table[s.row].frames)) + 1]
            end
        end

        -- draw ground sprites
        for i, g in pairs(ground) do
            spr(g.frame, g.x, 120, 1, 1)
            g.x -= speed / ground_speed_control + 0.2
            -- if a sprite goes off screen on the left, move it to the right side and change its frame
            if g.x < -8 then
                g.x = g.x + 128
                g.frame = ground_table[level].frames[flr(rnd(#ground_table[level].frames)) + 1]
            end
        end

        rectfill(96, 25, 128, 128, 6) -- right bar
        -- -- draw chat sprites
        for i, c in pairs(chat) do
            spr(c.frame, c.x, c.y, 1, 1)
        end

        rectfill(0, 0, 128, 25, 13) -- top bar
        -- rectfill(0, 17, 96, 119, 12) -- sky area
        line(0, 25, 128, 25, 7) -- top separator
        line(96, 25, 96, 128, 7) -- right separator

        spr(current_frame, 42, 104, 2, 2)
        print("streamer name", 2, 2, 8)
        print("level: " .. level, 2, 10, 7)
        print("character speed: " .. speed, 2, 18, 7)
    end
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

function exp(x)
    --2.718281828459
    return pow(2.71828, x)
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

-- raises x to the power of n
function pow(x, n)
    local x_n = 1
    for i = 1, n do
        x_n *= x
    end
    return x_n
end