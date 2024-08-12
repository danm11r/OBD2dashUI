// DM Aug 2024
// Test widget for placement
    
import QtQuick 2.15
import QtQuick.Shapes 1.15

Item {

    width: widgetRadius*2
    height: widgetRadius*2

    // Background
    Rectangle {

        width: parent.width
        height: parent.height
        radius: width/2

        color: settings.color4
    }

    // Tick marks for battery gauge
    Repeater {

        model: ((maxBatt-minBatt)*5)+1

        Rectangle {
            x: widgetRadius-arcWidth/4
            y: widgetRadius-parent.width/2
            width: arcWidth/2
            height: arcWidth*2
            radius: 180
            color: ((battery-minBatt)*5 >= index) ? settings.color1 : settings.color3

            transform: Rotation { origin.x: arcWidth/4; origin.y: parent.width/2; angle: index*(270/((maxBatt-minBatt)*5)) - 135} 
        }
    }

    // Battery text
    Item {
        anchors.fill: parent

        Text {
            id: text
            anchors.centerIn: parent
            text: battery
            font.pixelSize: widgetRadius*(2/3)
            font.bold: true
            font.italic: true
            color: "white"
        }
        Text {
            anchors.left: text.right
            anchors.bottom: text.bottom
            anchors.bottomMargin: parent.width*.08
            text: "V"
            font.pixelSize: widgetRadius*(1/5)
            font.bold: true
            font.italic: true
            color: "white"
        }
        Text {
            anchors.top: text.bottom
            anchors.horizontalCenter: text.horizontalCenter
            text: "BATT"
            font.pixelSize: widgetRadius*(1/3)
            font.bold: true
            font.italic: true
            color: settings.color1
        }
    }
}