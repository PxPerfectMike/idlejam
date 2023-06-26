curr_level_num = 0
curr_level = ''
new_level = false

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

function tl_init()
    -- enable mouse and buttons (0x5f2d, lmb, rmb)
    poke(0x5f2d, 0x1, 0x2)

    -- construct a new level called 'test1'
    curr_level = _level:new(
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

    _level:new(
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

    _level:new(
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

    make_level_timers()
    init_level_timers()

    local func

    control:set(
        "lmb",
        function() return stat(34) == 1 end, {
            trigger = function() _levels[curr_level]:clicked() end
        }
    )

    func = function()
        curr_level_num = (curr_level_num + 1) % #_levels.names
        new_level = true
    end

    control:set(
        "left_arrow",
        function() return btn(0) end, {
            trigger = func,
            press = func
        }
    )

    func = function()
        curr_level_num = (curr_level_num + 1) % #_levels.names
        new_level = true
    end

    control:set(
        "right_arrow",
        function() return btn(1) end, {
            trigger = func,
            press = func
        }
    )

    func = function() cpus += 1 end

    control:set(
        "up_arrow",
        function() return btn(2) end, {
            trigger = func,
            press = func
        }
    )

    func = function() tas_machines += 1 end

    control:set(
        "down_arrow",
        function() return btn(3) end, {
            trigger = func,
            press = func
        }
    )

    tas_machines = 6
    cpus = 10
end

function set_new_level()
    level_clicked = 0
    idle_subs = 0

    curr_level = _levels.names[curr_level_num + 1]
    click_val = 0

    roll()

    curr_viewers = 0
    displayed_viewers = 0

    init_level_timers()

    new_level = false
end

function tl_update()
    cls(2)
    local _dt = 1 / stat(7)

    controls:update(_dt)
    -- 1

    -- update all timers
    _timers:update(_dt)
    -- 2

    if new_level then
        set_new_level()
    end
    -- 3

    -- update current level
    _levels[curr_level]:update()
    -- 4

    -- clear clicked
    controls:reset()
    --5
end

function tl_draw()
    local __level = _levels[curr_level]

    print('level: ' .. curr_level, 7)

    print('click value', 4, 6)
    print('CUR: ' .. click_val)
    print('MAX: ' .. __level.click_threshold * speed_levels)
    print('POW: ' .. cpus * (1 + __level.cpu_benefit))
    print('BASE: ' .. __level:get_base_val())
    print('THLD: ' .. __level.click_threshold)

    local speed_val = __level:get_speed_val()

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
    print('sub val: ' .. __level:get_base_val() + __level:get_sub_buff())
    print('idle subs: ' .. idle_subs)

    print('[tas machines]: ' .. tas_machines .. " LVL MAX:" .. __level.tas_max, 0, 6 * 15)
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