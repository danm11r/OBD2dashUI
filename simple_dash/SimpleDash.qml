// DM July 2024
// Default dash
    
import QtQuick 2.15
import QtQuick.Shapes 1.15
import QtQuick.Controls 2.15

Item {

    id: simpleDash

    anchors.fill: parent

    property int arcWidth: 16
    property bool enableMask: true
    property bool enableAnimation: false
    property int animationDur: 2000

    ErrorIcon {
        id: errorIcon
        visible: false
    
        width: 100
        height: 100

        anchors.centerIn: parent

        MouseArea {
            anchors.fill: parent
            onClicked: errorMsg.open()
        }
    }

    states: [
        State {
            name: "errorState"
            PropertyChanges { target: errorIcon; visible: true }
        }
    ]

    Connections {
        target: backend

        function onError (errormsg) {
            
            if (errormsg == true) {
                simpleDash.state = "errorState"
                errorMsg.open()
            }
            else
                simpleDash.state = ""
        }
    }
}