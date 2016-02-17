// This is a Processing programme written by Wayne Tsui.
// Reads Engduino serial output to display temperature readings and light levels.

import processing.serial.*;

Serial port;
float currentTemperatureReading;
float highestTemperatureReading = 0;
float lowestTemperatureReading = 100;
float[] temperatureArray = new float[20];
int currentLightLevel;
int highestLightLevel = 0;
int lowestLightLevel = 1000;
int[] lightArray = new int[20];

void setup(){
  printArray(Serial.list());
  size(850,500);
  port = new Serial(this, Serial.list()[5], 9600);
  port.clear();  
  port.readStringUntil('\n');
  port.bufferUntil('\n');
}

void serialEvent(Serial port) {
  while (port.available() > 0) {
    
    // Get serial port input, remove any whitespace characters from beginning and end of string
    String inputString = port.readStringUntil('\n');
           inputString = trim(inputString);
           
    // Separate temperature and light data and convert both to float and integers respectively      
    String[] splitString = split(inputString, ",");
    try {
      currentTemperatureReading = Float.parseFloat(splitString[0]);
      currentLightLevel = Integer.parseInt(splitString[1]);
    }
    catch (Exception e) {
    }
       
    // Previous array value is stored in index position before index position of current array value
    for (int i = 1; i < temperatureArray.length; i++) {
      temperatureArray[i-1] = temperatureArray[i];
    }   
     for (int i = 1; i < lightArray.length; i++) {
       lightArray[i-1] = lightArray[i];
    }
    
    // Record highest and lowest data recorded when programme executes
    if (currentTemperatureReading > highestTemperatureReading) {
      highestTemperatureReading = currentTemperatureReading;
    }
    if (currentTemperatureReading < lowestTemperatureReading) {
      lowestTemperatureReading = currentTemperatureReading;
    }
    if (currentLightLevel > highestLightLevel) {
      highestLightLevel = currentLightLevel;
    }
     if (currentLightLevel < lowestLightLevel) {
      lowestLightLevel = currentLightLevel;
    }

  }
}

void title() {
  fill(0);
  textSize(30);
  textAlign(CENTER,CENTER);
  text("Sensor Data", 425, 40);
}

void temperatureBarChart() {
  int minX = 100, maxX = 340, minY = 375, midX = (minX+maxX)/2; 
  int graphBarWidth = (maxX-minX)/temperatureArray.length;
  
  // Header for Bar Chart
  fill(0);
  textSize(16);
  text("Temperature Bar Chart (°C)", midX, 125);
  
  // Labelling and drawing axes
  for (int i=0; i<5; i++) {
    line(minX, minY-(i*50), maxX, minY-(i*50));
    text(i*25, minX - 20, minY-(i*50));
  }
  
  // Display current, highest and lowest temperature readings as text
  text("Current Temperature:           °C", midX, 410);
  String currentTemp = String.format("%.2f", currentTemperatureReading);
  text(currentTemp, midX+78, 410);
  
  text("Highest Temperature Recorded:           °C", midX, 440);
  String highTemp = String.format("%.2f", highestTemperatureReading);
  text(highTemp, midX+117, 440);
  
  text("Lowest Temperature Recorded:           °C", midX+3, 465);
  String lowTemp = String.format("%.2f", lowestTemperatureReading);
  text(lowTemp, midX+117, 465);
  
  // Display temperature readings as bar chart
  fill(#0066FF);
  temperatureArray[temperatureArray.length-1] = currentTemperatureReading;
  for (int i = temperatureArray.length-1; i >= 0; i--) {
    rect(maxX-((temperatureArray.length-i)*graphBarWidth), minY, graphBarWidth, -2*temperatureArray[i]);
  }
}

void lightLevelBarChart() {
  int minX = 500, maxX = 740, minY = 380, midX = (minX+maxX)/2;
  int graphBarWidth = (maxX-minX)/lightArray.length;
  
  // Header for Bar Chart
  fill(0);
  textSize(16);
  text("Light Level Bar Chart", midX, 90);
  
  // Labelling and drawing axes
  for (int i=0; i<11; i++) {
    line(minX, minY-(i*25), maxX, minY-(i*25));
  }
  for (int i=0; i<6; i++) {
       text(i*200, minX-20, minY-(i*50));
  }
  
  // Display current, highest and lowest light levels as text
  text("Current Light Level:       ", midX, 410);
  text("Highest Light Level Recorded:    ", midX, 440);
  text("Light Light Level Recorded:", midX, 465);
  textAlign(LEFT,CENTER);
  text(currentLightLevel, midX+65, 410);
  text(highestLightLevel, midX+110, 440);
  text(lowestLightLevel, midX+110, 465);
  
  // Display light levels as bar chart
  fill(#0066FF);
  lightArray[lightArray.length-1] = currentLightLevel;
  for (int i = lightArray.length-1; i >= 0; i--) {
    rect(maxX-((lightArray.length-i)*graphBarWidth), minY, graphBarWidth, -lightArray[i]/4);
  }
}

void draw() {
  background(#FFD380);
  title();
  temperatureBarChart();
  lightLevelBarChart();
}