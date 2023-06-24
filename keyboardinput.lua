-- while local, _keyboard_input variables are all globaly accessable
local _keyboard_input = {
    active = false,
    text = '',
    input_len = 0,
    x = 0,
    y = 0,
    bgc = false,
    int_only = false,
    memory = ''
}

--[[
=============================================================================
    Function to initalize keyboard input.
    Must be called each time you want to make a new text input box.

    input_len:
        The maximum length input allowed.
    x:
        The x position to print the input.
    y:
        The y position to print the input.
    int_only:
        Whether the input is all characters or just numbers.
    bgc:
        The background color for the input text.
=============================================================================]]
function _keyboard_input:start(input_len, x, y, int_only, bgc)
    self.active = true
    self.input_len = input_len
    self.x = x
    self.y = y

    -- if int_only is a number then it's it's actually the back ground color
    if int_only and type(int_only) == 'boolean' then
        self.int_only = int_only
    else
        bgc = int_only
        self.int_only = false
    end

    -- taking care of the background color
    if type(bgc) == 'nil' then
        self.text = ''
        self.bgc = false
    elseif type(bgc) == 'number' and bgc >= 0 and bgc <= 15 then
        local tohex = { '1', '2', '3', '4', '5', '6', '7', '8', '9', 'a', 'b', 'c', 'd', 'e', 'f' }
        self.text = '\#' .. tohex[bgc] -- need to convert to hex
        self.bgc = true
    end
end

--[[
=============================================================================
    stops the keyboard input from running
=============================================================================]]
function _keyboard_input:stop()
    self.active = false
end

--[[
=============================================================================
    Actively records the keyboard input and prints it out based off of the
    information given in _keyboard_input:start().

    record_val:
        What will prompt recording the value.
        Accepts number for an ascii code or boolean value.
    text_color:
        What color to print the text in.

    return:
        Wether or not the input was recorded to memory.
=============================================================================]]
function _keyboard_input:record(record_val, text_color)
    local record = false

    if self.active then
        local last_key = stat(31)
        if #last_key > 0 then
            local ascii_val = ord(last_key)
            -- taking care of which set of inputs it accetable
            -- 32 - 126: printable characters
            -- 48 - 57: number characters
            local char_type = false
            if self.int_only then
                char_type = between(ascii_val, 48, 57)
            else
                char_type = between(ascii_val, 32, 126)
            end

            -- recording what is being typed on the keyboard
            if char_type and #self.text < self.input_len + (self.bgc and 2 or 0) then
                self.text = self.text .. last_key
            end
            -- deal with back space deleting characters
            if ascii_val == 8 and #self.text > (self.bgc and 2 or 0) then
                self.text = sub(self.text, 1, #self.text - 1)
            end
            -- record the input to memory once the record key is pressed
            if type(record_val) == 'boolean' then
                record = record_val
            elseif type(record_val) == 'number' then
                record = ascii_val == record_val
            end

            if record then
                self.memory = sub(self.text, self.bgc and 3 or 1, #self.text)
                while sub(self.memory, #self.memory) == ' ' do
                    self.memory = sub(self.memory, 1, #self.memory - 1)
                end
            end
        end
        -- print the text
        print(self.text, self.x, self.y, text_color or 7)
    end

    return record
end

--[[
=============================================================================
-- get the value of what is stored in memory
=============================================================================]]
function _keyboard_input:get_val()
    return self.memory
end

--[[
=============================================================================
-- helper function for finding if a val is between max and min
=============================================================================]]
function between(val, min, max)
    return val >= min and val <= max
end

--[[
=============================================================================
    helper function that checkes if the key associated with the
    ascii code was pressed
=============================================================================]]
function ascii_key_pressed(ascii_num)
    local last_key = stat(31)
    if #last_key > 0 then
        local ascii_val = ord(last_key)
        return ascii_val == ascii_num
    end
end

--[[
=============================================================================
    demo
=============================================================================]]

local record_btn_pressed = false
local inquary_num = 0
local blink_timer = 0
local txt_visable = true

local name
local age
local favorite_food

local name_txt = 'what is your name: '
local age_txt = 'what is your age: '
local ff_txt = 'what is your favorite food: '

-- put in _init()
function start__keyboard_input_demo()
    record_btn_pressed = false
    inquary_num = 0
    blink_timer = 0
    txt_visable = true

    _keyboard_input:start(12, 4 * 19, 6 * 1, 1)
end

-- put as the last thing in _update()
function run__keyboard_input_demo()
    cls(2)
    print('return with the [tab] button:', 0, 6 * 0, 7)

    print(name_txt, 0, 6 * 1, 7)
    print(age_txt, 0, 6 * 2, 7)
    print(ff_txt, 0, 6 * 3, 7)

    -- _keyboard_input.active is globally accessable
    if _keyboard_input.active then
        if txt_visable then
            print('[recording...]', 0, 6 * 5, 7)
        else
            print('[            ]', 0, 6 * 5, 7)
        end
    else
        print('[****done****]', 0, 6 * 5, 7)
    end

    blink_timer += 1

    local fps = 30
    local sec = 1

    if blink_timer >= fps * sec then
        txt_visable = not txt_visable
        blink_timer = 0
    end

    -- 9 is the ascii code for the tab button
    local recorded_val = _keyboard_input:record(9)

    if recorded_val and not record_btn_pressed then
        if inquary_num == 0 then
            -- name
            name = _keyboard_input:get_val()
            name_txt = name_txt .. name
            _keyboard_input:start(3, 4 * 18, 6 * 2, true, 1)
        elseif inquary_num == 1 then
            -- age
            age = tonum(_keyboard_input:get_val()) or 0
            age_txt = age_txt .. _keyboard_input:get_val()
            _keyboard_input:start(20, 0, 6 * 4, 1)
        elseif inquary_num == 2 then
            -- favorite food
            favorite_food = _keyboard_input:get_val()
            ff_txt = ff_txt .. "\n" .. favorite_food
            _keyboard_input:stop()
        end
        inquary_num += 1
        record_btn_pressed = true
    end
    if not recorded_val and record_btn_pressed then
        record_btn_pressed = false
    end
end