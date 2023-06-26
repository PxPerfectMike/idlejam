-- a metatable to be shared by all long numbers
local _long_num = {}

--=======================================================================
-- helper functions
--=======================================================================

-- checks if a character is a number
function is_num(char)
    local nums = { '0', '1', '2', '3', '4', '5', '6', '7', '8', '9' }
    for i = 1, #nums do
        if (char == nums[i]) return true
    end
    return false
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
function furthest_from_zero(num1, num2)
    -- long number one's pre-decimal value places
    local num1_pre = pre_decimal_value_places(num1)
    -- long number two's pre-decimal value places
    local num2_pre = pre_decimal_value_places(num2)

    -- long number one's pos-decimal value places
    local num1_post = post_decimal_value_places(num1)
    -- long number two's pos-decimal value places
    local num2_post = post_decimal_value_places(num2)

    -- if the two nums don't have the same number of greater than ones value place
    if num1_pre != num2_pre then
        return num1_pre > num2_pre and 1 or 2
    else
        -- if the nums have the same number of greater than ones value place
        local i = 1
        -- compare all shared value places and see which one is greater
        while i <= #num1.values and i <= #num2.values do
            if num1.values[i] != num2.values[i] then
                return num1.values[i] > num2.values[i] and 1 or 2
            end
            i += 1
        end
        -- if neither is greater

        -- if one number has more value places less than ones
        if num1_post != num2_post then
            return num1_post > num2_post and 1 or 2
        else
            return 0
        end
    end
end

-- error check long number
function check_long_num(num)
    -- check variable
    assert(type(num) == 'table', "inputed long number dosen't exist or is not a table")
    -- check values
    assert(type(num.values) != 'nil', "inputed long number is missing a values\nvariable")
    assert(type(num.values) == 'table', "inputed long number's values\nvariable is not a table")
    -- check decimal
    assert(type(num.decimal) != 'nil', "inputed long number is missing\na decimal variable")
    assert(type(num.decimal) == 'number', "inputed long number's decimal\nvariable is not a number")
    -- check pos
    assert(type(num.positive) != 'nil', "inputed long\nnumber is missing a positive variable")
    assert(type(num.positive) == 'boolean', "inputed long number's pos\nvariable is not a boolean")
end

--=======================================================================
-- constructor functions
--=======================================================================

-- given a string input make a struct that stores a number of any length
function long_num(num)
    -- check that variable string is a string

<<<<<<< HEAD
    if type(num) == 'number' then num = tostr(num) end

    local str = num or ''

=======
    -- make sure an empty string error dosen't occur
    if (str == '') str = '0'
>>>>>>> main
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

<<<<<<< HEAD
    -- make sure an empty string error dosen't occur
    if str == '' then
        v = { 0 }
        goto returnNum
    end

