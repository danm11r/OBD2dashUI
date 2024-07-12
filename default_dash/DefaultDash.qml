// DM July 2024
// Default dash
    
import QtQuick 2.15
import QtQuick.Shapes 1.15

Item {

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
}