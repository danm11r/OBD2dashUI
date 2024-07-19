// DM July 2024
// Default dash
    
import QtQuick 2.15
import QtQuick.Shapes 1.15
import QtQuick.Controls 2.15

Item {

    id: defaultDash

    anchors.fill: parent

    property int arcWidth: 16
    property bool enableMask: true
    property bool enableAnimation: false
    property int animationDur: 2000

    Speedometer{width: 720; height: 720}
    Tachometer{x: parent.width - 720; width: 720; height: 720}

    // Mask off the area beyond the gauges only during the startup animation
    Loader {

        active: enableMask
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

    TempGauge {}
    Clock{}

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

    // Error dialog. Should be moved to seperate file
    Dialog {
        id: errorMsg
        
        anchors.centerIn: parent
        height: 540
        width: 540

        header: ToolBar {
            Rectangle {
                y: 50
                height: 50
                width: 540
                color: color2
            }
            Label {
                text: "Error"
                color: "white"
                font.pixelSize: 54
                anchors.centerIn: parent
            }
            background: Rectangle {

                implicitHeight: 100
                color: color2
                radius: 90
            }
        }

        background: Rectangle {
            color: "#2A2A2A"
            border.color: color2
            border.width: arcWidth
            radius: 45
        }

        contentItem: Text {
            width: 540
            wrapMode: Text.WordWrap
            text: errorText
            font.pixelSize: 48
            color: "white"
            leftPadding: 24
            horizontalAlignment: Text.AlignHCenter
        }

        Button {

            id: accentButton
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 24

            contentItem: Text {
                text: "Accept"
                font.pixelSize: 48
                color: "white"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
            
            background: Rectangle {
                implicitHeight: 100
                implicitWidth: 200
                color: color2
                radius: 45
            }

            DialogButtonBox.buttonRole: DialogButtonBox.AcceptRole
            onClicked: errorMsg.accept()
        }

        Button {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: accentButton.top
            anchors.bottomMargin: 24

            contentItem: Text {
                text: "Retry"
                font.pixelSize: 48
                color: "white"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
            
            background: Rectangle {
                implicitHeight: 100
                implicitWidth: 200
                color: color2
                radius: 45
            }

            DialogButtonBox.buttonRole: DialogButtonBox.AcceptRole
            onClicked: {
                backend.retry_connection()
                errorMsg.accept()
            }
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
                errorMsg.open()
            }
            else
                defaultDash.state = ""
        }
    }
}