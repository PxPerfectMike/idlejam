curr_level_num = 0
curr_level = ''
new_level = false

function make_level_timers()
    timer:new('click_decay', 0, click_decay_interval)
    timer:new('update_viewers', 0, 4, 1)
    timer:new('incrament_viewers', 0.4, 0.4, 0.3)
    timer:new('donation_time', 0, 20, 5)
    timer:new('sub_time', 0, 1)
    timer:new('controls_back_on', 0, 5)
end

function init_level_timers()
    timers:start('update_viewers')
    timers:start('incrament_viewers')
    timers:start('donation_time')
    timers:start('sub_time')
end

function tl_init()
    -- enable mouse and buttons (0x5f2d, lmb, rmb)
    poke(0x5f2d, 0x1, 0x2)

    make_level_timers()

    -- construct a new level called 'test1'
    curr_level = level:new(
        'test1', {
            click_threshold = 3,

            cpu_benefit = -0.5,

            tas_benefit = 0.25,
            tas_max = 10,

            viewer_interest = 2,
            viewer_flux_range = 2,

            idle_sub_buff = 5
        }
    )

    level:new(
        'test2', {
            click_threshold = 10,

            cpu_benefit = 1,

            tas_benefit = 1,
            tas_max = 20,

            viewer_interest = 5,
            viewer_flux_range = 2,

            idle_sub_buff = 10
        }
    )

    level:new(
        'test3', {
            click_threshold = 1000,

            cpu_benefit = 1,

            tas_benefit = 1,
            tas_max = 40,

            viewer_interest = 5,
            viewer_flux_range = 2,

            idle_sub_buff = 10
        }
    )

    init_level_timers()

    control:set(
        "lmb",
        function() return stat(34) == 1 end, {
            trigger = function() levels[curr_level]:clicked() end
        }
    )

    control:set(
        "left_arrow",
        function() return btn(0) end, {
            trigger = function()
                curr_level_num = (curr_level_num + 1) % #levels.names
                new_level = true
            end,
            press = function()
                curr_level_num = (curr_level_num + 1) % #levels.names
                new_level = true
            end
        }
    )

    control:set(
        "right_arrow",
        function() return btn(1) end, {
            trigger = function()
                curr_level_num = (curr_level_num + 1) % #levels.names
                new_level = true
            end,
            press = function()
                curr_level_num = (curr_level_num + 1) % #levels.names
                new_level = true
            end
        }
    )

    control:set(
        "up_arrow",
        function() return btn(2) end, {
            trigger = function() cpus += 1 end
        }
    )

    control:set(
        "down_arrow",
        function() return btn(3) end, {
            trigger = function() tas_machines += 1 end
        }
    )

    tas_machines = 6
    cpus = 10
end

function set_new_level()
    if new_level then
        level_clicked = 0
        idle_subs = 0

        curr_level = levels.names[curr_level_num + 1]
        click_val = 0

        roll()

        curr_viewers = 0
        displayed_viewers = 0

        init_level_timers()

        new_level = false
    end
end

function tl_update()
    cls(2)
    local _dt = 1 / stat(7)

    controls:update(_dt)
    -- 1

    -- update all timers
    timers:update(_dt)
    -- 2

    set_new_level()
    -- 3

    -- update current level
    levels[curr_level]:update()
    -- 4

    -- clear clicked
    controls:reset()
    --5
end

function tl_draw()
    local _level = levels[curr_level]

    print('level: ' .. curr_level, 7)

    print('click value', 4, 6)
    print('CUR: ' .. click_val)
    print('MAX: ' .. _level.click_threshold * speed_levels)
    print('POW: ' .. cpus * (1 + _level.cpu_benefit))
    print('BASE: ' .. _level:get_base_val())

    local speed_val = _level:get_speed_val()

    local speed_val_txt = '\nspd LVL: ' .. speed_val .. '\n['

    for i = 0, 19 do
        if i < speed_val then
            speed_val_txt = speed_val_txt .. '▮'
        else
            speed_val_txt = speed_val_txt .. ' '
        end
    end

    speed_val_txt = speed_val_txt .. ']'

    print(speed_val_txt)
    print('viewers: ' .. curr_viewers)
    print('chance: ' .. chance)
    print('sub val: ' .. _level:get_base_val() + _level:get_sub_buff())
    print('idle subs: ' .. idle_subs)

    print('[tas machines]: ' .. tas_machines, 0, 6 * 15)
    print('[cpus]: ' .. cpus)
    print('[displayed viewers]: ' .. displayed_viewers)
    print('[subscribers]: ' .. sub_count)
    print('[money]: ' .. money)

    --[[
    -- == print all timers ======================================================================
    print('timers:', 0, 6 * 16, 7)
    for i = 1, #timers.names do
        local t_name = timers.names[i]
        print('' .. t_name .. ': ' .. timers[t_name].time .. ', ' .. timers[t_name].target)
    end
    -- ==========================================================================================
    ]]
end