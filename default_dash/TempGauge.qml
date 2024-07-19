// DM July 11
// Temp and batt voltage

import QtQuick 2.15
import QtQuick.Shapes 1.15

Item {

    width: 240
    height: 240

    x: parent.width/2
    y: .8*parent.height + 1000
    
    Rectangle {
        x: -width/2
        y: -width/2

        width: parent.width
        height: parent.height
        radius: width/2

        color: settings.color4
    }

    // Draw tick marks for temp gauge
    Repeater {

        model: (maxTemp/100)*3+1

        Rectangle {
            x: - arcWidth/4
            y: - parent.width/2
            width: arcWidth/2
            height: arcWidth
            radius: 180
            color: settings.color3

            transform: Rotation { origin.x: arcWidth/4; origin.y: parent.width/2; angle: index*(135/(maxTemp/100*3)) - 67.5} 
        }
    }

    Repeater {

        model: (maxTemp/100)+1

        Rectangle {
            x: - arcWidth/4
            y: - parent.width/2
            width: arcWidth/2
            height: arcWidth
            radius: 180
            color: settings.color1

            transform: Rotation { origin.x: arcWidth/4; origin.y: parent.width/2; angle: index*(135/(maxTemp/100)) - 67.5} 
        }
    }

    // HIGH LOW text
    Item {
        x: Math.round((parent.width/2-35)*Math.cos((2*(270/(maxRPM/1000))+135)* Math.PI / 180))
        y: Math.round((parent.width/2-35)*Math.sin((2*(270/(maxRPM/1000))+135)* Math.PI / 180))
        
        Text {
            anchors.centerIn: parent
            text: "L"
            font.pixelSize: 30
            font.bold: true
            font.italic: true
            color: settings.color1
        }
    }

    Item {
        x: Math.round((parent.width/2-35)*Math.cos((6*(270/(maxRPM/1000))+135)* Math.PI / 180))
        y: Math.round((parent.width/2-35)*Math.sin((6*(270/(maxRPM/1000))+135)* Math.PI / 180))
        
        Text {
            anchors.centerIn: parent
            text: "H"
            font.pixelSize: 30
            font.bold: true
            font.italic: true
            color: settings.color1
        }
    }

    // Temp needle
    Rectangle {
        x: -arcWidth/4
        y: -arcWidth/4 + 70
        width: arcWidth/2
        height: 35
        radius: 180
        color: "#CE2029"

        transform: Rotation { origin.x: arcWidth/4; origin.y: arcWidth/4-70; angle: 112.5 + 135/maxTemp*temp; Behavior on angle { enabled: enableAnimation; SmoothedAnimation { velocity: 1; duration: 500 } }}
    }

    // Temp text
    Item {
        x: -width/2

        width: parent.width

        Text {
            id: tempText
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.top
            y: -30
            text: temp
            font.pixelSize: parent.width*(.17)
            font.bold: true
            font.italic: true
            color: "white"
        }
        Text {
            anchors.left: tempText.right
            anchors.bottom: tempText.bottom
            anchors.bottomMargin: parent.width*.03
            text: "\u00B0" + "F"
            font.pixelSize: parent.width*(.085)
            font.bold: true
            font.italic: true
            color: "#CE2029"
        }
    }

    // Draw tick marks for battery gauge
    Repeater {

        model: ((maxBatt-minBatt)*2)+1

        Rectangle {
            x: - arcWidth/4
            y: - parent.width/2
            width: arcWidth/2
            height: arcWidth
            radius: 180
            color: settings.color3

            transform: Rotation { origin.x: arcWidth/4; origin.y: parent.width/2; angle: index*(135/((maxBatt-minBatt)*2)) - 247.5} 
        }
    }

    Repeater {

        model: (maxBatt-minBatt)+1

        Rectangle {
            x: - arcWidth/4
            y: - parent.width/2
            width: arcWidth/2
            height: arcWidth
            radius: 180
            color: settings.color1

            transform: Rotation { origin.x: arcWidth/4; origin.y: parent.width/2; angle: index*(135/(maxBatt-minBatt)) - 247.5} 
        }
    }

    // Min Max text
    Item {
        x: Math.round((parent.width/2-35)*Math.cos((0*(135/(maxBatt-minBatt))-157.5)* Math.PI / 180))
        y: Math.round((parent.width/2-35)*-Math.sin((0*(135/(maxBatt-minBatt))-157.5)* Math.PI / 180))
        
        Text {
            anchors.centerIn: parent
            text: minBatt
            font.pixelSize: 30
            font.bold: true
            font.italic: true
            color: settings.color1
        }
    }

    Item {
        x: Math.round((parent.width/2-35)*Math.cos((6*(135/(maxBatt-minBatt))-157.5)* Math.PI / 180))
        y: Math.round((parent.width/2-35)*-Math.sin((6*(135/(maxBatt-minBatt))-157.5)* Math.PI / 180))
        
        Text {
            anchors.centerIn: parent
            text: maxBatt
            font.pixelSize: 30
            font.bold: true
            font.italic: true
            color: settings.color1
        }
    }

    // Battery needle
    Rectangle {
        x: -arcWidth/4
        y: -arcWidth/4 + 70
        width: arcWidth/2
        height: 35
        radius: 180
        color: "#CE2029"

        transform: Rotation { origin.x: arcWidth/4; origin.y: arcWidth/4-70; angle: (battery >= minBatt) ? 67.5 - 135/(maxBatt-minBatt)*(battery-minBatt) : 67.5; Behavior on angle { enabled: enableAnimation; SmoothedAnimation { duration: 500 } }}
    }

    // Battery text
    Item {
        x: -width/2

        width: parent.width

        Text {
            id: batteryText
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            text: !enableAnimation ? Math.ceil(battery) : battery
            font.pixelSize: parent.width*(.17)
            font.bold: true
            font.italic: true
            color: "white"
        }
        Text {
            anchors.left: batteryText.right
            anchors.bottom: batteryText.bottom
            anchors.bottomMargin: parent.width*.03
            text: "V"
            font.pixelSize: parent.width*(.085)
            font.bold: true
            font.italic: true
            color: "#CE2029"
        }
    }

    NumberAnimation on y { to: y - 1000; easing.type: Easing.InOutQuad; duration: animationDur }
}