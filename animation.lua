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

-- Function to generate frames
function generate_frames(start, count)
    local frames = {}
    for i = 0, count do add(frames, start + i) end
    return frames
end

-- all tables spawn by index and must be in the same order to maintain theme consistency
-- table of sprite numbers for the run animation
character_table = {
    {name = "little_guy", frames = {16, 18, 20, 22}},
    {name = "knight", frames = {24, 26, 28, 30}},
    {name = "orange", frames = {48, 50, 52, 54}},
    {name = "ghost", frames = {56, 58, 60, 62}},
    {name = "spaceship", frames = {88, 90, 92, 94}}
}

-- all tables spawn by index and must be in the same order to maintain theme consistency
ground_start_frames = {120, 152, 168, 136, 184}
ground_names = {"grass", "ds_ground", "watermelon", "graveyard", "space"}

ground_table = {}
for i, start_frame in ipairs(ground_start_frames) do
    ground_table[i] = {name = ground_names[i], frames = generate_frames(start_frame, 7)}
end

-- all tables spawn by index and must be in the same order to maintain theme consistency
sky_table = {}
for i = 1, 12 do
    local start_frame = 96
    if i > 6 then
        start_frame = start_frame + ((i - 6) * 16)
    end
    sky_table[i] = {name = "sky", row = i, frames = generate_frames(start_frame, 7)}
end

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
        ------------>changed both ground_table indexes from 1 to level
        add(ground, {x = i * 8, frame = ground_table[level].frames[flr(rnd(#ground_table[level].frames)) + 1]})
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
            g.frame = ground_table[level].frames[flr(rnd(#ground_table[level].frames)) + 1]
        end
    end

    rectfill(0, 0, 128, 25, 13) -- top bar
    rectfill(96, 25, 128, 128, 6) -- right bar
    -- rectfill(0, 17, 96, 119, 12) -- sky area
    line(0, 25, 128, 25, 7) -- top separator
    line(96, 25, 96, 128, 7) -- right separator

    spr(current_frame, 42, 104, 2, 2)
    print("streamer name", 2, 2, 8)
    print("level: "..level, 2, 10, 7)
    print("character speed: "..speed, 2, 18, 7)
end

function animation(sprite, animation_speed)
    local actual_speed = ground_speed_control - animation_speed

    if (frame % actual_speed == 0) current_frame = sprite[(frame / actual_speed % #sprite) + 1]

    frame += 1

end

function character_switch()
    if (btnp(➡️)) level += 1
    if (btnp(⬅️)) level -= 1
    if (level > 5) level = 1
    if (level < 1) level = 5
end

function speed_switch()
    if (btnp(⬆️)) speed += 1
    if (btnp(⬇️)) speed -= 1
    if (speed > 19) speed = 1
    if (speed < 1) speed = 19

    -- Here's the updated mapping for sky_speed.
    -- We raise 1.1 to the power of (speed - 1), and then divide by 20 to get the range we want.
    sky_speed = 1.1^(speed - 1) / 20
end


