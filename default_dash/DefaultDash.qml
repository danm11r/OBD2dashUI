// DM July 2024
// Default dash
    
import QtQuick 2.15
import QtQuick.Shapes 1.15
import QtQuick.Controls 2.15

Item {

    id: defaultDash

    // Anchor would be better but doesnt load properly for startup
    width: 1600
    height: 720

    property bool enableMask: true
    property bool enableAnimation: false
    property int animationDur: (startingAnimationComplete) ? 1000 : 2000
    property int widgetRadius: 120

    property bool error: false

    Speedometer{ id: speedometer; width: 720; height: 720 }
    Tachometer{ id: tachometer; x: parent.width - 720; width: 720; height: 720 }

    // Mask off the area beyond the gauges only during the startup animation
    Loader {

        active: enableMask // Currently set to true to resolve issue with menu overlay transparency
        sourceComponent: Item {
            Rectangle {
                id: background
                height: 720
                width: 1600
                opacity: 0.0
            }

            Rectangle {
                id: gaugeMask
                color: "transparent"

                anchors.fill: background
                Rectangle {
                    x: parent.width - 720
                    y: 0
                    width: 720
                    height: 720
                    radius: 360
                }

                Rectangle {
                    x: 0
                    y: 0
                    width: 720
                    height: 720
                    radius: 360
                }

                layer.enabled: true
                layer.samplerName: "maskSource"
                layer.effect: ShaderEffect {
                property variant source: background
                fragmentShader: "
                        varying highp vec2 qt_TexCoord0;
                        uniform highp float qt_Opacity;
                        uniform lowp sampler2D source;
                        uniform lowp sampler2D maskSource;
                        void main(void) {
                            gl_FragColor = texture2D(source, qt_TexCoord0.st) * (1.0-texture2D(maskSource, qt_TexCoord0.st).a) * qt_Opacity;
                        }
                    "
                }
            }
        }
    }

    TempGauge { id: tempGauge; x: parent.width/2; y: parent.height + widgetRadius*2 }
    Clock{ id: clock; x: parent.width/2; y: -widgetRadius*2}

    ErrorIcon {
        id: errorIcon
        visible: error
    
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
            name: "loaded"
            PropertyChanges { target: tempGauge; y: .8*parent.height }
            PropertyChanges { target: clock; y: .2*parent.height }
        },
        State {
            name: "unloaded"
            PropertyChanges { target: tempGauge; y: parent.height + widgetRadius*2 }
            PropertyChanges { target: clock; y: -widgetRadius*2 }
            PropertyChanges { target: speedometer; y: -parent.height }
            PropertyChanges { target: tachometer; y: -parent.height }
            PropertyChanges { target: delayTimer; running: true }
        }
    ]

    // Wait for previous animations to complete before unloading
    Timer {
        id: delayTimer
        interval: animationDur
        running: false
        repeat: false
        onTriggered: loader1.active = false
    }

    transitions: Transition {
        NumberAnimation { target: tempGauge; property: "y"; easing.type: Easing.InOutQuad; duration: animationDur }
        NumberAnimation { target: clock; property: "y"; easing.type: Easing.InOutQuad; duration: animationDur }
        NumberAnimation { target: speedometer; property: "y"; easing.type: Easing.InOutQuad; duration: animationDur }
        NumberAnimation { target: tachometer; property: "y"; easing.type: Easing.InOutQuad; duration: animationDur }
    }

    Connections {
        target: backend

        function onError (errormsg) {
            
            if (errormsg == true) {
                error = true
            }
            else
                error = false
        }
    }
}