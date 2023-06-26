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

--===============================================================
-- math level management
curr_level = ''
new_level = false -- flag to switch level
--===============================================================

function make_level_timers()
    _timer:new('click_decay', 0, click_decay_interval)
    _timer:new('update_viewers', 0, 4, 1)
    _timer:new('incrament_viewers', 0.4, 0.4, 0.3)
    _timer:new('donation_time', 0, 20, 5)
    _timer:new('sub_time', 0, 1)
    _timer:new('controls_back_on', 0, 5)
end

function init_level_timers()
    _timers:start('update_viewers')
    _timers:start('incrament_viewers')
    _timers:start('donation_time')
    _timers:start('sub_time')
end

function set_level_controls()
    -- enable mouse and buttons (0x5f2d, lmb, rmb)
    poke(0x5f2d, 0x1, 0x2)

    control:set(
        "lmb",
        function() return stat(34) == 1 end, {
            trigger = function()
                _levels[curr_level]:clicked()
            end
        }
    )

    control:set(
        "left_arrow",
        function() return btn(0) end, {
            trigger = function()
                level -= 1
                if (level > 5) level = 1
                if (level < 1) level = 5
                new_level = true
            end
        }
    )

    control:set(
        "right_arrow",
        function() return btn(1) end, {
            trigger = function()
                level += 1
                if (level > 5) level = 1
                if (level < 1) level = 5
                new_level = true
            end
        }
    )
end

function construct_levels()
    -- construct a new level called 'test1'
    curr_level = _level:new(
        'lvl1', {
            click_threshold = 1,

            cpu_benefit = 1,

            tas_benefit = 1,
            tas_max = 20,

            viewer_interest = 2,
            viewer_flux_range = 2,

            idle_sub_buff = 5
        }
    )

    _level:new(
        'lvl2', {
            click_threshold = 10,

            cpu_benefit = 1,

            tas_benefit = 1,
            tas_max = 20,

            viewer_interest = 5,
            viewer_flux_range = 2,

            idle_sub_buff = 10
        }
    )

    _level:new(
        'lvl3', {
            click_threshold = 1000,

            cpu_benefit = 1,

            tas_benefit = 1,
            tas_max = 40,

            viewer_interest = 5,
            viewer_flux_range = 2,

            idle_sub_buff = 10
        }
    )

    _level:new(
        'lvl4', {
            click_threshold = 1000,

            cpu_benefit = 1,

            tas_benefit = 1,
            tas_max = 40,

            viewer_interest = 5,
            viewer_flux_range = 2,

            idle_sub_buff = 10
        }
    )

    _level:new(
        'lvl5', {
            click_threshold = 1000,

            cpu_benefit = 1,

            tas_benefit = 1,
            tas_max = 40,

            viewer_interest = 5,
            viewer_flux_range = 2,

            idle_sub_buff = 10
        }
    )
end

function set_new_level()
    level_clicked = 0
    idle_subs = 0

    curr_level = _levels.names[level]
    click_val = 0

    roll()

    curr_viewers = 0
    displayed_viewers = 0

    init_level_timers()

    new_level = false
end

function _init()
    construct_levels()
    set_level_controls()
    make_level_timers()
    init_level_timers()

    bg_transition_needed = true

    cls()
    sky_speed = 0.3
    -- initial sky speed
    palt(14, true)
    -- pink color as transparency is true
    palt(0, false)
    -- black color as transparency is false

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
    end

    -- Reset the flag
    bg_transition_needed = false
end

prev_level = 1 -- Initialize this with your initial level

function _update()
    local _dt = 1 / stat(7)

    controls:update(_dt)
    -- 1

    -- update all timers
    _timers:update(_dt)
    -- 2

    if new_level then
        set_new_level()
    end

    -- update current level
    _levels[curr_level]:update()
    -- 4

    -- set speed values
    speed = _levels[curr_level]:get_speed_val() + 1
    sky_speed = 1.1 ^ (speed - 1) / 20
    -- 3

    animation(character_table[level].frames)

    if level ~= prev_level then
        -- Indicate that a background transition is needed
        bg_transition_needed = true
        prev_level = level
    end

    bg_transition()

    -- Increase timer by frame duration
    chat_spawn_timer += _dt

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
            add(
                chat_entities, {
                    chat = { x = 97, y = 26, frame = chat_frame },
                    message = { x = 105, y = 26, frame = message_frame }
                }
            )
        end
    end

    -- clear clicked
    controls:reset()
    --5
end

-- draw sky sprites
function draw_sky()
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
end

local test

-- draw ground sprites
function draw_ground()
    for i, g in pairs(ground) do
        test = g.x
        spr(g.frame, g.x, 120, 1, 1)
        g.x -= speed / 8 ---------------- adjust this to make the speed relevant to animation frames *********
        -- if a sprite goes off screen on the left, move it to the right side and change its frame
        if g.x < -8 then
            g.x = g.x + 128
            g.frame = ground_table[level].frames[flr(rnd(#ground_table[level].frames)) + 1]
        end
    end
end

function draw_chat()
    -- right bar
    rectfill(96, 25, 128, 128, 5)

    -- draw chat sprites
    for i, entity in pairs(chat_entities) do
        print('draw ' .. entity.chat.frame, 4 * 15 + 2, 2, 7)
        spr(entity.chat.frame, entity.chat.x, entity.chat.y, 1, 1)
        spr(entity.message.frame, entity.message.x, entity.message.y, 3, 1)
    end
end

function draw_top_bar()
    -- top bar
    rectfill(0, 0, 128, 25, 13)

    -- rectfill(0, 17, 96, 119, 12) -- sky area
    line(0, 25, 128, 25, 7)
    -- top separator
    line(96, 25, 96, 128, 7)
    -- right separator

    spr(current_frame, 42, 104, 2, 2)
    print("ground frame: " .. test, 4 * 15 + 2, 2, 7)
    print("streamer name", 2, 2, 8)
    print("level: " .. level, 2, 10, 7)
    print("character speed: " .. speed, 2, 18, 7)

    print("click val: " .. click_val, 4 * 10 + 2, 10)
end

function _draw()
    cls()

    draw_sky()

    draw_ground()

    draw_chat()

    draw_top_bar()
end