local py = require "python"
local pretty = require "pl.pretty"
local fmt, tinsert = string.format, table.insert

---
-- Translate Lua boolean values to python: true,false => True,False
---
local function pytype(n)
   if type(n) == "boolean" then
      if n == true then
         return "True"
      else
         return "False"
      end
   else
      return n
   end
end


_ENV = setmetatable({},{
      __index = _G
})

-- Python imports we need
py.execute(table.concat({
                 "from sense_hat import SenseHat, ACTION_PRESSED, ACTION_HELD, ACTION_RELEASED",
                 "from signal import pause",
                 "sense = SenseHat()"
                        }, "\n"))

---
-- Sensors
---
function temperature()
   return py.eval("sense.get_temperature()")
end	

function humidity()
   return py.eval("sense.get_humidity()")
end

function pressure()
   return py.eval("sense.get_pressure()")
end

function temperatureFromHumidity()
   return py.eval("sense.get_temperature_from_humidity()")
end	

function temperatureFromPressure()
   return py.eval("sense.get_temperature_from_pressure()")
end	

---
-- LED matrix
---
function rotation(angle, redraw)
   local redraw = redraw or true
   return py.eval(fmt("sense.set_rotation(%d, %s)", angle,
                      pytype(redraw)))
end

function flipH(redraw)
   local redraw = redraw or true
   return py.eval(fmt("sense.flip_h(%s)", pytype(redraw)))
end

function flipV(redraw)
   local redraw = redraw or true
   return py.eval(fmt("sense.flip_v(%s)", pytype(redraw)))
end

function setPixel(x, y, color)
   local cmd = fmt("sense.set_pixel(%d, %d, (%d, %d, %d))",
                   x-1, y-1, color[1], color[2], color[3])
   py.execute(cmd)
end

function clear(color)
   local cmd
   if color then
      cmd = fmt("sense.clear(%d, %d, %d)", color[1], color[2], color[3])
   else
      cmd = fmt("sense.clear()")
   end
   py.execute(cmd)
end

function setPixels(matrix)
--   local dir = pretty.write(matrix, "", false):gsub("{","["):gsub("}","]")
   local dir = pretty.write(matrix, "", false):gsub("{","["):gsub("}","]")
   py.execute(fmt("sense.set_pixels(%s)", dir))
end

function getPixels()
--   local s = tostring(py.eval("sense.get_pixels()")):gsub("%[","{"):gsub("%]","}")
   local s = tostring(py.eval("sense.get_pixels()")):gsub("%[","{"):gsub("]","}")
   return loadstring("return "..s)()
end

function loadImage(file)
--   local s = tostring(py.eval(fmt("sense.load_image('%s')", file))):gsub("%[","{"):gsub("%]","}")
   local s = tostring(py.eval(fmt("sense.load_image('%s')", file))):gsub("%[","{"):gsub("]","}")
   return loadstring("return "..s)()
end

function showMessage(msg, scroll, tcol, bcol)
   local tcol = tcol or {255,255,255}
   local bcol = bcol or {0,0,0}
   py.execute(fmt("sense.show_message('%s', %f, (%d, %d, %d),(%d, %d, %d))", msg, scroll,
                  tcol[1], tcol[2], tcol[3], bcol[1], bcol[2], bcol[3]))
end

function showLetter(c, tcol, bcol)
   local tcol = tcol or {255,255,255}
   local bcol = bcol or {0,0,0}
   py.execute(fmt("sense.show_letter('%s', (%d, %d, %d),(%d, %d, %d))", c,
                  tcol[1], tcol[2], tcol[3], bcol[1], bcol[2], bcol[3]))
end

function lowLight(on)
   if on == nil then
      on = true
   end
   local cmd = fmt("sense.low_light = %s", pytype(on))
   py.execute(cmd)
end

function getGamma()
   local s = tostring(py.eval("sense.gamma")):gsub("%[","{"):gsub("]","}")
   return loadstring("return "..s)()
end

function setGamma(tab)
   py.execute(fmt("sense.gamma = %s", pretty.write(tab, "", false):gsub("{","["):gsub("}","]")))
end

function resetGamma()
   py.execute(fmt("sense.gamma_reset()"))
end

