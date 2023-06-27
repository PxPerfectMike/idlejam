mathtest = false

-- chat variables
chat_spawn_timer = 0
chat_spawn_interval = 1 -- in seconds
chat_spawn_chance = 0.2 -- percentage chance to spawn a chat
max_chat_count = 14

-- table to hold chat sprites
chat_entities = {}
function move_chat_down()
    for i, entity in pairs(chat_entities) do
        entity.chat.y += 8 -- adjust this value to control how much sprites move down
        entity.message.y += 8 -- adjust this value to control how much messages move down
    end
end

-- working chat stuff
chat_frames = { 80, 81, 82, 83, 84, 85, 86, 87 }
chat_messages = { 232, 235 }

-- make chat head table
chat_table = { frames = chat_frames }
chat_message_table = { frames = chat_messages }

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
    bg_transition_needed = true

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
        -- run_tests()
    end
end

function change_bg_color(old_color, new_color, startX, startY, endX, endY)
    for y = startY, endY do
        for x = startX, endX do
            local pixel_color = sget(x, y)
            if pixel_color == old_color then
                sset(x, y, new_color)
            end
        end
    end
end

function bg_transition()
    -- Return immediately if no transition is needed
    if not bg_transition_needed then
        return
    end

    -- Change the background color based on the level (current color, new color, start x, start y, end x, end y)
    if level == 2 then
        change_bg_color(12, 13, 0, 48, 63, 104)
        change_bg_color(6, 5, 0, 48, 63, 104)
        change_bg_color(1, 8, 0, 48, 63, 104)
    end

    if level == 3 then
        change_bg_color(13, 11, 0, 48, 63, 104)
        change_bg_color(5, 10, 0, 48, 63, 104)
        change_bg_color(1, 8, 0, 48, 63, 104)
        change_bg_color(2, 12, 0, 48, 63, 104)
    end
    if level == 4 then
        change_bg_color(11, 0, 0, 48, 63, 104)
        change_bg_color(10, 5, 0, 48, 63, 104)
        change_bg_color(8, 3, 0, 48, 63, 104)
    end
    if level == 5 then
        change_bg_color(5, 0, 0, 48, 63, 104)
        change_bg_color(8, 0, 0, 48, 63, 104)
        change_bg_color(12, 0, 0, 48, 63, 104)
        change_bg_color(3, 0, 0, 48, 63, 104)
    end

    -- Reset the flag
    bg_transition_needed = false
end

prev_level = 1 -- Initialize this with your initial level

function _update()
    if not mathtest then
        character_switch()
        speed_switch()
        animation(character_table[level].frames, speed)
    end

    if level ~= prev_level then
        -- Indicate that a background transition is needed
        bg_transition_needed = true
        prev_level = level
    end

    bg_transition()

    -- Increase timer by frame duration
    chat_spawn_timer += 1 / 30
    -- assuming 30 frames per second

    -- Check if it's time to possibly spawn a new chat sprite
    if chat_spawn_timer >= chat_spawn_interval then
        -- Reset timer
        chat_spawn_timer = 0

        -- Remove chat sprite at the bottom
        if #chat_entities == max_chat_count then
            del(chat_entities, chat_entities[1])
        end
        -- Chance to spawn a new chat sprite
        if rnd() < chat_spawn_chance and #chat_entities < max_chat_count then
            -- Move existing chat sprites down
            move_chat_down()
            -- Spawn new chat sprite and message at the top
            local chat_frame = chat_table.frames[flr(rnd(#chat_table.frames)) + 1]
            local message_frame = chat_message_table.frames[flr(rnd(#chat_message_table.frames)) + 1]
            add(chat_entities, { chat = { x = 97, y = 26, frame = chat_frame }, message = { x = 105, y = 26, frame = message_frame } })
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
            g.x -= speed / 8 ---------------- adjust this to make the speed relevant to animation frames *********
            -- if a sprite goes off screen on the left, move it to the right side and change its frame
            if g.x < -8 then
                g.x = g.x + 128
                g.frame = ground_table[level].frames[flr(rnd(#ground_table[level].frames)) + 1]
            end
        end

        rectfill(96, 25, 128, 128, 5) -- right bar
        -- -- draw chat sprites
        for i, entity in pairs(chat_entities) do
            spr(entity.chat.frame, entity.chat.x, entity.chat.y, 1, 1)
            spr(entity.message.frame, entity.message.x, entity.message.y, 3, 1)
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