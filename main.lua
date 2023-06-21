function _init()
    print("ln(1) = " .. ln(1))
    print("ln(e) = " .. ln(2.71828))
    -- should be close to 1
    print("ln(54) = " .. ln(54))

    --print("ln(54) = " .. newtonRaphsonLog(54))

    print("2^5 = " .. pow(2, 5))

    print("cost next: 4 x (1.07)^10 = " .. cost_next(4, 1.07, 10))
    print("production total:\n(1.67 x 10) x 1 = " .. total_production(1.67, 10, 1))

    local ammount = max_buy_ammount(4, 1.07, 1, 100)
    local cost = bulk_buy_cost(4, 1.07, 1, ammount)
    print("maximum can by with 100 is " .. ammount)
    print("which is equal to " .. cost)

    local float = 12345.6789

    print("float: " .. float)

    local double = make_long_num('12000599.01')
    local str = long_num_to_string(double)
    print(str)

    local double2 = make_long_num("-120599.00001")
    print(long_num_to_string(double2))

    --add_long_nums(double, double2)

    local double3 = make_long_num("-12059901.01")
    local double4 = make_long_num("-12059901.09")

    print('' .. long_num_to_string(double3) .. ' + ' .. long_num_to_string(double4) .. ' = ')

    print(long_num_to_string(add_long_nums(double3, double4)))

    print("start stress test")
    --add_long_nums(make_long_num("9999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999.9999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999"), make_long_num("9999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999.9999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999"))
    print("stress test done")

    local double5 = make_long_num("999.999")
    local double6 = make_long_num("999.999")

    print('' .. long_num_to_string(double5) .. ' x ' .. long_num_to_string(double6) .. ' = ')
    print(long_num_to_string(multiply_long_nums(double5, double6)))

    print("start stress test")
    local stress_test = multiply_long_nums(make_long_num("9999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999.9999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999"), make_long_num("9999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999.9999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999"))
    print("stress test done")

    print(long_num_to_string(stress_test))
end

function ln(x)
    local n = 1000
    -- The larger this value, the more accurate the result.
    local a = (x - 1) / (x + 1)
    local sum = 0

    for i = 0, n do
        local term = 2 * a ^ (2 * i + 1) / (2 * i + 1)
        sum = sum + term
    end

    return sum
end

function exp(x)
    --2.718281828459
    return pow(2.71828, x)
end

function newtonRaphsonLog(x)
    -- this determines the accuracy of the result
    local epsilon = 0.00001

    local guess = x

    while abs(exp(guess) - x) > epsilon do
        guess = guess - (exp(guess) - x) / exp(guess)
        print(guess, 0, 0, 7)
    end

    return guess
end

-- raises x to the power of n
function pow(x, n)
    local x_n = 1
    for i = 1, n do
        x_n *= x
    end
    return x_n
end