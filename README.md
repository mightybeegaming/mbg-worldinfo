# MBG World Info
A Project Zomboid mod that prints **World Age**, **Date Time**, and **Weather** every 10 seconds in server console.

This tool is created mainly for [MBG Project Zomboid](https://mbgplayground.xyz/projectzomboid) server metrics.

Steam Workshop - [MBG World Info](https://steamcommunity.com/sharedfiles/filedetails/?id=3676979895)

## Weather Labels
| Weather   | Labels    | Metrics           |
|:-         |:-         |:-                 |
| **Snow**  | Snowing+  | Intensity > 0.6   |
|           | Snowing   | Intensity <= 0.6  |
| **Rain**  | Raining++ | Intensity > 0.7   |
|           | Raining+  | Intensity > 0.3   |
|           | Raining   | Intensity <= 0.0  |
| **Cloud** | Cloudy+   | Intensity > 0.6   |
|           | Cloudy    | Intensity > 0.3   |
| **Fog**   | Foggy+    | Intensity > 0.5   |
|           | Foggy     | Intensity > 0.2   |
| **Wind**  | Windy+    | Speed > 40        |
|           | Windy     | Speed > 20        |