local sense = require "sensehat"
local socket = require "socket"
local random = math.random

math.randomseed(os.time())
while true do
   x = random(1,8)
   y = random(1,8)
   r = random(0,255)
   g = random(0,255)
   b = random(0,255)
   sense.setPixel(x,y,{r,g,b})
   socket.sleep(0.01)
end
