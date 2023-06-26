-- global variables

-- defined values
click_decay_interval = 1 / 4 -- what fraction of a second does the click decay happen

-- counting tracker variables
money = long_num()
sub_count = long_num()

donos_per_viewer = 5 -- donations per viewer

-- first roll for a random range of donations
-- then roll for a random value in that range
dono_pool = {
    { '1', '2', '3', '4', '5', '9' }, -- 50 percent
    { '10', '20', '40', '50', '90' }, -- 25 percent
    { '100', '500', '900' }, -- 10 percent
    { '1000', '5000', '9000' }, -- 5 percent
    { '10000', '20000', '30000', '40000', '50000' }, -- 3 percent
    { '10000000' } -- 1 percent
}

speed_levels = 20 -- how many thresholds there are

active_sub_chance = 4
idle_sub_chance = 2

cpus = 1
cpu_price_growth = 100

tas_machines = 0
cpu_price_growth = 100

-- idle sub variables (don't modify)
level_clicked = 0 -- how many time the player clicked in this level
idle_subs = 0 -- how many subscribers will subscribe while the player does nothing

--======================================================
-- !!!!!!! update these so that they work with long_num
cpu_base_price = 100
cpu_current_price = 100

tas_base_price = 100
tas_current_price = 100

click_val = 0 -- the current total value from clicking

curr_viewers = 0
displayed_viewers = 0
--======================================================

chance = 0

--==================================================================================================
-- level class
level = {
    click_threshold = 3, -- how much click value for a speed level

    cpu_benefit = 1, -- how much the cpu affects the "game play" speed

    tas_benefit = 1, -- how much base speed is applied
    tas_max = 10, -- how many tas machines the player can have

    viewer_interest = 1, -- the multiply for how many viewers this game draws per speed level
    viewer_flux_range = 2, -- the rentention fluxation of this game

    sub_buff = 5 -- how much higher click value should be than base_val to possibly increase subs
}
level.__index = level
--==================================================================================================
-- global table of all levels
levels = {
    names = {}
}

function level:new(name, o)
    assert(type(name) == 'string', 'there needs to be a "name" string.')
    assert(levels[name] == nil, 'Level with that name already exists!')

    add(levels.names, name)

    levels[name] = setmetatable(o or {}, self)

    return name
end

-- get speed value
function level:get_speed_val()
    --long_flr(long_num(click_val) * 0.05)
    return flr(click_val / self.click_threshold)
end

-- get base speed value
function level:get_base_val()
    return (tas_machines <= self.tas_max and tas_machines or self.tas_max) * self.tas_benefit
end

-- get minimum click value to get subscribers
function level:get_sub_buff()
    return self.sub_buff
end

function level:clicked()
    click_val += cpus * (1 + self.cpu_benefit)
    -- the max value a click can have
    local click_max = self.click_threshold * speed_levels
    -- base click value

    if click_val > click_max then
        click_val = click_max
    end

    timers:start('click_decay')

    -- calculate idle sub chance
    level_clicked += 1

    if level_clicked == 100 then
        idle_subs += 1
        level_clicked = 0
    end
end

-- rolling the chance variable for a value from 100-1
function roll()
    chance = flr(rnd(100)) + 1
end

function level:update()
    -- find the base speed value
    local base_val = (tas_machines <= self.tas_max and tas_machines or self.tas_max) * self.tas_benefit

    -- do click decay
    if timers:reached_target('click_decay') then
        click_val -= 1 + self.cpu_benefit
    end

    if click_val < base_val then
        click_val = base_val
        timers:stop('click_decay')
    end

    -- do subscription calculations
    if timers:reached_target('sub_time') then
        -- the max value a click can have
        local click_max = self.click_threshold * speed_levels
        -- how high the click value must be to gain subscribers actively
        local sub_val = base_val + self.sub_buff

        if click_max < sub_val then sub_val = click_max end

        -- rolling the chance variable for a percentage of 100
        roll()

        if (base_val == sub_val and timers:is_active('click_decay') or click_val >= sub_val) and chance <= active_sub_chance then
            sub_count += 1
        elseif idle_subs > 0 and chance <= idle_sub_chance then
            sub_count += 1
            idle_subs -= 1
        end

        money += sub_count
    end

    -- calculating viewer count
    if timers:reached_target('update_viewers') then
        local base_viewers = flr(click_val / self.click_threshold * self.viewer_interest)

        curr_viewers = flr(rnd(self.viewer_flux_range * 2) - self.viewer_flux_range) + base_viewers
        if (curr_viewers < 0) curr_viewers = 0
    end

    -- slowly incrament the displayed viewer count to the actual viewer count
    if timers:reached_target('incrament_viewers') then
        if displayed_viewers > curr_viewers then
            displayed_viewers -= 1
        elseif displayed_viewers < curr_viewers then
            displayed_viewers += 1
        end
    end

    -- do donation calculations
    if timers:reached_target('donation_time') then
        money += donos_per_viewer * curr_viewers
    end
end

function levels:load(name)
    assert(type(name) == 'string', 'there needs to be a "name" string.')
    assert(levels[name], 'Level does not exist')
end

-- credit for the equations goes to Anthony Percorella, "The Math of Idle Games, Part 1", Kongregate Developers Blog
--[[
      find how much the next upgrade cost
      b = the base price
      r = the price growth rate exponent
      k = the number of generators currently owned
  ]]
function cost_next(b, r, k)
    return b * r ^ (k or 1)
end