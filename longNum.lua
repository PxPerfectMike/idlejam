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

-- see which number is further from zero
function furthest_from_zero(ln1, ln2)
    -- long number one's pre-deciaml value places
    local ln1_pre = pre_decimal_value_places(ln1)
    -- long number two's pre-deciaml value places
    local ln2_pre = pre_decimal_value_places(ln2)

    -- long number one's pos-deciaml value places
    local ln1_post = post_decimal_value_places(ln1)
    -- long number two's pos-deciaml value places
    local ln2_post = post_decimal_value_places(ln2)

    -- if the two nums don't have the same number of greater than ones value place
    if ln1_pre != ln2_pre then
        return ln1_pre > ln2_pre and 1 or 2
    else
        -- if the nums have the same number of greater than ones value place
        local i = 1
        -- compare all shared value places and see which one is greater
        while i <= #ln1.values and i <= #ln2.values do
            if ln1.values[i] != ln2.values[i] then
                return ln1.values[i] > ln2.values[i] and 1 or 2
            end
            i += 1
        end
        -- if neither is greater

        -- if one number has more value places less than ones
        if ln1_post != ln2_post then
            return ln1_post > ln2_post and 1 or 2
        else
            return 0
        end
    end
end

-- adding together two long numbers
function add_long_nums(ln1, ln2)
    -- long number one's pre-deciaml value places
    local ln1_pre = pre_decimal_value_places(ln1)
    -- long number two's pre-deciaml value places
    local ln2_pre = pre_decimal_value_places(ln2)

    local greater_num = furthest_from_zero(ln1, ln2)

    -- if the two nums don't have the same positivity
    if ln1.pos != ln2.pos then
        if greater_num == 0 then
            return {
                values = { 0 },
                decimal = 0,
                pos = true
            }
        end
    end

    -- the greater one will subtract the lesser one if it's subtraction
    local greater = greater_num == 1 and ln1 or ln2
    local lesser = greater_num == 1 and ln2 or ln1

    -- all the value places that need to be traversed
    local max_val_place = max(ln1_pre, ln2_pre)
            + max(post_decimal_value_places(ln1), post_decimal_value_places(ln2))

    -- the difference between the start of ln1 and ln2
    local pre_diff = max(ln1_pre - ln2_pre, ln2_pre - ln1_pre)

    -- the result string
    local result = ''

    -- for carrying over values
    local carry = 0

    -- do the addition calculation
    for i = 1, max_val_place do
        local val_place = max_val_place - i + 1

        -- add the value places together
        local sum = (greater.values[val_place] or 0)
                + (lesser.values[val_place - pre_diff] or 0)
                * (ln1.pos == ln2.pos and 1 or -1) + carry

        result = sum % 10 .. result
        carry = flr(sum / 10)

        if (greater.decimal != 0 and greater.decimal or #greater.values + 1) == val_place then
            result = '.' .. result
        end
    end

    if not greater.pos then result = '-' .. result end

    return make_long_num(result)
end

function round_up() end