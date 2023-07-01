title_screen = { inited = false }
game = { inited = false }
player_name = ''
prompt = {
    start = { x = 0, y = 6 },
    len = 12,
    bg_color = 1
}

-- the height of the top information bar
local top_bar_height = 1 + 8 * 5

--== picture handling methods =======================================================================

-- picture variables
chat_spawn_interval = 1 -- in seconds
chat_spawn_chance = 0.2 -- percentage chance to spawn a picture
max_chat_count = 14

-- table to hold picture sprites
chat_entities = {}

-- working picture stuff
-- picture colors palet
chat_pictures = { 12, 2, 11, 8, 10, 7, 1, 9 }

chat_messages = { 232, 235 }

-- make picture head table
chat_picture_table = { frames = chat_pictures }
chat_message_table = { frames = chat_messages }

function spawn_new_chat()
    -- Check if it's time to possibly spawn a new picture sprite
    if _timers:reached_target('chat_spawn') then
        -- Remove picture sprite at the bottom
        if #chat_entities == max_chat_count then
            del(chat_entities, chat_entities[1])
        end
        -- Chance to spawn a new picture sprite
        if rnd() < chat_spawn_chance and #chat_entities < max_chat_count then
            -- Move existing picture sprites down
            move_chat_down()
            -- Spawn new picture sprite and message at the top
            local picture_frame = chat_picture_table.frames[flr(rnd(#chat_picture_table.frames)) + 1]

            local message_frame = chat_message_table.frames[flr(rnd(#chat_message_table.frames)) + 1]

            add(
                chat_entities, {
                    picture = { x = 97, y = top_bar_height + 1, color = picture_frame },
                    message = { x = 105, y = top_bar_height + 1, frame = message_frame }
                }
            )
        end
    end
end

function move_chat_down()
    for i, entity in pairs(chat_entities) do
        entity.picture.y += 8 -- adjust this value to control how much sprites move down
        entity.message.y += 8 -- adjust this value to control how much messages move down
    end
end

function draw_chat()
    -- draw picture sprites
    for i, entity in pairs(chat_entities) do
        -- draw picture color
        rectfill(entity.picture.x + 2, entity.picture.y + 2, entity.picture.x + 5, entity.picture.y + 6, entity.picture.color)
        -- 80 is the chat picture overlay
        spr(80, entity.picture.x, entity.picture.y, 1, 1)
        spr(entity.message.frame, entity.message.x, entity.message.y, 3, 1)
    end
end

--================================================================================================

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

function construct_level_timers()
    _timer:new('click_decay', 0, click_decay_interval)
    _timer:new('chat_spawn', 0, chat_spawn_interval)
    _timer:new('start_click_decay', 0, 3)
    _timer:new('change_speed', 0, 0.9)
    _timer:new('update_viewers', 0, 4, 1)
    _timer:new('incrament_viewers', 0.4, 0.4, 0.3)
    _timer:new('donation_time', 0, 20, 5)
    _timer:new('sub_time', 0, 1)
    _timer:new('controls_back_on', 0, 5)
end

function init_level_timers()
    _timers:start('update_viewers')
    _timers:start('chat_spawn')
    _timers:start('incrament_viewers')
    _timers:start('donation_time')
    _timers:start('sub_time')
end

--================================================================================================

function set_level_controls()
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

    control:set(
        "cpu_upgrade",
        function() return btn(4) end, {
            trigger = function()
                buttons:set_state("cpu_upgrade", 2)
            end,
            release = function()
                buttons:set_state("cpu_upgrade", 1)
            end
        }
    )

    control:set(
        "tas_upgrade",
        function() return btn(5) end, {
            trigger = function()
                buttons:set_state("tas_upgrade", 2)
            end,
            release = function()
                buttons:set_state("tas_upgrade", 1)
            end
        }
    )

    controls:set_active(true)
end

function draw_mouse()
end

--================================================================================================

function construct_levels()
    -- construct a new level called 'test1'
    curr_level = _level:new(
        'quarrycraft', {
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
        'inky spirits', {
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
        'fruit run', {
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
        'ghost the most', {
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
        'nobodys nebula', {
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

--================================================================================================

function set_new_levels()
    level_clicked = 0
    idle_subs = 0

    curr_level = _levels.names[level]
    click_val = 0

    roll()

    curr_viewers = 0
    displayed_viewers = 0

    speed = 1

    init_level_timers()

    new_level = false
end

--================================================================================================

function construct_level_buttons()
    button:new(
        "cpu_upgrade",
        { x = 109, y = 8, w = 16, h = 16 },
        {
            { x = 64, y = 96, w = 16, h = 16 },
            { x = 80, y = 96, w = 16, h = 16 }
        }
    )

    button:new(
        "tas_upgrade",
        { x = 90, y = 8, w = 16, h = 16 },
        {
            { x = 96, y = 96, w = 16, h = 16 },
            { x = 112, y = 96, w = 16, h = 16 }
        }
    )
end

--================================================================================================

function game:init()
    construct_levels()
    set_level_controls()
    construct_level_timers()
    init_level_timers()
    construct_level_buttons()

    bg_transition_needed = true

    -- initial sky speed
    sky_speed = 0.3

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

--================================================================================================

function title_screen:init()
    keyboard_input:start(prompt.len, prompt.start.x, prompt.start.y)
end

--================================================================================================

function _init()
    -- enable mouse and buttons (0x5f2d, lmb, rmb)
    poke(0x5f2d, 0x1, 0x2)

    -- pink color as transparency is true
    palt(14, true)
    -- black color as transparency is false
    palt(0, false)

    title_screen:init()
end

--================================================================================================

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

prev_level = 1 -- Initialize this with your initial level

--================================================================================================

function incrament_animation_speed()
    local level_data = _levels[curr_level]

    local curr_speed = level_data:get_speed_val()

    if click_val != level_data:get_base_val() then
        _timers:start('change_speed')
    elseif curr_speed == speed then
        _timers:stop('change_speed')
    end

    if _timers:reached_target('change_speed') and curr_speed > speed then
        speed += 1
    end

    if _timers:reached_target('change_speed') and curr_speed < speed then
        speed -= 1
    end

    if speed == 0 then
        speed = 1
    end
end

--================================================================================================

local mouse_state = 0

function game:update(dt)
    if new_level then
        set_new_levels()
    end

    -- update current level
    _levels[curr_level]:update()
    -- 4

    incrament_animation_speed()

    sky_speed = 1.1 ^ (speed - 1) / 20
    -- 3

    animation(character_table[level].frames)

    if buttons:is_in("cpu_upgrade", stat(32), stat(33)) then
        if stat(34) == 1 then
            mouse_state = 2
        else
            mouse_state = 1
        end
    else
        mouse_state = 0
    end

    if level ~= prev_level then
        -- Indicate that a background transition is needed
        bg_transition_needed = true
        prev_level = level
    end

    bg_transition()

    spawn_new_chat()
end

--================================================================================================

function title_screen:update(dt)
    if keyboard_input:record(9) and #keyboard_input:get_val() > 0 then
        player_name = keyboard_input:get_val()
        keyboard_input:stop()
    end
end

--================================================================================================

function _update()
    local _dt = 1 / stat(7)

    controls:update(_dt)

    -- update all timers
    _timers:update(_dt)

    if #player_name == 0 then
        title_screen:update(_dt)
    else
        -- initalize main game state
        if not game.inited then
            game:init()
            game.inited = true
        end
        game:update(_dt)
    end

    -- clear triggered for all controls
    controls:reset()
end

--================================================================================================

-- draw ground sprites
function draw_ground()
    for i, g in pairs(ground) do
        spr(g.frame, g.x, 120, 1, 1)
        g.x -= speed / 8 ---------------- adjust this to make the speed relevant to animation frames *********
        -- if a sprite goes off screen on the left, move it to the right side and change its frame
        if g.x < -8 then
            g.x = g.x + 128
            g.frame = ground_table[level].frames[flr(rnd(#ground_table[level].frames)) + 1]
        end
    end
end

function draw_bars()
    -- top bar
    rectfill(0, 0, 128, top_bar_height, 13)
    -- right bar
    rectfill(96, top_bar_height, 128, 128, 5)

    -- rectfill(0, 17, 96, 119, 12) -- sky area

    -- top separator
    line(0, top_bar_height, 128, top_bar_height, 7)
    -- right separator
    line(96, top_bar_height, 96, 128, 7)
end

function draw_info()
    spr(current_frame, 42, 104, 2, 2)
    print(player_name, 2, 2, 8)
    print("level: " .. level, 2, 10, 7)
    print("character speed: " .. speed, 2, 18, 7)

    print("click val: " .. click_val, 4 * 10 + 2, 10)

    local speed_val = _levels[curr_level]:get_speed_val()

    --============================================================================================

    local speed_display = ''

    for i = 0, 19 do
        if i < speed_val then
            speed_display = speed_display .. '▮'
        else
            speed_display = speed_display .. ' '
        end
    end

    print('[' .. speed_display .. ']', 2, 2 + 6 * 5, 11)

    --============================================================================================
end

function draw_buttons()
    buttons:move("tas_upgrade", 90, 22)
    buttons:draw("tas_upgrade")

    buttons:move("cpu_upgrade", 109, 22)
    buttons:draw("cpu_upgrade")
end

function draw_mouse()
    spr(mouse_state, stat(32), stat(33))
end

--================================================================================================

function game:draw()
    draw_sky()

    draw_ground()

    draw_bars()

    draw_chat()

    draw_info()

    draw_buttons()

    draw_mouse()
end

--================================================================================================

function title_screen:draw()
    print("what's your streamer tag?:", 0, 0, 7)

    --============================================================================================
    -- draw the text input background box
    local txt_dim = { x = 4, y = 6 }

    rectfill(
        prompt.start.x - 1, prompt.start.y - 1,
        prompt.start.x + txt_dim.x * prompt.len - 1, prompt.start.y + txt_dim.y - 1,
        prompt.bg_color
    )
    --============================================================================================

    print('[tab to return]', prompt.start.x + txt_dim.x * prompt.len, prompt.start.y, 7)

    keyboard_input:draw()

    draw_mouse()
end

--================================================================================================

function _draw()
    cls()

    if not game.inited then
        title_screen:draw()
    else
        game:draw()
    end
end