-- checks if a character is a number
function is_num(char)
    local nums = { '0', '1', '2', '3', '4', '5', '6', '7', '8', '9' }
    for i = 1, #nums do
        if (char == nums[i]) return true
    end
    return false
end

-- given a string input make a struct that stores a number of any length
function make_long_num(string)
    local str = string or '0'

    -- make sure an empty string error dosen't occur
    if str == '' then
        str = '0'
    end

    -- all the values place values
    local v = {}
    -- where the decimal starts
    local d = 0
    -- pos true means it's positive, pos false means it's negative
    local p = true

    -- meant for eliminating redudent zeros on either side
    local redundent_zeros = true
    local leading_zero = false
    local zero_count = 0
    local decimal_buff = 0

    if (sub(str, 1, 1) == "-") p = false
    for i = p and 1 or 2, #str do
        local char = sub(str, i, i)
        -- check for a negative sign in the middle of the number
        assert(char != '-', "invalid number input:\na negative sign in the middle\nof the number")
        -- check for a second decimal
        if d != 0 then assert(char != '.', "invalid number input:\nmultiple decimal places") end

        -- deal with values place number
        if char == '.' then
            d = i - decimal_buff
            if not p then d -= 1 end
            if #v == 0 then
                if redundent_zeros then
                    redundent_zeros = false
                    zero_count = 0
                    d = 2
                    leading_zero = true
                end
            else
                if redundent_zeros then redundent_zeros = false end
                -- add that many zeros to the list
                for i = 1, zero_count do
                    add(v, 0)
                end
                zero_count = 0
            end
        else
            assert(is_num(char), 'invalid number input:\ninput contains a non-number character')
            -- track the consecutive number of zeros
            if char == '0' then
                zero_count += 1
            else
                -- if there needs to be a zero in the front for 0.0...n numbers
                if leading_zero then
                    add(v, 0)
                    leading_zero = false
                end
                -- upon reaching a non-zero number
                if zero_count != 0 then
                    -- if this is the first non-zero number
                    if redundent_zeros then
                        -- track of how many zeros and move the decimal place over by that much
                        decimal_buff = zero_count
                        zero_count = 0
                    else
                        -- add that many zeros to the list
                        for i = 1, zero_count do
                            add(v, 0)
                        end
                        zero_count = 0
                    end
                end

                redundent_zeros = false
                add(v, tonum(char))
            end
        end
    end

    -- if there's no values then set it to an empty 0
    if #v == 0 then
        add(v, 0)
        d = 0
        p = true

        return {
            values = v,
            decimal = d,
            pos = p
        }
    end

    -- if never reached under the ones value place
    if d == 0 and #v != 0 then
        -- add the missing zeros to the list
        for i = 1, zero_count do
            add(v, 0)
        end
    end

    -- if the decimal place is at the end then there isn't a decimal place
    if #v + 1 == d then d = 0 end

    return {
        values = v,
        decimal = d,
        pos = p
    }
end

function long_num_to_string(ln)
    local str = ''
    if not ln.pos then
        str = '-'
    end

    for i = 1, #ln.values do
        if i == ln.decimal then
            str = str .. '.'
        end
        str = str .. ln.values[i]
    end

    return str
end

-- how many value places come before the decimal
function pre_decimal_value_places(ln)
    return ln.decimal != 0 and ln.decimal - 1 or #ln.values
end

-- how many value places come after the decimal
function post_decimal_value_places(ln)
    return ln.decimal != 0 and #ln.values - ln.decimal + 1 or 0
end

-- does the number have value places under the ones value place
function is_int(ln)
    return ln.decimal == 0
end

-- adding together two long numbers
function add_long_nums(ln1, ln2)
    -- long number one's pre-deciaml value places
    local ln1_pre = pre_decimal_value_places(ln1)
    -- long number two's pre-deciaml value places
    local ln2_pre = pre_decimal_value_places(ln2)
    -- the longest pre-decimal value places
    local longest_pre = max(ln1_pre, ln2_pre)
    -- the difference between the start of ln1 and ln2
    local pre_diff = ln1_pre > ln2_pre and ln1_pre - ln2_pre or ln2_pre - ln1_pre
    -- which long number is less than the other
    local ln2_less_than = ln1_pre > ln2_pre

    -- long number one's pos-deciaml value places
    local ln1_post = post_decimal_value_places(ln1)
    -- long number two's pos-deciaml value places
    local ln2_post = post_decimal_value_places(ln2)
    -- the longest post-decimal value places
    local longest_post = ln1_post > ln2_post and ln1_post or ln2_post

    -- if the two nums don't have the same positivity
    --      if the two nums don't have the same number of greater than ones value place
    --          then the positivity is inherated from the number with the greater number of value places
    --      if the nums have the same number of greater than ones value place
    --          compare all value places greater than and equal to ones until a difference is found
    --              if a difference is found
    --                  then the positivity is inherated from the number with a higher value in this value place
    --              if a difference isn't found
    --                  compare all value places less than ones until a difference is found

    --p =

    for i = 1, longest_pre + longest_post do
        if ln2_less_than then
            if ln1.decimal == i then print(".") end
            local ln1_val = (ln1.values[i] or 0) * (ln1.pos and 1 or -1)
            local ln2_val = (ln2.values[i - pre_diff] or 0) * (ln2.pos and 1 or -1)

            print("" .. ln1_val .. " + " .. ln2_val .. " = " .. ln1_val + ln2_val)
        else
            if ln2.decimal == i then print(".") end
            local ln1_val = (ln1.values[i - pre_diff] or 0) * (ln1.pos and 1 or -1)
            local ln2_val = (ln2.values[i] or 0) * (ln2.pos and 1 or -1)
            print("" .. ln1_val .. " + " .. ln2_val .. " = " .. ln1_val + ln2_val)
        end
    end
end

--[[
function add_long_nums(num1, num2)
    local result = { values = {}, decimal = 0, pos = true }

    local max_len = max(#num1.values, #num2.values)
    local carry = 0

    for i = 0, max_len - 1 do
        local val1 = num1.values[#num1.values - i] or 0
        local val2 = num2.values[#num2.values - i] or 0

        local sum = val1 + val2 + carry
        carry = flr(sum / 10)
        result.values[1 + i] = sum % 10
    end

    if carry > 0 then
        add(result.values, carry)
    end

    result.decimal = max(num1.decimal, num2.decimal)
    result.pos = num1.pos == num2.pos or #result.values == 1 and result.values[1] == 0

    return result
end
]]