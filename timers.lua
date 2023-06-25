local timers = {
    names = {},
    time = {},
    target = {},
    base_reset = {},
    rnd_reset = {}
}

function timers:add(name, target, base_reset, rnd_reset)
    if name and target and type(name) == 'string' and type(target) == 'number' then
        add(self.names, name)
        self.time[name] = 0
        self.target[name] = target

        if base_reset and type(base_reset) == 'number' then
            self.base_reset[name] = base_reset
        else
            self.base_reset[name] = 0
        end

        if rnd_reset and type(rnd_reset) == 'number' then
            self.rnd_reset[name] = rnd_reset
        else
            self.rnd_reset[name] = 0
        end

        return true
    end

    return false
end

function timers:set_time(name, time)
    if name and time and type(name) == 'string' and self.time[name] and type(time) == 'number' then
        self.time[name] = time
    end
end

function timers:get_time(name)
    if name and type(name) == 'string' and self.time[name] then
        return self.time[name]
    end
    return nil
end

function timers:start(name, time)
    if name and type(name) == 'string' and self.time[name] then
        self.time[name] = 0
        if time and type(time) == 'number' then
            self.target[name] = time
        else
            local rnd_reset = self.rnd_reset[name]
            self.target[name] = self.base_reset[name] + rnd(rnd_reset * 2) - rnd_reset
        end
    end
end

function timers:stop(name)
    if name and type(name) == 'string' and self.time[name] then
        self.target[name] = 0
    end
end

-- set the timer's loop interval
function timers:set_loop(name, time, time_flux)
    if name and time and type(name) == 'string' and self.time[name] and type(time) == 'number' then
        self.base_reset[name] = time

        if time_flux and type(time_flux) == 'number' then
            self.rnd_reset[name] = time_flux
        else
            self.rnd_reset[name] = 0
        end
    end
end

-- if the timer as reached it's targeted time
function timers:reached_target(name)
    if name and type(name) == 'string' and self.time[name] and self.target[name] != 0 then
        return self.time[name] >= self.target[name]
    end
    return nil
end

function timers:is_active(name)
    if name and type(name) == 'string' and self.time[name] then
        return self.target[name] != 0
    end
    return nil
end

function timers:update(dt)
    for i = 1, #self.names do
        -- get the name of the timer to evaluate
        local name = self.names[i]

        if self.target[name] != 0 and self.time[name] >= self.target[name] then
            -- move the timer back by the appropriate ammount
            self.time[name] -= self.target[name]
            local rnd_reset = self.rnd_reset[name]
            -- set a new target time
            self.target[name] = self.base_reset[name] + rnd(rnd_reset * 2) - rnd_reset
        end

        if (self.target[name] != 0) self.time[name] += dt
    end
end