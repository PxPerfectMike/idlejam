-- starting frame
frame = 0

-- level number
level = 1
speed = 1

-- position of the rightmost ground sprite
rightmost_ground_x = 128

-- table to hold ground sprites
ground = {}

-- table to hold sky sprites
sky = {}

-- Function to generate frames
function generate_frames(start, count)
    local frames = {}
    for i = 0, count do
        add(frames, start + i)
    end
    return frames
end

-- all tables spawn by index and must be in the same order to maintain theme consistency
-- table of sprite numbers for the run animation
character_table = {
    { name = "little_guy", frames = { 16, 18, 20, 22 } },
    { name = "knight", frames = { 24, 26, 28, 30 } },
    { name = "orange", frames = { 48, 50, 52, 54 } },
    { name = "ghost", frames = { 56, 58, 60, 62 } },
    { name = "spaceship", frames = { 88, 90, 92, 94 } }
}

-- all tables spawn by index and must be in the same order to maintain theme consistency
ground_start_frames = { 120, 152, 168, 136, 184 }
ground_names = { "grass", "ds_ground", "watermelon", "graveyard", "space" }
ground_table = {}
for i, start_frame in ipairs(ground_start_frames) do
    ground_table[i] = { name = ground_names[i], frames = generate_frames(start_frame, 7) }
end

-- all tables spawn by index and must be in the same order to maintain theme consistency
sky_table = {}
for i = 1, 12 do
    local start_frame = 96
    if i > 6 then
        start_frame = start_frame + (i - 6) * 16
    end
    sky_table[i] = { name = "sky", row = i, frames = generate_frames(start_frame, 7) }
end

-- Add names as keys
for i, v in ipairs(character_table) do
    character_table[v.name] = v.frames
end

ground_speed_control = 21
sky_arr = { 25, 33, 41, 49, 57, 65, 73, 81, 89, 97, 105, 113, 121, 129, 137, 145, 153, 161, 169, 177, 185, 193 }

function animation(sprite)
    local actual_speed = ground_speed_control - speed
    --use speed variable here instead of animation_speed

    if frame % actual_speed == 0 then
        current_frame = sprite[frame / actual_speed % #sprite + 1]
    end
    frame += 1
end

max_speed = 20