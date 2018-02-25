local sense = require "sensehat"
local socket = require "socket"
local pretty = require "pl.pretty"
local X = {255, 0, 0}  -- Red
local O = {0, 0, 255}  -- White
local function printf(fmt, ...) print(string.format(fmt, ...)) end
local function step(x)
   printf("=================================================")
   printf("%q (hit <return> to continue ...)", x)
   io.read("*l")
end
local function sleep(t)
   socket.sleep(t)
end
question_mark = {
   O, O, O, X, X, O, O, O,
   O, O, X, O, O, X, O, O,
   O, O, O, O, O, X, O, O,
   O, O, O, O, X, O, O, O,
   O, O, O, X, O, O, O, O,
   O, O, O, X, O, O, O, O,
   O, O, O, O, O, O, O, O,
   O, O, O, X, O, O, O, O
}
ellipse = {
   O, O, O, X, X, O, O, O,
   O, O, X, O, O, X, O, O,
   O, O, X, O, O, X, O, O,
   O, O, X, O, O, X, O, O,
   O, O, X, O, O, X, O, O,
   O, O, X, O, O, X, O, O,
   O, O, X, O, O, X, O, O,
   O, O, O, X, X, O, O, O
}
step("set pixels")
sense.setPixels(question_mark)
local pixels = sense.getPixels()
printf("pixels: %s", pretty.write(pixels,"",false))

step("led on")
sense.ledOn()
socket.sleep(0.5)

step("checkerboard")
sense.setPixels(sense.pattern.checkerboard)

step("flip horizontal")
sense.flipV(true)

step("flip vertical")
sense.flipH(true)

step("rotate once")
sense.rotation(90, true)

step("rotate multiple times")
sense.setPixels(ellipse)
for i = 1, 10 do
   local rot = (i%4)*90
   sense.rotation(rot, true)
   sleep(0.1)
end

step("set single pixel")
for i = 1, 8 do
   for j = 1, 8 do
      r, g, b = 0, 255, 0 
      sense.setPixel(i,j,{r, g, b})
      sleep(0.05)
   end
end

step("clear")
sense.clear()

step("clear to blue")
sense.clear{0,0,255}

step("show letter")
for i=string.byte('a'), string.byte('z') do
   sense.showLetter(string.char(i), {255, 0, 0})
   sleep(0.1)
end

step("show message")
sense.showMessage("Guten Tag",
                  0.05, {255, 0, 0},{0, 0, 255})

step("load image")
local t = sense.loadImage("image001.png", true)
printf("immage: %s", pretty.write(t, "", false))

step("low light")
sense.clear{255,255,255}
sleep(1)
sense.lowLight()
sleep(1)
sense.lowLight(false)

step("gamma")
sense.clear{255,127,0}
local t = sense.getGamma()
printf("gamma 1: %s", pretty.write(t, "", false))
step("    gamma reversed")
local r = {}
for i = 1, 32 do 
   r[i] = t[33-i]
end
printf("gamma reversed in: %s", pretty.write(r, "", false))
sense.setGamma(r)
printf("gamma reversed out: %s", pretty.write(sense.getGamma(), "", false))

step("    low light")
sense.lowLight(true)
printf("gamma low light: %s", pretty.write(sense.getGamma(), "", false))
sleep(1)
sense.lowLight(false)
step("gamma reset")
sense.clear{255,127,0}
sleep(1)
local t = {}
for i = 1, 32 do
   t[i] = 0
end
sense.setGamma(t)
sleep(1)
sense.resetGamma()

step("done - led off")
sense.ledOff()
