function run_tests()
    print("ln(1) = " .. ln(1))
    print("ln(e) = " .. ln(2.71828))
    -- should be close to 1
    print("ln(54) = " .. ln(54))

    --print("ln(54) = " .. newtonRaphsonLog(54))

    print("2^5 = " .. pow(2, 5))

    -- print("cost next: 4 x (1.07)^10 = " .. cost_next(4, 1.07, 10))
    -- print("production total:\n(1.67 x 10) x 1 = " .. total_production(1.67, 10, 1))

    -- local amount = max_buy_amount(4, 1.07, 1, 100)
    -- local cost = bulk_buy_cost(4, 1.07, 1, amount)
    -- print("maximum can by with 100 is " .. amount)
    -- print("which is equal to " .. cost)

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
    print("it has " .. #stress_test.values .. " value places")
end