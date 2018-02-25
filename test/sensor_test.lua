sense = require "sensehat"
local socket = require "socket"
local sense = require "sensehat"
local fmt = string.format
local stemp = 0
local N = tonumber(arg[1]) or 1000

print("=== SENSORS ===")
print(fmt("relative humidity: %.2f %%", sense.humidity()))
print(fmt("pressure         : %.2f mbar", sense.pressure()))
print(fmt("temperature      : %.2f °C", sense.temperature()))
print(fmt("  from mhumidity : %.2f °C", sense.temperatureFromHumidity()))
print(fmt("  from pressure  : %.2f °C", sense.temperatureFromPressure()))
t1 = os.time()
for i = 1, N do
	local temp = sense.temperature()
	stemp = stemp + temp	
end
local t2 = os.time()
local dt = (t2 - t1)*1000/N 
print(fmt("average temp.    : %.2f °C", stemp/N))
print(fmt("samples: %d time: %d sec speed: %.3f msec", N, t2 - t1, dt))

