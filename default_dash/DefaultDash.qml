// DM July 2024
// Default dash
    
import QtQuick 2.15
import QtQuick.Shapes 1.15
import QtQuick.Controls 2.15

Item {

    id: defaultDash

    anchors.fill: parent

    property bool enableMask: true
    property bool enableAnimation: false
    property int animationDur: 2000

    Speedometer{width: 720; height: 720 }
    Tachometer{x: parent.width - 720; width: 720; height: 720}

    // Mask off the area beyond the gauges only during the startup animation
    Loader {

        active: true // Currently set to true to resolve issue with menu overlay transparency
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

    TempGauge { x: parent.width/2; y: .8*parent.height }
    Clock{ x: parent.width/2; y: .2*parent.height}

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
                defaultDash.state = "errorState"
            }
            else
                defaultDash.state = ""
        }
    }
}