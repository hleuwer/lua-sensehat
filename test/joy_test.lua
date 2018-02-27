sense = require "sensehat"

print("=== JOYSTICK ===")
local events = sense.stick.getEvents()
print("events read: ", events, type(events))

print("Waiting for events. Move the joystick. Loop will stop after 5 captured events.")
local n = 0
while n < 5 do
   local joy = sense.stick.waitEvent()
   print("detected with joystick: ", joy, joy.direction, joy.action)
   n = n + 1
end

local function cb(event, dir)
   print("callback", event, dir)
end
local function cb_any(event, dir)
   print("...")
end
sense.stick.registerCallbacks(cb, cb, cb, cb, cb_any)

print("Pausing. Move the joystick to capture events.")
sense.pause()
