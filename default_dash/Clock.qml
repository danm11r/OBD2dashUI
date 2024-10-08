// DM July 10
// Clock module

import QtQuick 2.15
import QtQuick.Shapes 1.15

Item {

    width: 240
    height: 240

    property string hour
    property string minute
    property int textSize: 80
    property var time: {'hour': 0, 'minute': 0, 'second': 0, 'hour_text': "0", 'minute_text': "0", 'PM': false } // This shares the same name as the signal and should probably be changed to something else

    Rectangle {
        x: -width/2
        y: -width/2

        width: parent.width
        height: parent.height
        radius: width/2

        color: settings.color4

        Text {
            anchors.centerIn: parent
            text: time.hour_text + ":" + time.minute_text
            font.pixelSize: textSize
            font.bold: true
            color: "white"
        }
    }

    // Draw second marks
    Repeater {

        model: 60

        Rectangle {
            x: - arcWidth/4
            y: - parent.width/2
            width: arcWidth/2
            height: arcWidth
            radius: 180
            color: (time.second >= index) ? settings.color1 : settings.color3

            transform: Rotation { origin.x: arcWidth/4; origin.y: parent.width/2; angle: index*6 } 
        }
    }

    // Draw a red dot if PM
    Rectangle {
        visible: time.PM
        x: - arcWidth
        y: parent.height/4
        width: arcWidth*2
        height: arcWidth
        radius: 180
        color: settings.accent
    }

    Connections {
        target: backend

        function onTime (hour, minute, second, hour_text, minute_text, PM) {
            time = {'hour': hour, 'minute': minute, 'second': second, 'hour_text': hour_text, 'minute_text': minute_text, 'PM': PM};
        }
    }

    NumberAnimation on y { to: .2*parent.height; easing.type: Easing.InOutQuad; duration: animationDur }
}