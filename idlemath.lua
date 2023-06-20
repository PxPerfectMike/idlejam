FIXED_POINT_PRECISION = 0.00001

function create_fixed_point(n)
    assert(n >= -32768 and n <= 32768, "Number out of range")
    local int_part = flr(n)
    local frac_part = n - int_part
    -- apply banker's rounding
    frac_part = frac_part + 0.5 * FIXED_POINT_PRECISION * (2 * (flr(frac_part / FIXED_POINT_PRECISION) % 2) - 1)
    frac_part = frac_part - frac_part % FIXED_POINT_PRECISION
    -- check for overflow due to rounding
    if frac_part >= 1 then
        frac_part = frac_part - 1
        int_part = int_part + 1
    end
    return {int=int_part, frac=frac_part}
end

function add_fixed_point(n1, n2)
    local int_part = n1.int + n2.int
    local frac_part = n1.frac + n2.frac
    if frac_part >= 1 then
        frac_part = frac_part - 1
        int_part = int_part + 1
    end
    return create_fixed_point(int_part + frac_part)
end

function subtract_fixed_point(n1, n2)
    local int_part = n1.int - n2.int
    local frac_part = n1.frac - n2.frac
    if frac_part < 0 then
        frac_part = frac_part + 1
        int_part = int_part - 1
    end
    return create_fixed_point(int_part + frac_part)
end

function multiply_fixed_point(n1, n2)
    local result = (n1.int + n1.frac) * (n2.int + n2.frac)
    return create_fixed_point(result)
end

function divide_fixed_point(n1, n2)
    assert(n2.int ~= 0 or n2.frac ~= 0, "Division by zero")
    local result = (n1.int + n1.frac) / (n2.int + n2.frac)
    return create_fixed_point(result)
end

function equals_fixed_point(n1, n2)
    return n1.int == n2.int and n1.frac == n2.frac
end

function compare_fixed_point(n1, n2)
    if n1.int > n2.int or (n1.int == n2.int and n1.frac > n2.frac) then
        return 1
    elseif equals_fixed_point(n1, n2) then
        return 0
    else
        return -1
    end
end

function print_fixed_point(n)
    print(n.int .. "." .. flr(n.frac / FIXED_POINT_PRECISION))
end
