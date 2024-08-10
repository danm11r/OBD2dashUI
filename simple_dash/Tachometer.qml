// DM Aug 2024
// Tachometer
    
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

    // Tick marks for tachometer
    Repeater {

        model: (maxRPM/1000)*6

        Rectangle {
            x: widgetRadius-arcWidth/4
            y: widgetRadius-parent.width/2
            width: arcWidth/2
            height: arcWidth*2
            radius: 180
            color: (rpm/1000*6 >= index && index/6*1000 >= redLine) ? "red" : (rpm/1000*6 >= index) ? settings.color1 : ((index/6)*1000 >= redLine) ? "#CE2029" : settings.color3

            transform: Rotation { origin.x: arcWidth/4; origin.y: parent.width/2; angle: index*(270/(maxRPM/1000*6))-135 } 
        }
    }

    // RPM text
    Item {
        
        anchors.fill: parent

        Text {
            id: rpmText
            anchors.centerIn: parent
            text: (rpm >= 1000) ? (rpm/1000).toFixed(2) : rpm //Math.round(rpm/1000 * 100)/100 : rpm
            font.pixelSize: widgetRadius*(2/3)
            font.bold: true
            font.italic: true
            color: "white"
        }
        Text {
            anchors.top: rpmText.bottom
            anchors.horizontalCenter: rpmText.horizontalCenter
            anchors.topMargin: -30
            visible: (rpm >= 1000)
            text: "x 1000"
            font.pixelSize: widgetRadius*(1/6)
            font.bold: true
            font.italic: true
            color: "white"
        }
        Text {
            anchors.top: rpmText.bottom
            anchors.horizontalCenter: rpmText.horizontalCenter
            text: "RPM"
            font.pixelSize: widgetRadius*(1/3)
            font.bold: true
            font.italic: true
            color: settings.color1
        }
    }
}