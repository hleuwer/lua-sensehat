MODULE=sensehat.lua
LUAV=5.2
INSTALL_LUA=/usr/local/share/lua/$(LUAV)

install:
	cp $(MODULE) $(INSTALL_LUA)

uninstall:
	rm $(INSTALL_LUA)/$(MODULE)

clean:
	rm -rf `find . -name "*~"`

test-led:
	sudo lua test/led_test.lua

test-imu:
	sudo lua test/imu_test.lua

test-joy:
	sudo lua test/joy_test.lua

test-sensor:
	sudo lua test/sensor_test.lua

test: test-led test-imu test-joy test-sensor
