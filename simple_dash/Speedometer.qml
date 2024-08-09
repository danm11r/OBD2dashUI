// DM Aug 2024
// Speedometer
    
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

    // Tick marks for speedometer
    Repeater {

        model: maxMPH/2

        Rectangle {
            x: widgetRadius-arcWidth/4
            y: widgetRadius-parent.width/2
            width: arcWidth/2
            height: arcWidth*2
            radius: 180
            color: (speed/2 >= index) ? settings.color1 : settings.color3

            transform: Rotation { origin.x: arcWidth/4; origin.y: parent.width/2; angle: index*(270/(maxMPH/2)) - 135} 
        }
    }

    // MPH text
    Item {
        
        anchors.fill: parent

        Text {
            id: speedText
            anchors.centerIn: parent
            text: speed
            font.pixelSize: widgetRadius*(2/3)
            font.bold: true
            font.italic: true
            color: "white"
        }
        Text {
            anchors.top: speedText.bottom
            anchors.horizontalCenter: speedText.horizontalCenter
            text: "MPH"
            font.pixelSize: widgetRadius*(1/3)
            font.bold: true
            font.italic: true
            color: settings.color1
        }
    }
}