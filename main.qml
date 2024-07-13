// Daniel Miller July 2024
// dashUI

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

    // Color settings:
    property string color1: "#50C878"
    property string color2: "#3C965A"
    property string color3: "#29663D"
    property string color4: "#112919"
    property string accent: "#CE2029"
    property string bgcolor: "#2A2A2A"   

    DefaultDash{}

    Test{}

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