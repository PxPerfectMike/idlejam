function _init()
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