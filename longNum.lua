--=======================================================================
-- healper functinos
--=======================================================================

-- checks if a character is a number
function is_num(char)
    local nums = { '0', '1', '2', '3', '4', '5', '6', '7', '8', '9' }
    for i = 1, #nums do
        if (char == nums[i]) return true
    end
    return false
end

function long_num_to_string(num)
    local str = ''
    if not num.pos then
        str = '-'
    end

    for i = 1, #num.values do
        if i == num.decimal then
            str = str .. '.'
        end
        str = str .. num.values[i]
    end

    return str
end

-- how many value places come before the decimal
function pre_decimal_value_places(num)
    return num.decimal != 0 and num.decimal - 1 or #num.values
end

-- how many value places come after the decimal
function post_decimal_value_places(num)
    return num.decimal != 0 and #num.values - num.decimal + 1 or 0
end

-- does the number have value places under the ones value place
function is_int(num)
    return num.decimal == 0
end

-- see which number is further from zero
function furthest_from_zero(ln1, ln2)
    -- long number one's pre-decimal value places
    local ln1_pre = pre_decimal_value_places(ln1)
    -- long number two's pre-decimal value places
    local ln2_pre = pre_decimal_value_places(ln2)

    -- long number one's pos-decimal value places
    local ln1_post = post_decimal_value_places(ln1)
    -- long number two's pos-decimal value places
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

-- error check long number
function check_long_num(num)
    -- check variable
    assert(type(num) != 'nil', "invalid input: inputed long\nnumber dosen't exist")
    assert(type(num) == 'table', "invalid input: inputed long\nnumber is not a table")
    -- check values
    assert(type(num.values) != 'nil', "missing variable:\ninputed long number is missing a values\nvariable")
    assert(type(num.values) == 'table', "incorrect variable:\ninputed long number's values\nvariable is not a table")
    -- check decimal
    assert(type(num.decimal) != 'nil', "missing variable:\ninputed long number is missing\na decimal variable")
    assert(type(num.decimal) == 'number', "incorrect variable:\ninputed long number's decimal\nvariable is not a number")
    -- check pos
    assert(type(num.pos) != 'nil', "missing variable: inputed long\nnumber is missing a pos variable")
    assert(type(num.pos) == 'boolean', "incorrect variable:\ninputed long number's pos\nvariable is not a boolean")
end

--=======================================================================
-- constructor function
--=======================================================================

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
    -- p true means it's positive, p false means it's negative
    local p = true

    -- meant for eliminating redudent zeros on either side
    local redundent_zeros = true
    local leading_zero = false
    local zero_count = 0
    local decimal_buff = 0

    if sub(str, 1, 1) == "-" then p = false end
    -- read all the numbers
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
        return {
            values = { 0 },
            decimal = 0,
            pos = true
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

-- math functions

-- adding together two long numbers
function add_long_nums(ln1, ln2)
    -- long number one's pre-decimal value places
    local ln1_pre = pre_decimal_value_places(ln1)
    -- long number two's pre-decimal value places
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
    for i = max_val_place, 1, -1 do
        -- add the value places together
        local sum = (greater.values[i] or 0)
                + (lesser.values[i - pre_diff] or 0)
                * (ln1.pos == ln2.pos and 1 or -1) + carry

        -- record the value
        result = sum % 10 .. result
        -- find the carry over
        carry = flr(sum / 10)

        -- set the decimal place
        if (greater.decimal != 0 and greater.decimal or #greater.values + 1) == i then
            result = '.' .. result
        end
    end

    if not greater.pos then result = '-' .. result end

    return make_long_num(result)
end

function multiply_long_nums(num1, num2)
    -- for optimization table access overhead
    local num1_vals = num1.values
    local num2_vals = num2.values

    local v = {}
    for _ = 1, #num1_vals + #num2_vals, 1 do
        add(v, 0)
    end

    -- do the multiplication calculation
    for i = #num2_vals, 1, -1 do
        for j = #num1_vals, 1, -1 do
            local value_place = #num1_vals - j + #num2_vals - i + 1
            local product = num2_vals[i] * num1_vals[j] + v[value_place]
            v[value_place] = product % 10
            v[value_place + 1] = v[value_place + 1] + flr(product / 10)
        end
    end

    for i = 2, #v, 1 do
        if v[i] > 9 then
            local carry = flr(v[i] / 10)
            v[i] = v[i] % 10
            v[i + 1] = v[i + 1] + carry
        end
    end

    for i = 1, flr(#v / 2) do
        local backend = #v - i + 1
        local temp = v[backend]
        v[backend] = v[i]
        v[i] = temp
    end

    local total_post_dist = post_decimal_value_places(num1) + post_decimal_value_places(num2)
    local d = total_post_dist == 0 and 0 or #v - total_post_dist + 1

    return {
        values = v,
        decimal = d,
        pos = num1.pos == num2.pos
    }
end

-- at give value_place, round the number num up
function round_up_long_num(num, value_place)
    local index = num.decimal - value_place + 1
    if num.values[index] and num.values[index] >= 5 then
        local i = index - 1
        while i >= 1 and num.values[i] == 9 do
            num.values[i] = 0
            i = i - 1
        end
        if i < 1 then
            -- need to add an additional place
            add(num.values, 1)
            num.decimal = num.decimal + 1
        else
            num.values[i] = num.values[i] + 1
        end
    end
    -- remove all places below the rounding place
    for i = index, #num.values do
        --[[
        if then
        else
        num.values[i] = nil
        end
        ]]
    end
    return num
end

--=======================================================================
-- math to find cost and production
--=======================================================================

--[[
    each generator needs
    - initial cost
    - cost coefficient (aka cost growth)
    - inital Time/rate
    - base production (rate)
]]

-- credit for the equations goes to Anthony Percorella, "The Math of Idle Games, Part 1", Kongregate Developers Blog
--[[
    find how much the next upgrade cost
    b = the base price
    r = the price growth rate exponent
]]
function cost_next(b, r)
    return b * r
end

--[[
      find how much the next upgrade cost
      b = the base price
      r = the price growth rate exponent
      k = the number of generators currently owned
  ]]
function cost_next(b, r, k)
    return b * pow(r, k)
end

--[[
      takes a float and rounds it to format it like money
  ]]
function float_to_money(x)
    --x * 1000 % 10
end

-- find how much each generator makes per unit of measurement
function total_production(_production_base, _owned, _multipliers)
    return _production_base * _owned * _multipliers
end

--[[
      find how much it costs to buy in bulk ammount
      n = the number of generators to buy
      b = the base price
      r = the price growth rate exponent
      k = the number of generators currently owned
  ]]
function bulk_buy_cost(b, r, k, n)
    return b * pow(r, k) * (pow(r, n) - 1) / (r - 1)
end

--[[
      what is the maximum ammount of units you can buy
      b = the base price
      r = the price growth rate exponent
      k = the number of generators currently owned
      c = the amount of currency owned
  ]]
function max_buy_ammount(b, r, k, c)
    return flr(ln(c * (r - 1) / b * pow(r, k) + 1) / ln(r))
end