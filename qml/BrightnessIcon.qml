// DM June 2024
// Generic brightness icon. Specify height and width

import QtQuick 2.15
import QtQuick.Shapes 1.15

Item {

    Repeater {

        id: repeater

        anchors.fill: parent
        model: 6

        Rectangle {
            x: parent.width/2 - arcWidth/4
            y: 0
            width: arcWidth/2
            height: arcWidth
            radius: 180
            color: settings.color1

            transform: Rotation { origin.x: arcWidth/4; origin.y: parent.width/2; angle: index*60 } 
        }
    }

    Rectangle {

        anchors.centerIn: parent

        color: settings.color1
        height: 25
        width: 25
        radius: 180
    }
}