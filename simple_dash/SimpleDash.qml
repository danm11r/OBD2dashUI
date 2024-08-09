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

    property int widgetRadius: 180

    AnalogClock {}

    // Row and column positioning should be used once final placement determined
    Speedometer { x: 130 }
    
    Tachometer { x: 150 + widgetRadius*2 }

    // Temporarily disabled until final location determined
    ErrorIcon {
        id: errorIcon
        visible: false
    
        width: 100
        height: 100

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top

        MouseArea {
            anchors.fill: parent
            onClicked: errorMsg.open()
        }
    }

    states: [
        State {
            name: "errorState"
            //PropertyChanges { target: errorIcon; visible: true }
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