local R = {255, 0, 0}
local G = {0, 255, 0}
local B = {0, 0, 255}
local W = {255, 255, 255}
local D = {0, 0, 0}
pattern = {
   off = {
      D, D, D, D, D, D, D, D,
      D, D, D, D, D, D, D, D,
      D, D, D, D, D, D, D, D,
      D, D, D, D, D, D, D, D,
      D, D, D, D, D, D, D, D,
      D, D, D, D, D, D, D, D,
      D, D, D, D, D, D, D, D,
      D, D, D, D, D, D, D, D,
   },
   on = {
      W, W, W, W, W, W, W, W,
      W, W, W, W, W, W, W, W,
      W, W, W, W, W, W, W, W,
      W, W, W, W, W, W, W, W,
      W, W, W, W, W, W, W, W,
      W, W, W, W, W, W, W, W,
      W, W, W, W, W, W, W, W,
      W, W, W, W, W, W, W, W
   },
   checkerboard = {
      W, W, D, D, W, W, D, D,
      W, W, D, D, W, W, D, D,
      D, D, W, W, D, D, W, W,
      D, D, W, W, D, D, W, W,
      W, W, D, D, W, W, D, D,
      W, W, D, D, W, W, D, D,
      D, D, W, W, D, D, W, W,
      D, D, W, W, D, D, W, W,
   }
}

function ledOff()
   setPixels(pattern.off)
end
function ledOn()
   setPixels(pattern.on)
end

---
-- IMU Sensor
---
function setImuConfig(compass_ena, gyro_ena, accel_ena)
   local compass_ena, gyro_ena, accel_ena =
      compass_ena or true, gyro_ena or true, accel_ena or true
   
   return py.eval(fmt("sense.set_imu_config(%s, %s, %s)",
                      pytype(compass_ena), pytype(gyro_ena),
                      pytype(accel_ena)))
                  
end

function getOrientationRadians()
   return py.eval("sense.get_orientation_radians()")
end

function getOrientationDegrees()
   return py.eval("sense.get_orientation_degrees()")
end

function getCompass()
   return py.eval("sense.get_compass()")
end

function getCompassRaw()
   return py.eval("sense.get_compass_raw()")
end

function getGyroscope()
   return py.eval("sense.get_gyroscope()")
end

function getGyroscopeRaw()
   return py.eval("sense.get_gyroscope_raw()")
end

function getAccelerometer()
   return py.eval("sense.get_accelerometer()")
end

function getAccelerometerRaw()
   return py.eval("sense.get_accelerometer_raw()")
end


function pause()
   return py.execute("pause()")
end

---
-- Joystick
---
local cbtab = {
}

stick = {
   waitEvent = function()
      return py.asattr(py.eval("sense.stick.wait_for_event()"))
   end,

   getEvents = function()
      return py.asattr(py.eval("sense.stick.get_events()"))
   end,

   callback = function(event, dir)
      local f = cbtab[dir]
      if f then
         f(event, dir)
      else
         error("no callback defined")
      end
   end,

   registerCallbacks = function(up, down, left, right, any)
      cbtab = {up=up, down=down, left=left, right=right, any=any}
      local pycallbacks =  table.concat({
            'lua.require("sensehat")',
            [[def pushup(event): lcmd="sense.stick.callback('{0:s}','{1:s}')".format(event.action, "up"); return lua.eval(lcmd)]],
            [[def pushdown(event): lcmd="sense.stick.callback('{0:s}','{1:s}')".format(event.action, "down"); return lua.eval(lcmd)]],
            [[def pushleft(event): lcmd="sense.stick.callback('{0:s}','{1:s}')".format(event.action, "left"); return lua.eval(lcmd)]],
            [[def pushright(event): lcmd="sense.stick.callback('{0:s}','{1:s}')".format(event.action, "right"); return lua.eval(lcmd)]],
            [[def pushany(event): lcmd="sense.stick.callback('{0:s}','{1:s}')".format(event.action, "any"); return lua.eval(lcmd)]],
            'sense.stick.direction_up = pushup',
            'sense.stick.direction_down = pushdown',
            'sense.stick.direction_left = pushleft',
            'sense.stick.direction_right = pushright',
            'sense.stick.direction_any = pushany'
                                        }, "\n")
      py.execute(pycallbacks)
   end,
}


return _ENV 
