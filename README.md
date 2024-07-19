# OBD2dashUI
Digital dash board UI built with Python and QtQuick

# About 
This app was built with Python and the PyQt5 toolkit, and uses the Python-OBD library for OBD2 communications. A ELM327 OBD2 adapter is needed for the OBD2 interface. The current version is only a proof of concept, but will display the MPH, RPM, engine temp, and battery voltage.

Startup animation demo:
![dashdemo](https://github.com/user-attachments/assets/ac6a32ae-06db-4113-8f8a-40d321ca9097)

Running on a raspberry pi, showing live data:
![dashdemoim](https://github.com/user-attachments/assets/116d50b2-82a5-47c6-8563-872fdaf92e0b)

# Setup 
Coming soon...

# Todo 
- Control backlight brightness of LCD through DDC/CI in response to ambient light conditions
- Add different dashboard themes to choose from 
- Carplay integration! Current plan is to use node-carplay
