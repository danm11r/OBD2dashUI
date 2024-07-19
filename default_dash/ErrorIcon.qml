// DM June 2024
// Generic error icon. Specify height and width

import QtQuick 2.15
import QtQuick.Shapes 1.15

Item {

    Rectangle {

        id: circle

        anchors.fill: parent
        color: "transparent"
        border.color: "#CE2029"
        border.width: circle.width*(.10)
        radius: 180

        Column {
            anchors.centerIn: parent
            spacing: circle.width*(.05)
            Rectangle {
                color: "#CE2029"
                height: circle.width*(.40)
                width: circle.width*(.15)
                radius: 180
            }
            Rectangle {
                color: "#CE2029"
                height: circle.width*(.15)
                width: circle.width*(.15)
                radius: 180
            }
        
        }
    }
}