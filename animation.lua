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

ground_table = {{name = "grass", frames = {120, 121, 122, 123, 124, 125, 126, 127}}}

sky_table = {
    {name = "sky", row = 1, frames = {96, 97, 98, 99, 100, 101, 102, 103}},
    {name = "sky", row = 2, frames = {96, 97, 98, 99, 100, 101, 102, 103}},
    {name = "sky", row = 3, frames = {96, 97, 98, 99, 100, 101, 102, 103}},
    {name = "sky", row = 4, frames = {96, 97, 98, 99, 100, 101, 102, 103}},
    {name = "sky", row = 5, frames = {96, 97, 98, 99, 100, 101, 102, 103}},
    {name = "sky", row = 6, frames = {96, 97, 98, 99, 100, 101, 102, 103}},
    {name = "sky", row = 7, frames = {112, 113, 114, 115, 116, 117, 118, 119}},
    {name = "sky", row = 8, frames = {128, 129, 130, 131, 132, 133, 134, 135}},
    {name = "sky", row = 9, frames = {144, 145, 146, 147, 148, 149, 150, 151}},
    {name = "sky", row = 10, frames = {160, 161, 162, 163, 164, 165, 166, 167}},
    {name = "sky", row = 11, frames = {176, 177, 178, 179, 180, 181, 182, 183}},
    {name = "sky", row = 12, frames = {192, 193, 194, 195, 196, 197, 198, 199}},
}


-- Add names as keys
for i, v in ipairs(character_table) do
    character_table[v.name] = v.frames
end

function _init()
    cls()
    sky_speed = 0.3  -- initial sky speed
    palt(14, true) -- pink color as transparency is true
    palt(0, false) -- black color as transparency is false

    -- initialize ground with enough sprites to fill the screen
    for i = 0, 15 do
        add(ground, {x = i * 8, frame = ground_table[1].frames[flr(rnd(#ground_table[1].frames)) + 1]})
    end

-- initialize sky with enough sprites to fill the screen
for i = 0, 15 do
        for j = 1, 12 do
            -- for each sprite, select a random frame from the corresponding row in the sky_table
            add(sky, {x = i * 8, y = sky_arr[j], frame = sky_table[j].frames[flr(rnd(#sky_table[j].frames)) + 1], row = j})
        end
    end
end


function _update()
    character_switch()
    speed_switch()
    animation(character_table[level].frames, speed)
end
ground_speed_control = 21
sky_arr = {25, 33, 41, 49, 57, 65, 73, 81, 89, 97, 105, 113, 121, 129, 137, 145, 153, 161, 169, 177, 185, 193}
function _draw()
    cls()

-- draw sky sprites
for i, s in pairs(sky) do
    spr(s.frame, s.x, s.y, 1, 1)
    s.x -= sky_speed  -- use sky_speed here instead of speed
    -- if a sprite goes off screen on the left, move it to the right side and change its frame
    if s.x < -8 then
        s.x = s.x + 128
        -- select a new sprite from the correct row
        s.frame = sky_table[s.row].frames[flr(rnd(#sky_table[s.row].frames)) + 1]
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

    rectfill(0, 0, 128, 25, 13) -- top bar
    rectfill(96, 25, 128, 128, 6) -- right bar
    -- rectfill(0, 17, 96, 119, 12) -- sky area
    line(0, 25, 128, 25, 7) -- top separator
    line(96, 25, 96, 128, 7) -- right separator

    spr(current_frame, 42, 104, 2, 2)
    print("level: "..level, 2, 10, 7)
    print("character speed: "..speed, 2, 18, 7)
    print("streamer name", 2, 2, 7)
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

    -- Here's the updated mapping for sky_speed.
    -- We raise 1.1 to the power of (speed - 1), and then divide by 20 to get the range we want.
    sky_speed = 1.1^(speed - 1) / 20
end


