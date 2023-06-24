-- global variables

-- defined values
local click_decay = 1 -- how much click_val decays per frame
local click_decay_interval = 4 -- what fraction of a second does the click decay
local donations_per_viewer
local idle_sub_buff -- the buffer for the idle subscriber spot (3)

-- system variables
local clicked = false -- if the player has clicked this frame

local donation_time --= rnd(time_flux + base_time)

-- counting tracker variables
local money = 0
local sub_count = 0

local cpus = 1
local tas_machines = 0
function set_tas_machines(num)
    tas_machines = num
end

local click_val = 0 -- the current total value from clicking

-- level class
level = {
    click_threshold = 0, -- how much click_val for a speed_val
    threshold_count = 0, -- how many thresholds there are this level
    cpu_benefit = 0, -- how much the cpu affects the "game play" speed
    tas_benefit = 0, -- how much base speed is applied
    tas_max = 0, -- how many tas machines the player can have
    viewer_interest = 0, -- the multiply for how many viewers this game draws
    viewer_flux_range = 0, -- the rentention fluxation of this game
    level_clicked = 0, -- how many time the player clicked in this level
    idle_sub_chance = 0 -- how likely a subscriber will subscribe while the player is doing nothing
}
level.__index = level

function level:new(o)
    return setmetatable(o or {}, self)
end

-- calculating speed
local speed_level
function level:find_speed()
    speed_level = flr(click_val / self.click_threshold)
end
function get_speed_level()
    return speed_level
end

-- calculating click val
function get_click_val()
    return click_val
end

function level:clicked()
    click_val += cpus * (1 + self.cpu_benefit)
    -- the max value a click can have
    local click_max = self.click_threshold * self.threshold_count
    -- base click value

    if click_val > click_max then
        click_val = click_max
    end

    clicked = true

    -- calculate idle sub chance
    self.level_clicked += 1

    if self.level_clicked == 100 then
        self.idle_sub_chance += 1
        self.level_clicked = 0
    end
end

-- calculating viewers
local viewer_diff
local old_viewer
local curr_viewers = 0
function level:find_viewers()
    -- must change slowly
    local base_viewers = flr(speed_level * self.viewer_interest)

    --base_viewers

    curr_viewers = flr(rnd(self.viewer_flux_range * 2) - self.viewer_flux_range) + base_viewers
    if (curr_viewers < 0) curr_viewers = 0
end

function get_viwers()
    return curr_viewers
end

-- rolling the chance variable for a percentage of 100
local chance = 0
function roll_chance()
    chance = rnd(100)
end

function level:sub_gain()
    -- how high the click_val must be to gain subscribers idly
    local idle_sub_spot = base_val + idle_sub_buff

    if speed_level > idle_sub_spot and chance <= 3 then
        sub_count += 1
    elseif idle_sub_chance > 0 and chance <= 1 then
        sub_count += 1
        idle_sub_chance -= 1
    end
end

local timer = 0
local base_val
function level:update(dt)
    --[[
    timer += dt or 0
    if timer >= donation_time then
        money += donations_per_viewer * curr_viewers
        timer = 0
        donation_time = 20 + flr(rnd(10))
    end
    ]]

    timer += 1

    if timer == flr(30 / click_decay_interval) then
        if not clicked then
            click_val -= click_decay
        end

        base_val = (tas_machines <= self.tas_max and tas_machines or tas_max)
                * self.tas_benefit

        if click_val < base_val then
            click_val = base_val
        end
        timer = 0
    end

    clicked = false
end