-- global variables

-- defined values
local click_decay_interval = 1 / 4 -- what fraction of a second does the click decay happen
local donations_per_viewer = 5
local idle_sub_buff = 5 -- the buffer for the idle subscriber spot (3)

-- system variables
local clicked = false -- if the player has clicked this frame

local donation_time --= rnd(time_flux + base_time)

-- counting tracker variables
local money = long_num()
local sub_count = 0

local cpus = 1
local tas_machines = 0

local click_val = 0 -- the current total value from clicking

-- !!!!!!! update these so that they work with long_num
local curr_viewers = 0
local displayed_viewers = 0

local speed_level = 0

local chance = 100
local base_val = 0

local threshold_count = 20 -- how many thresholds there are

-- level class
level = {
    click_threshold = 0, -- how much click_val for a speed_val

    cpu_benefit = 1, -- how much the cpu affects the "game play" speed

    tas_benefit = 1, -- how much base speed is applied
    tas_max = 10, -- how many tas machines the player can have

    viewer_interest = 1, -- the multiply for how many viewers this game draws per speed level
    viewer_flux_range = 2, -- the rentention fluxation of this game

    -- idle sub variables (don't modify)
    level_clicked = 0, -- how many time the player clicked in this level
    idle_subs = 0 -- how many subscribers will subscribe while the player does nothing
}
level.__index = level

function level:new(o)
    return setmetatable(o or {}, self)
end

-- calculating speed
function level:find_speed()
    speed_level = flr(click_val / self.click_threshold)
end

function level:clicked()
    click_val += cpus * (1 + self.cpu_benefit)
    -- the max value a click can have
    local click_max = self.click_threshold * 20
    -- base click value

    if click_val > click_max then
        click_val = click_max
    end

    timers:start('click_decay')

    -- calculate idle sub chance
    self.level_clicked += 1

    if self.level_clicked == 100 then
        self.idle_subs += 1
        self.level_clicked = 0
    end
end

-- calculating viewers
function level:find_viewers()
    local base_viewers = flr(speed_level * self.viewer_interest)

    curr_viewers = flr(rnd(self.viewer_flux_range * 2) - self.viewer_flux_range) + base_viewers
    if (curr_viewers < 0) curr_viewers = 0
end

-- rolling the chance variable for a percentage of 100
function roll_chance()
    chance = rnd(100)
end

function level:sub_gain()
    -- how high the click_val must be to gain subscribers idly
    local sub_val = base_val + idle_sub_buff

    if click_val >= sub_val and chance <= 3 then
        sub_count += 1
    elseif self.idle_subs > 0 and chance <= 1 then
        sub_count += 1
        self.idle_subs -= 1
    end
end

function level:update()
    if timers:reached_target('sub_time') then
        self:sub_gain()
        roll_chance()
        money = money + sub_count
    end

    if timers:reached_target('incrament_viewers') then
        if displayed_viewers > curr_viewers then
            displayed_viewers -= 1
        elseif displayed_viewers < curr_viewers then
            displayed_viewers += 1
        end
    end

    if timers:reached_target('donation_time') then
        money = money + donations_per_viewer * curr_viewers
    end

    if timers:reached_target('click_decay') and not clicked then
        click_val -= 1
    end

    base_val = (tas_machines <= self.tas_max and tas_machines or tas_max)
            * self.tas_benefit

    if click_val < base_val then
        click_val = base_val
        timers:stop('click_decay')
    end
end