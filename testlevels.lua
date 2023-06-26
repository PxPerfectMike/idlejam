curr_level_num = 0
curr_level = ''

function init_level_timers()
    timers:start('update_viewers')
    timers:start('incrament_viewers')
    timers:start('donation_time')
    timers:start('sub_time')
end

function tl_init()
    -- enable mouse and buttons (0x5f2d, lmb, rmb)
    poke(0x5f2d, 0x1, 0x2)

    timer:new('click_decay', 0, click_decay_interval)
    timer:new('update_viewers', 0, 4, 1)
    timer:new('incrament_viewers', 0.4, 0.4, 0.3)
    timer:new('donation_time', 0, 20, 5)
    timer:new('sub_time', 0, 1)

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
            tas_max = 20,

            viewer_interest = 5,
            viewer_flux_range = 2,

            idle_sub_buff = 10
        }
    )

    init_level_timers()

    tas_machines = 6
    cpus = 10
end

local right_pressed = false
local left_pressed = false

local new_level = false

function tl_update()
    cls(2)
    local _dt = 1 / stat(7)

    if btn(0) and not left_pressed then
        curr_level_num = (curr_level_num - 1) % #levels.names
        new_level = true

        left_pressed = true
    elseif not btn(0) and left_pressed then
        left_pressed = false
    end

    if btn(1) and not right_pressed then
        curr_level_num = (curr_level_num + 1) % #levels.names
        new_level = true

        right_pressed = true
    elseif not btn(1) and right_pressed then
        right_pressed = false
    end

    if new_level then
        level_clicked = 0
        idle_subs = 0

        curr_level = levels.names[curr_level_num + 1]
        click_val = 0

        curr_viewers = 0
        displayed_viewers = 0

        init_level_timers()

        new_level = false
    end

    lmb:update(_dt)

    -- update all timers
    timers:update(_dt)
    -- update current level
    levels[curr_level]:update()

    -- clear clicked
    lmb.clicked = false
end

function tl_draw()
    local _level = levels[curr_level]

    print(stat(34), 0, 0, 7)
    print('level: ' .. curr_level)
    print('click value: ' .. click_val)
    print('click power: ' .. cpus * (1 + _level.cpu_benefit))
    print('base click value: ' .. tas_machines * _level.tas_benefit)
    print('speed level: ' .. _level:get_speed_val())
    print('viewers: ' .. curr_viewers)
    print('chance: ' .. chance)
    print('sub val: ' .. _level:get_base_val() + _level:get_sub_buff())
    print('idle subs: ' .. idle_subs)

    print('\n[tas machines]: ' .. tas_machines)
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