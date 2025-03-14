# Example for 8x DHTxx sensors use.

For plant cultivation, I would like to use several DHTxx sensors to check the favorable germination environment. The prototype uses an ESP32 'wroom'. 

## limited RMT channels
The used Toit driver package **dhtxx** uses 2x RMT channels for each opened sensor device. Due to the ESP32-WROOM limit of 8 RMT channels, the sensor driver releases the allocated RMT channels after access.

```
  ...
  read -> AirSensorData?:
    pin :=  Pin gpio
    driver := dhtxx.Dht22 pin

    try: 
      for i-trial := 1; i-trial <= MAXIMUM-NUMBER-OF-TRIALS; i-trial++:
        e := catch: 
          data := driver.read
          return AirSensorData.init (data.temperature - error-temperature) (data.humidity - error-humidity)
        if e:
          sleep --ms=200 // give device more time for initialisation
      throw "no data available"

    finally:
      driver.close
      pin.close
```

## Prototype setup
Prototype board:
![alt text](image.png)

```
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
```