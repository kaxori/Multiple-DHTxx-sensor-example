import gpio show *
import dhtxx
import .humidity show *


/*
AirSensorData defines data structure
*/
class AirSensorData:
  temperature /float
  humidity /float
  absolute-humidity /float

  constructor:
    temperature = 0.0
    humidity = 0.0
    absolute-humidity = 0.0

  constructor.init .temperature .humidity:
    absolute-humidity = calc-absolute-humidity humidity temperature

  stringify -> string:
    return "T:$(%2.1f temperature) °C, H:$(%4.1f humidity) %, Habs:$(%4.1f absolute-humidity) g/m^3"




/*
Air-Sensor-DHT22 
*/
class Air-Sensor-DHT22:

  static MAXIMUM-NUMBER-OF-TRIALS ::= 5

  gpio /int
  error-temperature /float
  error-humidity /float

  constructor --.gpio --.error-temperature=0.0 --.error-humidity=0.0:

  read -> AirSensorData?:
    pin :=  Pin gpio
    driver := dhtxx.Dht22 pin
    
    try: 
      for i-trial := 1; i-trial <= MAXIMUM-NUMBER-OF-TRIALS; i-trial++:
        e := catch: 
          data := driver.read
          return AirSensorData.init (data.temperature - error-temperature) (data.humidity - error-humidity)
        
        if e:
          sleep --ms=200 // give device more  time for initialisation

      throw "no data available"

    finally:
      driver.close
      pin.close

// EOF.