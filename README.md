# OBD2dashUI
Digital dashboard UI built with Python and Qt Quick

# About 
0BD2DashUI is a PyQt5 based digital dashboard that displays real-time data from a vehicle connected via OBD2. The app uses the Python-OBD library for OBD2 communications, and an ELM327 OBD2 adapter is needed for the interface. Currently, the app will display vehicle speed, engine RPM, coolant temperature, and battery voltage. A demo of the app loading, seemlessly connecting to a vehicle over OBD2, and showing live vehicle data is shown below:
<img src="https://github.com/user-attachments/assets/6d5ae7cc-504b-4462-a87f-9a7f4a5f4bca" width=100% height=20%>

The app supports different dashboards that can be swiped between. There are currently two: a traditional gauge cluster shown in the demo above, and a second dashboard featuring a collection of smaller gauges arranged in a grid. There is a basic settings page for selecting a color theme and adjusting the brightness of a compatible DDC/CI capable display. 
<img src="https://github.com/user-attachments/assets/3b63295f-0e21-4344-8707-1a99f337abfd" width=100% height=20%>


Here's a look at an older version of the app running on a Pi 4, connected to a Waveshare 1600x720 display:
![dashdemoim](https://github.com/user-attachments/assets/116d50b2-82a5-47c6-8563-872fdaf92e0b)

# Features
- Live OBD2 data for vehicle speed, engine RPM, coolant temperature, and battery voltage, updated 10 times per second.
- Ability to control backlight brightness of connected LCD via DDC/CI
- 2 different dashboards to choose from
- 4 selectable color themes

# Todo 
- Add support for more OBD2 PIDs to increase the number of different data points that can be displayed
- Set LCD brightness in response to ambient lighting conditions
- Add more dashboard themes
- Carplay integration! There is currently a build that (barely) works, but a lot more optimization is needed

# Setup 
A detailed setup guide is in the works. For now, I recommend looking at the setup process for my other PyQt5 based app, ClockUI.  