=======
>>>>>>> main
    if (sub(str, 1, 1) == "-") p = false
    -- read all the numbers
    for i = p and 1 or 2, #str do
        local char = sub(str, i, i)
        -- check for a negative sign in the middle of the number
        assert(char != '-', "invalid number input:\na negative sign in the middle\nof the number")

        -- deal with values place number
        if char == '.' then
            -- check for a second decimal
            if d != 0 then assert(char != '.', "invalid number input:\nmultiple decimal places") end
            d = i - decimal_buff
            if not p then d -= 1 end
            -- if the decimal place is the first character or comes right after the negative sign
            if #v == 0 then
                if redundent_zeros then
                    redundent_zeros = false
                    zero_count = 0
                    d = 2
                    leading_zero = true
                end
            else
                -- if the decimal place is not the first character
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
        v = { 0 }
        d = 0
        p = true
        goto returnNum
    end

    -- if never reached under the ones value place
    if d == 0 and #v != 0 then
        -- add the missing zeros to the list
        for i = 1, zero_count do
            add(v, 0)
        end
    end

    -- if the decimal place is at the end then there isn't a decimal place
    if (#v + 1 == d) d = 0
<<<<<<< HEAD
    -- returning the long number
    ::returnNum::
    local num = {
=======
    return {
>>>>>>> main
        values = v,
        decimal = d,
        positive = p
    }

    setmetatable(num, _long_num)
    return num
end

--=======================================================================
-- math functions
--=======================================================================

-- adding together two long numbers
function _long_num.__add(a, b)
    local num1 = a
    local num2 = b

    if type(num1) == 'number' then
        num1 = long_num(tostr(num1))
    elseif type(num2) == 'number' then
        num2 = long_num(tostr(num2))
    end

    -- long number one's pre-decimal value places
    local num1_pre = pre_decimal_value_places(num1)
    -- long number two's pre-decimal value places
    local num2_pre = pre_decimal_value_places(num2)

    local greater_num = furthest_from_zero(num1, num2)

    -- if the two nums don't have the same positivity
    if num1.positive != num2.positive then
        if greater_num == 0 then
            return {
                values = { 0 },
                decimal = 0,
                positive = true
            }
        end
    end

    -- the greater one will subtract the lesser one if it's subtraction
    local greater = greater_num == 1 and num1 or num2
    local lesser = greater_num == 1 and num2 or num1

    -- all the value places that need to be traversed
    local max_val_place = max(num1_pre, num2_pre)
            + max(post_decimal_value_places(num1), post_decimal_value_places(num2))

    -- the difference between the start of num1 and num2
    local pre_diff = max(num1_pre - num2_pre, num2_pre - num1_pre)

    -- the result string
    local result = ''

    -- for carrying over values
    local carry = 0

    -- do the addition calculation
    for i = max_val_place, 1, -1 do
        -- add the value places together
        local sum = (greater.values[i] or 0)
                + (lesser.values[i - pre_diff] or 0)
                * (num1.positive == num2.positive and 1 or -1) + carry

        -- record the value
        result = sum % 10 .. result

        -- find the carry over
        carry = flr(sum / 10)

        -- set the decimal place
        if (greater.decimal != 0 and greater.decimal or #greater.values + 1) == i then
            result = '.' .. result
        end
    end

    while carry > 0 do
        -- record the value
        result = carry % 10 .. result
        -- find the carry over
        carry = flr(carry / 10)
    end

    if not greater.positive then result = '-' .. result end

    return long_num(result)
end

function _long_num.__mul(a, b)
    local num1 = a
    local num2 = b

    if type(num1) == 'number' then
        num1 = long_num(tostr(num1))
    elseif type(num2) == 'number' then
        num2 = long_num(tostr(num2))
    end

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

    -- do the carry over math
    for i = 2, #v, 1 do
        if v[i] > 9 then
            local carry = flr(v[i] / 10)
            v[i] = v[i] % 10
            v[i + 1] = v[i + 1] + carry
        end
    end

    -- invert table
    for i = 1, flr(#v / 2) do
        local backend = #v - i + 1
        local temp = v[backend]
        v[backend] = v[i]
        v[i] = temp
    end

    -- account for no carry over at the front of the number
    if (v[1] == 0) deli(v, 1)
    -- calculate the decimal position
    local total_post_dist = post_decimal_value_places(num1) + post_decimal_value_places(num2)
    local d = total_post_dist == 0 and 0 or #v - total_post_dist + 1

    local result = {
        values = v,
        decimal = d,
        positive = num1.positive == num2.positive
    }

    -- set the meta table for long numbers to the result
    setmetatable(result, _long_num)

    return result
end

<<<<<<< HEAD
function _long_num.__pow(a, b)
    assert(type(b) == 'number', 'That is not supported at the current moment')

    assert(long_num(tostr(b)).decimal == 0, 'only whole number supported at the current moment')

    if (b == 0) return 1
    local result = a

    for i = 2, b do
        result = result * a
=======
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
>>>>>>> main
    end

    return result
end

-- floors a long num
function long_flr(num)
    -- check that num is a long num

    if num.decimal == 0 then
        return num
    end

    local v = {}

    for i = 1, num.decimal - 1 do
        add(v, num.values[i])
    end

    local result = {
        values = v,
        decimal = 0,
        positive = num.positive
    }

    -- set the meta table for long numbers to the result
    setmetatable(result, _long_num)

    return result
end

--=======================================================================
-- comparitor functions
--=======================================================================

-- a == b
function _long_num.__eq(a, b)
    local num1 = a
    local num2 = b

<<<<<<< HEAD
    if type(num1) == 'number' then
        num1 = long_num(tostr(num1))
    elseif type(num2) == 'number' then
        num2 = long_num(tostr(num2))
    end

    if (num1.positive != num2.positive) return false
    return furthest_from_zero(num1, num2) == 0
=======
-- credit for the equations goes to Anthony Percorella, "The Math of Idle Games, Part 1", Kongregate Developers Blog
--[[
    find how much the next upgrade cost
    b = the base price
    r = the price growth rate exponent
]]

function cost_next(b, r)
    return b * r
>>>>>>> main
end

-- a < b
function _long_num.__lt(a, b)
    local num1 = a
    local num2 = b

    if type(num1) == 'number' then
        num1 = long_num(tostr(num1))
    elseif type(num2) == 'number' then
        num2 = long_num(tostr(num2))
    end

    -- if one's negative and the others postitive
    -- if b is true meaning it's positive then a < b would be true as b would be positve and a, negative
    -- otherwise if b was false meaning it's negative then vice versa so the truth of this statment really just matches the positivity of num2
    if (num1.positive != num2.positive) return num2.positive
    -- which number has a further distance from zero
    local furthest = furthest_from_zero(num1, num2)

    -- if they are the same distance from 0
    if (furthest == 0) return false
    if num1.positive then
        -- if it's positive numbers then the lesser number would be the one closest to 0
        if furthest == 1 then
            -- this means a is further than b
            return false
        else
            -- this means b is further than a
            return true
        end
    else
        -- if it's negative numbers then the lesser number would be the one furthest to 0
        if furthest == 1 then
            -- this means a is further than b
            return true
        else
            -- this means b is further than a
            return false
        end
    end
end

--=======================================================================
-- string functions
--=======================================================================

function _long_num.__tostring(num)
    local str = ''
    if not num.positive then
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

function _long_num.__concat(a, b)
    return tostr(a) .. tostr(b)
end

<<<<<<< HEAD
-- writies out number in scientific form
function scientific(num)
    local str = ''

    str = str .. ''
=======
--[[
      find how much it costs to buy in bulk amount
      n = the number of generators to buy
      b = the base price
      r = the price growth rate exponent
      k = the number of generators currently owned
  ]]
function bulk_buy_cost(b, r, k, n)
    return b * pow(r, k) * (pow(r, n) - 1) / (r - 1)
end

--[[
      what is the maximum amount of units you can buy
      b = the base price
      r = the price growth rate exponent
      k = the number of generators currently owned
      c = the amount of currency owned
  ]]
function max_buy_amount(b, r, k, c)
    return flr(ln(c * (r - 1) / b * pow(r, k) + 1) / ln(r))
>>>>>>> main
end