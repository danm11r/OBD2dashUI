// DM June 2024
// Generic error icon. Specify height and width

import QtQuick 2.15
import QtQuick.Shapes 1.15

Item {

    id: menuOverlay

    anchors.fill: parent

    property int iconSize: 100
    property int animationDur: 250

    // Menu background
    Item {

        id: menuBackground

        width: 120
        height: parent.height
        
        x: -width

        Rectangle {
            
            width: parent.width
            height: parent.height

            radius: width/2
            
            color: "#2A2A2A"
        }
        Rectangle {
            
            width: parent.width/2
            height: parent.height
            
            color: "#2A2A2A"
        }

        // Settings button
        Rectangle {

            id: settingsButton

            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.leftMargin: 10
            anchors.bottomMargin: 10

            width: iconSize
            height: iconSize
            radius: iconSize/2

            color: settings.color4

            Text {
                anchors.centerIn: parent
                text: "S"
                color: "white"
                font.pixelSize: iconSize*.6
                font.bold: true
            }

            MouseArea {
                anchors.fill: parent
                onClicked: { 
                    settingsButton.state == 'clicked' ? settingsButton.state = "" : settingsButton.state = 'clicked';
                }
            }

            states: [
                State {
                    name: "clicked"
                    PropertyChanges { target: settingsButton; color: settings.color2 }
                    PropertyChanges { target: settingsLoader; active: true }
                }
            ]

            transitions: Transition {
                ColorAnimation { target: settingsButton; property: "color"; duration: animationDur }
            }
        }
    }

    Loader { 
        anchors.centerIn:parent
        id: settingsLoader
        active: false
        source: "SettingsPage.qml"
    }

    // Menu button
    Rectangle {

        id: menuButton

        anchors.top: parent.top
        anchors.left: parent.left
        anchors.leftMargin: 10
        anchors.topMargin: 10

        width: iconSize
        height: iconSize
        radius: iconSize/2

        color: settings.color4

        Text {
            anchors.centerIn: parent
            text: "M"
            color: "white"
            font.pixelSize: iconSize*.6
            font.bold: true
        }

        MouseArea {
            anchors.fill: parent
            onClicked: { 
                menuOverlay.state == 'clicked' ? menuOverlay.state = "" : menuOverlay.state = 'clicked';
            }
        }
    }

    states: [
        State {
            name: "clicked"
            PropertyChanges { target: menuButton; color: settings.color2 }
            PropertyChanges { target: menuButton; rotation: 360 }
            PropertyChanges { target: menuBackground; x: 0 }
            PropertyChanges { target: settingsButton; state: "" }
        }
    ]

    transitions: Transition {
        ColorAnimation { target: menuButton; property: "color"; duration: animationDur }
        RotationAnimation { target: menuButton; duration: animationDur }
        NumberAnimation { target: menuBackground; property: "x"; easing.type: Easing.InOutQuad; duration: animationDur }
    }
}