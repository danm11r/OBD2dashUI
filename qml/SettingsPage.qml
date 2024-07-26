// DM July 2024
// 
// Settings page. Most of this code came from ClockUI... 

import QtQuick 2.15
import QtQuick.Shapes 1.15

Item {

    id: settingsPage

    width: 720
    height: 640
    
    property int buttonSize: 100
    property int buttonGap: 25

    property int arcWidth: 16
    
    // Draw background rectangle
    Rectangle {
        anchors.fill: parent
        color: "#2A2A2A"
        border.color: settings.color2
        border.width: arcWidth
        radius: 45
    }

    Rectangle {
        y: 50
        height: 50
        width: parent.width
        color: settings.color2
    }

    // Title bar with settings text
    Rectangle {
        height: 100
        width: 720
        color: settings.color2
        radius: 90

        Text {
            text: "Settings"
            color: "white"
            font.pixelSize: 54
            anchors.centerIn: parent
        }
    }

    // Use repeater to create theme color selection buttons
    Row {

        anchors.horizontalCenter: parent.horizontalCenter

        spacing: buttonGap

        Repeater{

            id: colorButtonRepeater
            model: color1Array.length

            Item {

                id: colorButton

                x: 200
                y: settingsPage.height/2-buttonSize/2
                state: (settings.selectedThemeIndex == index) ? 'clicked' : '' // Set button for selected theme to clicked state

                width: buttonSize
                height: buttonSize

                // When a button is selected reset all other buttons 
                function resetButtons() {
                    for (var i = 0; i < color1Array.length; i++) {
                        if (i != index) {
                            colorButtonRepeater.itemAt(i).state = 'unclicked'
                        }
                    }
                }

                Rectangle {
                    id: rect5
                    width: buttonSize; height: buttonSize
                    color: color3Array[index]
                    radius: 180
                }


                Rectangle {
                    id: rect4
                    y: buttonSize/2
                    width: buttonSize; height: 0
                    color: color3Array[index]
                }


                Rectangle {
                    id: rect3
                    width: buttonSize; height: buttonSize
                    color: color2Array[index]
                    radius: 180
                }

                Rectangle {
                    id: rect2
                    y: buttonSize/2
                    width: buttonSize; height: 0
                    color: color1Array[index]
                }

                Rectangle {
                    id: rect1
                    width: buttonSize; height: buttonSize
                    color: color1Array[index]
                    radius: 180
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: { 
                        colorButton.state = 'clicked'
                        resetButtons()
                        settings.selectedThemeIndex = index
                        settings.color1 = color1Array[index]
                        settings.color2 = color2Array[index]
                        settings.color3 = color3Array[index]
                        settings.color4 = color4Array[index]
                    }
                }

                states: [
                    State {
                        name: "clicked"
                        PropertyChanges { target: rect1; y: -buttonSize }
                        PropertyChanges { target: rect2; height: buttonSize/2; y: -buttonSize/2}
                        PropertyChanges { target: rect3; radius: 0 }
                        PropertyChanges { target: rect4; height: buttonSize/2; y: buttonSize}
                        PropertyChanges { target: rect5; y: buttonSize; }
                    }
                ]

                transitions: Transition {
                    NumberAnimation { target: rect1; property: "y"; easing.type: Easing.InOutQuad; duration: animationDur }
                    NumberAnimation { target: rect2; property: "height"; easing.type: Easing.InOutQuad; duration: animationDur }
                    NumberAnimation { target: rect2; property: "y"; easing.type: Easing.InOutQuad; duration: animationDur }
                    NumberAnimation { target: rect3; property: "radius"; easing.type: Easing.InOutQuad; duration: animationDur }
                    NumberAnimation { target: rect4; property: "height"; easing.type: Easing.InOutQuad; duration: animationDur }
                    NumberAnimation { target: rect4; property: "y"; easing.type: Easing.InOutQuad; duration: animationDur }
                    NumberAnimation { target: rect5; property: "y"; easing.type: Easing.InOutQuad; duration: animationDur }
                }
            }
        }
    }

    Row {
        
        anchors.horizontalCenter: parent.horizontalCenter
        y: 490

        Text {
            text: "Brightness: "
            color: "white"
            font.pixelSize: 54
        }

        CustomSwitch{ height: 100; width: 200 }
    }
}
