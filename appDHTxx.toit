/*
ESP32-WROOM reads 8 DHT22 air sensors.
*/
import gpio
import .DHT22-AirSensor

GPIO_LED_RED ::= 2
GPIO-DHTXX ::= [14,27,26,25,33,32, 18, 19] 

main:
  led := gpio.Pin GPIO-LED-RED --output=true

  100.repeat:
    print "\n$(it+1)."
    GPIO-DHTXX.size.repeat: | n |
      gpio := GPIO-DHTXX[n]
      led.set 1
      e := catch: 
        air-sensor := Air-Sensor-DHT22 --gpio=gpio
        data := air-sensor.read
        print " - DHTXX-$(n+1) ($gpio): $data.stringify"
      if e:
        print " - DHTXX-$(n+1) ($gpio): $e"
      led.set 0

    sleep --ms=5000

// EOF.