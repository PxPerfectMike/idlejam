-- starting frame
frame = 0

-- level number
level = 1
speed = 1

-- position of the rightmost ground sprite
rightmost_ground_x = 128

-- table to hold ground sprites
ground = {}
sky = {}

-- table of sprite numbers for the run animation
character_table = {
    {name = "little_guy", frames = {16, 18, 20, 22}},
    {name = "knight", frames = {24, 26, 28, 30}},
    {name = "orange", frames = {48, 50, 52, 54}},
    {name = "ghost", frames = {56, 58, 60, 62}},
    {name = "spaceship", frames = {88, 90, 92, 94}}
}

ground_table = {
    {name = "grass", frames = {120, 121, 122, 123, 124, 125, 126, 127}},
}

sky_table = {{name = "sky", frames = {}}}

-- Add names as keys
for i, v in ipairs(character_table) do
    character_table[v.name] = v.frames
end

function _init()
    cls()
    
    palt(14, true) -- pink color as transparency is true
    palt(0, false) -- black color as transparency is false

    -- initialize ground with enough sprites to fill the screen
    for i = 0, 15 do
        add(ground, {x = i * 8, frame = ground_table[1].frames[flr(rnd(#ground_table[1].frames)) + 1]})
    end

    -- initialize sky with enough sprites to fill the screen
    for i = 0, 15 do
        add(sky, {x = i * 8, frame = sky_table[1].frames[flr(rnd(#sky_table[1].frames)) + 1]})
    end
end

function _update()
    character_switch()
    speed_switch()
    animation(character_table[level].frames, speed)
end
ground_speed_control = 21

function _draw()
    cls()

    -- draw sky sprites
    for i, s in pairs(sky) do
        spr(s.frame, s.x, 0, 1, 15)
        s.x -= speed
        -- if a sprite goes off screen on the left, move it to the right side and change its frame
        if s.x < -8 then
            s.x = s.x + 128
            s.frame = sky_table[1].frames[flr(rnd(#sky_table[1].frames)) + 1]
        end
    end

    -- draw ground sprites
    for i, g in pairs(ground) do
        spr(g.frame, g.x, 120, 1, 1)
        g.x -= speed / ground_speed_control + 0.2
        -- if a sprite goes off screen on the left, move it to the right side and change its frame
        if g.x < -8 then
            g.x = g.x + 128
            g.frame = ground_table[1].frames[flr(rnd(#ground_table[1].frames)) + 1]
        end
    end

    rectfill(0, 0, 128, 16, 13) -- top bar
    rectfill(96, 17, 128, 128, 6) -- right bar
    rectfill(0, 17, 96, 119, 12) -- sky area
    line(0, 16, 128, 16, 7) -- top separator
    line(96, 17, 96, 128, 7) -- right separator

    spr(current_frame, 42, 104, 2, 2)
    print("level: "..level, 2, 2, 7)
    print("character speed: "..speed, 2, 10, 7)
end

function animation(sprite, animation_speed)
    local actual_speed = ground_speed_control - animation_speed
    if frame % actual_speed == 0 then
        current_frame = sprite[(frame / actual_speed % #sprite) + 1]
    end
    frame += 1
    return actual_speed
end

function character_switch()
    if btnp(➡️) then
        level += 1
    elseif btnp(⬅️) then
        level -= 1
    end
    if level > 5 then
        level = 1
    elseif level < 1 then
        level = 5
    end
end

function speed_switch()
    if btnp(⬆️) then
        speed += 1
    elseif btnp(⬇️) then
        speed -= 1
    end
    if speed > 19 then
        speed = 1
    elseif speed < 1 then
        speed = 19
    end
end
