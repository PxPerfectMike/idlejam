pico-8 cartridge // http://www.pico-8.com
version 38
__lua__

#include longNum.lua
#include controls.lua
#include timers.lua
#include keyboardinput.lua

#include idlemath.lua
#include testlevels.lua

#include animation.lua

--[[
function _init()
    tl_init()
end

function _update()
    tl_update()
end

function _draw()
    tl_draw()
end
]]

max_speed = 20
#include main.lua

__gfx__
eeeeeeee111111112222222233333333444444445555555566666666777777778888888899999999aaaaaaaabbbbbbbbccccccccddddddddffffffffeeeeeeee
eeeeeeee111111112222222233333333444444445555555566666666777777778888888899999999aaaaaaaabbbbbbbbccccccccddddddddffffffffeeeeeeee
ee7ee7ee111111112222222233333333444444445555555566666666777777778888888899999999aaaaaaaabbbbbbbbccccccccddddddddffffffffeeeeeeee
eee77eee111111112222222233333333444444445555555566666666777777778888888899999999aaaaaaaabbbbbbbbccccccccddddddddffffffffeeeeeeee
eee77eee111111112222222233333333444444445555555566666666777777778888888899999999aaaaaaaabbbbbbbbccccccccddddddddffffffffeeeeeeee
ee7ee7ee111111112222222233333333444444445555555566666666777777778888888899999999aaaaaaaabbbbbbbbccccccccddddddddffffffffeeeeeeee
eeeeeeee111111112222222233333333444444445555555566666666777777778888888899999999aaaaaaaabbbbbbbbccccccccddddddddffffffffeeeeeeee
eeeeeeee111111112222222233333333444444445555555566666666777777778888888899999999aaaaaaaabbbbbbbbccccccccddddddddffffffffeeeeeeee
eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee0000000eeeeeeeee0000000eeeeeeeee0000000eeeeeeeee0000000eee
eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee0888880eeeeeeeee0888880eeeeeeeee0888880eeeeeeeee0888880eee
eeeee000000eeeeeeeeee000000eeeeeeeeee000000eeeeeeeeee000000eeeeeeeeee00008880eeeeeeee00008880eeeeeeee00008880eeeeeeee00008880eee
eeee08888880eeeeeeee08888880eeeeeeee08888880eeeeeeee08888880eeeeeeee065555550eeeeeee065555550eeeeeee065555550eeeeeee065555550eee
eee0888888880eeeeee0888888880eeeeee0888888880eeeeee0888888880eeeeee06666666660eeeee06666666660eeeee06666666660eeeee06666666660ee
eee088ff888f0eeeeee088ff888f0eeeeee088ff888f0eeeeee088ff888f0eeeeee06666666660eeeee06666666660eeeee06666666660eeeee06666666660ee
eee08fffffff0eeeeee08fffffff0eeeeee08fffffff0eeeeee08fffffff0eeeeee066655555550eeee066655555550eeee066655555550eeee066655555550e
ee0f8f00ff00eeeeee0f8f00ff00eeeeee0f8f00ff00eeeeee0f8f00ff00eeeeeee066651111110eeee066651111110eeee066651111110eeee066651111110e
ee0fff07ff07eeeeee0fff07ff07eeeeee0fff07ff07eeeeee0fff07ff07eeeeee0333655551550eee0333655551550eee0333655551550eee0333655551550e
eee0ffffffffeeeeeee0ffffffffeeeeeee0ffffffffeeeeeee0ffffffffeeeeee0333655551550eee0333655551550eee0333655551550eee0333655551550e
eeee0fff00ffeeeeeeee0fff00ffeeeeeeee0fff00ffeeeeeeee0fff00ffeeeeeee07777778770eeeee07777787770eeeee07777787870eeeee07777878770ee
eeee099fff90eeeeeeee099fff90eeeeeeee099fff90eeeeeee0099fff900eeeeee04044899440eeeee04044499840eeeee04044499440eeeee04044499440ee
eee0f9999990eeeeeeee0ff99990eeeeeee0f9999990eeeeee0ff999999ff0eeeee07777799870eeeee07777899770eeeee07777899870eeeee07777899870ee
ee0ff59999ff0eeeeeee0ff999f0eeeeee0ff59999ff0eeeee0ff599990ff0eeeee07777787770eeeee07777778770eeeee07777787770eeeee07777787770ee
ee0ff0c1110f0eeeeeee0cc111f0eeeeee0ff0c1110f0eeeeee000cc11000eeeeee0550000550eeeeee05500000550eeeeee0550000550eeeee0550000550eee
eee000c00100eeeeeeee0c000010eeeeeee000c00100eeeeeeeeee0c10eeeeeeeee0550ee0550eeeeee0550eee0550eeeeee0550ee0550eeeee0550ee0550eee
eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee0000000eeeeeeeeeeeeeeeeeeeeeeeeee0000000eeeeeeeeeeeeeeeeeeee
eeeeee33eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee33eeeeeeeeeeee067777760eeeeeeeee0000000eeeeeeee067777760eeeeeeee0000000eeee
eeeeee333eeeeeeeeeeee333eeeeeeeeeeeee33eeeeeeeeeeeeee333eeeeeeeeee06777777760eeeeeee067777760eeeeee06777777760eeeeee067777760eee
eeeeee03300eeeeeeeeee3333eeeeeeeeeeee333eeeeeeeeeeeeee333eeeeeeeee07777777770eeeeee06777777760eeeee07777777770eeeee06777777760ee
eeeee0993990eeeeeeeeee33300eeeeeeeeee3333eeeeeeeeeeeee03300eeeeeee07770777070eeeeee07777777770eeeee07770777070eeeee07777777770ee
eeee099999990eeeeeeee0993990eeeeeeeeee03300eeeeeeeeee0993990eeeeee07770777070eeeeee07770777070eeeee07770777070eeeee07770777070ee
eee09999999990eeeeee099999990eeeeeeee0993990eeeeeeee099999990eeeee07777777770eeeeee07770777070eeeee07777777770eeeee07770777070ee
eee09999999990eeeee09999999990eeeeee099999990eeeeee09999999990eeeee077777770eeeeeee07777777770eeeeee077777770eeeeee07777777770ee
ee0990799990790eeee09999999990eeeee09999999990eeeee09999999990eeeeee0677760eeeeeeeee077777770eeeeeeee0677760eeeeeeee077777770eee
ee0990090090090eee0990799990790eeee09999999990eeee0990799990790eeeee0777770eeeeeeeeee0677760eeeeeeeee0777770eeeeeeeee0677760eeee
ee0988999999880eee0990090090090eee0990799990790eee0990099990090eeeee0777770eeeeeeeeee0777770eeeeeeeee0777770eeeeeeeee0777770eeee
eee09999999990eeee0988999999880eee0990090090090eee0988990099880eeeee0777770eeeeeeeeee0777770eeeeeeeeee07760eeeeeeeeee0777770eeee
eee09999999990eeeee09999999990eeee0988999999880eeee09999999990eeeeeee07760eeeeeeeeeeee07600eeeeeeeeeeee060eeeeeeeeeee0777770eeee
eeee099999990eeeeee09999999990eeeee09999999990eeeee09999999990eeeeeeee060eeeeeeeeeeeee060eeeeeeeeeeeeeee0eeeeeeeeeeeee07760eeeee
eeeee0999990eeeeeeee099999990eeeeee00999999900eeeeee099999990eeeeeeeeee0eeeeeeeeeeeeee00eeeeeeeeeeeeeeeeeeeeeeeeeeeeeee060eeeeee
eeeeee00000eeeeeeeeee0000000eeeeeeee000000000eeeeeeee0000000eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee0eeeeeee
eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee0000eeeeeeeeeeeeeeeeeeeeeeeeeeee0000eeeeeeeeeeeeeeeeeeeee
e000000ee000000ee000000ee000000ee000000ee000000ee000000ee000000eeeeee00cccc00eeeeeeeeee0000eeeeeeeeee00cccc00eeeeeeeeee0000eeeee
e0cccc0ee022220ee0bbbb0ee088880ee0aaaa0ee077770ee011110ee099990eeeee0cccccccc0eeeeeee00cccc00eeeeeee0cccccccc0eeeeeee00cccc00eee
e0c0c00ee020200ee0b0b00ee080800ee0a0a00ee070700ee010100ee090900eeee0ccccccc7cc0eeeee0cccccccc0eeeee0ccccccc7cc0eeeee0cccccccc0ee
e0cccc0ee022220ee0bbbb0ee088880ee0aaaa0ee077770ee011110ee099990eeee0cccccc7ccc0eeee0ccccccc7cc0eeee0cccccc7ccc0eeee0ccccccc7cc0e
e0c0000ee020000ee0b0000ee080000ee0a0000ee070000ee010000ee090000eeee0cccccccccc0eeee0cccccc7ccc0eeee0cccccccccc0eeee0cccccc7ccc0e
e0cccc0ee022220ee0bbbb0ee088880ee0aaaa0ee077770ee011110ee099990eeee0cccccccccc0eeee0cccccccccc0eeee0cccccccccc0eeee0cccccccccc0e
e000000ee000000ee000000ee000000ee000000ee000000ee000000ee000000eee0b0ccccccccc0eeee0cccccccccc0eee0b0ccccccccc0eeee0cccccccccc0e
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccce060c1000000cc0eee030ccccccccc0ee060c1000000cc0eee030ccccccccc0e
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccce060000666d00000e060c1000000cc0ee060000666d00000e060c1000000cc0e
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccce0666666666666d0e060000666d00000e0666666666666d0e060000666d00000
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccee06666555a66d0ee0666666666666d0ee066665a5566d0ee0666666666666d0
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccceee006666666d0eeee0666655a566d0eeee006666666d0eeee06666a55566d0e
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccceeeee00000000eeeeee006666666d0eeeeeee00000000eeeeee006666666d0ee
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccceeeeeeeeeeeeeeeeeeeee00000000eeeeeeeeeeeeeeeeeeeeeeee00000000eee
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccceeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccbbbbb33b33bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc33bbb4434433333bbbbbbb333bbbbbbbbbbbbb33bb3bbb3bbbbbbbbbbbbbbbb3
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc43bb34c44444444333333344433bbbbbb33bbb44334333443bbb333bb3333334
cccccccccccccccccccccccccccccccccccccccccccccc6ccccccccccccccccc443b34442442444444444424444333bbb44bb34444444444bbb3444b34c4444c
ccccccccccccccccccccccccccc6ccc6cccccccccccc666ccccc6cccccc66ccc944344444444444944c44444444444bbb443344449442444b334424b44449444
c66ccccccccccccccccc66ccc6c6c6c66c6ccc6ccc6ccc6c6cccc6c6ccc6cccc444444944444c444444944449444c4333424444c444444443444444349444424
6c666cc6cc666cc6c66666c6c6c66c666c666cc666cc6cc66666666c666cc6cc424c444444444444444444444444444444444444444449444449444444444444
c666c66666c666666ccc66666666666c6666666666c666666c666666c66666660000000000000000000000000000000000000000000000000000000000000000
66666c666666666c666666666c666666666c666666c66666c66666666c6666c65555555555555555555555555555555555555555555555555555555555555555
6666666666666666666c666666666666666666666666666666666666666666665555655555555666555556555555565555566555555555566555555655555565
6666666666666666666666666666666666666666666666666666d666666666665556865665556888655558655665686555688556655655688556656865555685
666666666666666d6666666666666666d66666666666666666dd6666666666666568886006568880066568866006888666888668866065880668868805666886
66d6666666dd6d66666d6d6666666666666ddd6666666666666dd66dd66666dd0600080000608800000608000000808800888008800006080088808806000800
6d666666d66d666d6dd666dd66d66666d6d66dd6666d66dd66dd66666d6d6ddd0000080000000800000000000000000800080008000000000000808008000800
d66666666dd66d6dd6ddd6ddd66666666d6d6dd6ddd66666d666666d6ddddddd0000000000000000000000000000000000000000000000000000000000000000
66666d66dd66d6d6dd66d6dd6d6dd66d6dddd6ddd6666dd66d666ddddd6dd6dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
d6d6666dd6d6dddd6dd6ddddd6dddd6dd6ddddddddd6ddddd6d6ddd666dddddd6dddd66ddd666ddddddd66ddddd6666ddddd66dddd66dddddd6ddd6dddd66d6d
dddd6dd6dddd6ddddddddddddddddddddddddddddddddddddddddddddddddddd566dd556664556ddddd64566dd6555566dd65566dd556dd6dd56dd56dd6d5656
dd6ddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd555665554555556666655555665545555d655d5566555665d6556655665655d5
dddddddddddddddddddddd5ddddddddddddddddddddddddddddddddddddddddd55d555555d55555555555d55555555555655565554d55555d555555455555565
dddddddddddddddddddddd5ddddddddd5ddd55dd5dddddd5ddddddd5dddddddd556554555d5555555545565555dd55555555555455655555654555555d554555
5555dddddddd55ddddddddd5dddddddddd5ddddd5ddddd55d5dddd5dd5dddd55455555555655455d555555555556545545555d55555545555555554556555545
dd5d5ddd55ddd55d5d5dd5dd5d55dddddddd5d5dddddddddddddddddd55dd5d555d5555455555556555555545555555555555655555555545555555555555555
d5d55dd55d55555d55555dd5d555d5dd5555555dd555d5dd5dddd55dd555d5d53333333333333333333333333333333333333333333333333333333333333333
5555555ddd55555555555dd5d555555d5555555d5555dd55d555d555555d5dd53333333333333333333333333333333333333333333333333333333333333333
5555555555555555555555555555d555555555555555555555555555555555d58888888888888888888888888888888888888888888888888888888888888888
55555555555555555555555555555555555555555555555555555555555555558088888888088888888888888808888880888888888088888088808888088880
55525555555555555555555555555555555555555555555555555555555555528888880888888880888880888888888888888880888888888880888888888088
55552255255555525555552552555252555225555525555225255555225552258808888888888888888888888880888808880888888888088888888808888888
52255552555552525255252525255555555555255252555552225525525555558880888808808888880888808888808888888888888088888808880888880808
25555252555255252225555525552555225552555555255555555555555525558888888888888888888888888888888888888888888888888888888888888888
22522222222525222522552255225225222222225222252555255255555225520000000000000000000000000000000000000000000000000000000000000000
22222252225222225522222222222225222522222522222252222225522222220070000000070000000000000000000000000000000000000000000000000000
22222222222222222222222222222222222222222222222222222222222222220000000000000000000000a00000000000000000070000000000000000000700
22222222222222222222222222222222222222222222222222222222222222220000000000000000000000000000000000000000000000000000000000000000
2222222222222222222222222222222222222222222222222212122222222222000000000000000000000000000000000c000000000000000000007000000000
22222212212221222222222222222222222222122222222222222112222222220000000000000000000000000007000000000000000008000000000000000000
2221221222222111212211212222221221221112222212121122222221222122000007000000000000000000000000000000000000000000000000000a000000
12222222211222212221112212212222121221222112122122222112222222120000000000000000000000000000000000000000000000000000000000000000
1121212222121211121211111111222111221211121121122211122121222121eeee0e0e0e0eeeeeeeeeeeeeeeeeeeeee000000000000eeee000000000000eee
1122111111121121111111111112111121111221111111111211111112221111eeee0e0e0e0eeeeeeeee0e0e0e0eeeee03333333333330ee07bbbbbbbbbbb0ee
1111111111111111121111112111211112211121111111112111111111212111eee0000000000eeeeeee0e0e0e0eeeee033333333333330e0bbbbbbbbbbbbb0e
1111111111111111111111121111111111111111111111111111111121111111ee066666666650eeeee0000000000eee03000300030003700baaabaaabaaabb0
11111111111111111111111111111111211111111111111111111111111111110006660066665000ee066666666650ee03000303030033300baaabababaabbb0
1111111111111111111111111111111111111111111111111111111111111111ee066600666650ee000666666666500003303300030003300bbabbaaabaaabb0
11111111111111111111111111111111111111111111111111111111111111110006000000665000ee066660066650ee03303300033003300bbabbaaabbaabb0
1111111111111111111111111111111111111111111111111111111111111111ee060000006650ee000666600666500003303303030003300bbabbababaaabb0
eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee0006dd00dd665000ee066000000650ee03333333333333300bbbbbbbbbbbbbb0
eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee066600666650ee000660000006500003000000000003300b00000000000bb0
eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee000666dd66665000ee066660066650ee0307bbbbbbbb03300b09999999970bb0
eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee066666666650ee0006666006665000030bbbb0bbbb03300b09999099990bb0
eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee0ddddddddd60eeee066666666650ee030bbb000bbb03300b09990009990bb0
eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee00000000006eeee0ddddddddd60ee030bbbb0bbbb03300b09999099990bb0
eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee6060606066eeeeee0000000000eee070bbbbbbbb703300b07999999990b70
eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee0e0e0e0eeeeeeeee0e0e0e0eeeeee000000000000000e000000000000000
eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee777eeeeee7ee
eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee66666666666666666666666e66666666666666666666666eeee7e7e7ee777e7e
eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee60000000000000000000066e60000000000000000000006eee7ee77eee7e7e77
eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee60006600006660000660006e66006660006660000660606eeee7777777777777
eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee66666666666666666666666e666666666666666666666667e7777e777777777e
eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee60000000000000000000006e60000000000000000000006e7ee77e7e7e7ee77e
eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee66006000000600006060066e66006066000600666066066e777e777e7ee7e77e
eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee66666666666666666666666e66666666666666666666666eee77eee77eee7eee
eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee7e7e77777e777ee
eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee77e77ee7e7e77
eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee7ee777ee77e7e77e
eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeebeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeebeee3eee7ee777777ee77ee
eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeebeeee3ebeeee33ebeeeeebeee3eeeeeeeeeeeebebeee3eeee77eeeee7777e77
eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeebe3bb33ebbb3eeeb3bb3eebbb3e3e33333e3eeeebee3eb3ee777777e7eee7eee
eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeb3eebbb3ebeee333b3b33ebe3bebb3bbb3bb3eeb3e333beeee7ee77e7e7e7e77
eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeebebb33b33bee333b33bee3eb3e333beb3333bb3bb3b3b33eee77e77eeeeeeeee
