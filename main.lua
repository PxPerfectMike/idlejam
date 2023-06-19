function _init()
    print("ln(1) = "..ln(1))
    print("ln(e) = "..ln(2.71828)) -- should be close to 1
    print("ln(7) = "..ln(7))
end

function ln(x)
    local n = 1000  -- The larger this value, the more accurate the result.
    local a = (x - 1) / (x + 1)
    local sum = 0

    for i = 0, n do
    local term = 2 * a^(2*i + 1) / (2*i + 1)
    sum = sum + term
    end

    return sum
end
