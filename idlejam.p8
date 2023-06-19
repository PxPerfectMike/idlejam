pico-8 cartridge // http://www.pico-8.com
version 38
__lua__

function _init()
  for i = 1, 20 do
    if i < 5 or i > 15 then
      print(i, 7)
    end
  end
  print("end", 7)
end

function _update()
end

function _draw()
end
-->8 -- page 1 -- (page purpose here)

-->8 -- page 2 -- (math)
-- credit for the equations goes to Anthony Percorella, "The Math of Idle Games, Part 1", Kongregate Developers Blog
-- find how much the next upgrade cost
function cost_next(_current_cost, _growth_rate)
  return _current_cost * _growth_rate
end

function cost_next(_base_cost, _growth_rate, _owned)
  local final_cost = _base_cost
  for i = 1, _owned do
    final_cost *= _growth_rate
  end
  return final_cost
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
  local r_k = 1
  local r_n = 1

  for i = 1, k do
    r_k *= r
  end

  for i = 1, n do
    r_n *= r
  end

  return b * r_k * (r_n - 1) / (r - 1)
end

--[[
  what is the maximum ammount of units you can buy
  b = the base price
  r = the price growth rate exponent
  k = the number of generators currently owned
  c = the amount of currency owned
]]
function max_buy_ammount(b, r, k, c)
  --math.log()
  flr()
end
-->8 -- page 3 -- (page purpose here)

__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
