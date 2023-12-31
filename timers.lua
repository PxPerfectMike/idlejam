--==================================================================================================
-- _timer class
_timer = {
    time = 0,
    target = 0,
    base_reset = 0,
    rnd_reset = 0
}
_timer.__index = _timer
--==================================================================================================
-- global table of all _timers
_timers = { names = {} }

--==================================================================================================
-- _timer functions
function _timer:new(name, target, base_reset, rnd_reset)
    assert(name, '_timer needs a name.')
    assert(type(name) == 'string', '_timer name needs to be a string.')
    assert(_timers[name] == nil, '_timer with that name already exists!')

    add(_timers.names, name)

    new__timer = {}

    if target and type(target) == 'number' then
        new__timer['target'] = target
    end
    if base_reset and type(base_reset) == 'number' then
        new__timer['base_reset'] = base_reset
    end
    if rnd_reset and type(rnd_reset) == 'number' then
        new__timer['rnd_reset'] = rnd_reset
    end

    _timers[name] = setmetatable(new__timer, self)

    return _timers[name]
end

function time_is_num(time)
    assert(type(time) == 'number', "Time must be a number value!")
end

function _timer:set_time(time)
    time_is_num(time)
    self.time = time
end

function _timer:get_time()
    return self.time
end

-- set the timer's loop interval
function _timer:set_loop(time, time_flux)
    time_is_num(time)
    self.base_reset = time

    if time_flux then
        assert(type(time_flux) == 'number', "Time flux must be a number value!")
        self.rnd_reset = time_flux
    end
end

-- start the timer
function _timer:start(time)
    local rnd_reset = self.rnd_reset
    self.target = type(time) == 'number' and time or self.base_reset + rnd(rnd_reset * 2) - rnd_reset
end

-- stop the timer
function _timer:stop()
    self.target = 0
end

-- if the timer as reached it's targeted time
function _timer:reached_target()
    return self.target != 0 and self.time >= self.target or false
end

-- if the timer is currently running
function _timer:is_active()
    return self.target != 0
end
--==================================================================================================

--==================================================================================================
-- all timers accessable functions
-- checks if timer exists
function _timers:check_for__timer(name)
    assert(type(name) == 'string', "name must be a string!")
    assert(self[name], "_timer with that name dosen't exist")
end

function _timers:set_time(name, time)
    self:check_for__timer(name)
    self[name]:set_time(time)
end

function _timers:get_time(name, time)
    self:check_for__timer(name)
    return self[name]:get_time(time)
end

-- set the timer's loop interval
function _timers:set_loop(name, time, time_flux)
    self:check_for__timer(name)
    self[name]:set_loop(time, time_flux)
end

function _timers:start(name, time)
    self:check_for__timer(name)
    self[name]:start(time)
end

function _timers:stop(name)
    self:check_for__timer(name)
    self[name]:stop()
end

-- if the timer as reached it's targeted time
function _timers:reached_target(name)
    self:check_for__timer(name)
    return self[name]:reached_target()
end

-- if the timer is currently running
function _timers:is_active(name)
    self:check_for__timer(name)
    return self[name]:is_active()
end

-- update all timers
function _timers:update(dt)
    for i = 1, #self.names do
        -- get the name of the _timer to evaluate
        local name = self.names[i]
        -- local copy of _timer to evaluate to reduce accesser overhead
        local t = self[name]

        -- if _timer is active
        if t.target != 0 then
            -- _timer's target reached
            if t.time >= t.target then
                -- move the _timer back by current target time to keep consistency
                self[name].time -= t.target
                -- set a new target time
                local rnd_reset = t.rnd_reset
                self[name].target = t.base_reset + rnd(rnd_reset * 2) - rnd_reset
            end
            self[name].time += dt
        end
    end
end
--==================================================================================================