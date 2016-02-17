//  This is an Engduino program written by Wayne Tsui
//  Displays real-time temperature readings and light levels

#include <EngduinoThermistor.h>
#include <EngduinoLight.h>

void setup() {
  EngduinoThermistor.begin();
  EngduinoLight.begin();
  Serial.begin(9600);
}

void loop() {
  
  float currentTemperatureReading = EngduinoThermistor.temperature(CELSIUS);    
  int currentLightLevel = EngduinoLight.lightLevel();
  
  Serial.print(currentTemperatureReading);
  Serial.print(",");
  Serial.println(currentLightLevel);
  
  delay(300);
}
