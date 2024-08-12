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
    property int animationDur: 500
    property int widgetRadius: 175
    property int clockRadius: height/2

    AnalogClock { id: analogClock; x: parent.width}
    Speedometer { id: speedometer; x: 140; y: -widgetRadius*2 }    
    Tachometer { id: tachometer; x: 160 + widgetRadius*2; y: -widgetRadius*2 }
    TempGauge { id: tempGauge; x: 140; y: parent.height + widgetRadius*2 }
    BattGauge { id: battGauge; x: 160 + widgetRadius*2; y: parent.height + widgetRadius*2 }

    states: [
        State {
            name: "loaded"
            PropertyChanges { target: speedometer; y: 0 }
            PropertyChanges { target: tachometer; y: 0 }
            PropertyChanges { target: analogClock; x: parent.width - clockRadius*2 }
            PropertyChanges { target: tempGauge; y: parent.height - widgetRadius*2 }
            PropertyChanges { target: battGauge; y: parent.height - widgetRadius*2 }
        },
        State {
            name: "unloaded"
            PropertyChanges { target: delayTimer; running: true }
        }
    ]

    // Wait for previous animations to complete before unloading width
    Timer {
        id: delayTimer
        interval: animationDur
        running: false
        repeat: false
        onTriggered: loader2.active = false
    }

    transitions: Transition {
        NumberAnimation { target: speedometer; property: "y"; easing.type: Easing.InOutQuad; duration: animationDur }
        NumberAnimation { target: tachometer; property: "y"; easing.type: Easing.InOutQuad; duration: animationDur }
        NumberAnimation { target: analogClock; property: "x"; easing.type: Easing.InOutQuad; duration: animationDur }
        NumberAnimation { target: tempGauge; property: "y"; easing.type: Easing.InOutQuad; duration: animationDur }
        NumberAnimation { target: battGauge; property: "y"; easing.type: Easing.InOutQuad; duration: animationDur }
    }
}