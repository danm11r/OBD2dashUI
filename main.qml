// Daniel Miller July 2024
// dashUI

import Qt.labs.settings 1.0
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Shapes 1.15
import QtGraphicalEffects 1.12

import "./qml"
import "./default_dash"

ApplicationWindow {
    id: main
    visible: true
    width: 1600
    height: 720

    title: "dashUI"
    color: "black"

    // Signal properties
    property QtObject backend
    property int speed: 0
    property int rpm: 0
    property int temp: 0
    property double battery: 10

    property int maxMPH: 120 
    property int maxRPM: 8000
    property int redLine: 6500 
    property int maxTemp: 400
    property int maxBatt: 16
    property int minBatt: 10

    // Color themes
    property variant color1Array: ["#50C878", "#15F4EE", "#F21894", "#A817E6"] // 90%
    property variant color2Array: ["#3C965A", "#11BFB9", "#BF1375", "#8C13BF"] // 75%
    property variant color3Array: ["#29663D", "#0E9994", "#990F5D", "#700F99"] // 60%
    property variant color4Array: ["#112919", "#042928", "#33051F", "#250533"] // 20%

    Settings {
        id: settings

        // Global color values. Overridden when theme selected from settings page
        property string color1: "#50C878"
        property string color2: "#3C965A"
        property string color3: "#29663D"
        property string color4: "#112919"
        property string accent: "#CE2029"
        property string bgcolor: "#2A2A2A"   
        property int selectedThemeIndex: 0
    }

    property string errorText: "OBD2 Connection Failed!"

    DefaultDash{}
    MenuOverlay{}

    Connections {
        target: backend

        function onData (msg, msg2, msg3, msg4) {
            speed = msg
            rpm = msg2
            temp = msg3
            battery = msg4
        }
    }
}