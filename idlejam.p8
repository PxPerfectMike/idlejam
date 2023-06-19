pico-8 cartridge // http://www.pico-8.com
version 38
__lua__

#include main.lua

function _init()
  print("ln(1) = " .. ln(1))
  print("ln(e) = " .. ln(2.71828))
  -- should be close to 1
  print("ln(7) = " .. ln(7))

  print("2^5 = " .. pow(2, 5))
end

--[[
  each generator needs
  - initial cost
  - cost coefficient (aka cost growth)
  - inital Time
  - base production
]]

function _update()
end

function _draw()
end
-->8 -- page 1 -- (page purpose here)

-->8 -- page 2 -- (math)
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

-- find how much each generator makes per unit of measurement
function production_total(_production_base, _owned, _multipliers)
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
-->8 -- page 3 -- (page purpose here)

__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
