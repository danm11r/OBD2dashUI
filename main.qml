// Daniel Miller July 2024
// dashUI

import Qt.labs.settings 1.0
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Shapes 1.15
import QtGraphicalEffects 1.12


import "./qml"
import "./default_dash"
import "./simple_dash"

ApplicationWindow {
    id: main
    visible: true
    width: 1600
    height: 720

    title: "dashUI"
    color: "black"

    // Signal properties
    property QtObject backend
    property int speed: 0
    property int rpm: 0
    property int temp: 0
    property double battery: 10

    property int maxMPH: 120 
    property int maxRPM: 8000
    property int redLine: 6500 
    property int maxTemp: 400
    property int maxBatt: 16
    property int minBatt: 10

    // Color themes
    property variant color1Array: ["#50C878", "#15F4EE", "#F21894", "#A817E6"] // 90%
    property variant color2Array: ["#3C965A", "#11BFB9", "#BF1375", "#8C13BF"] // 75%
    property variant color3Array: ["#29663D", "#0E9994", "#990F5D", "#700F99"] // 60%
    property variant color4Array: ["#112919", "#042928", "#33051F", "#250533"] // 20%

    Settings {
        id: settings

        // Global color values. Overridden when theme selected from settings page
        property string color1: "#50C878"
        property string color2: "#3C965A"
        property string color3: "#29663D"
        property string color4: "#112919"
        property string accent: "#CE2029"
        property string bgcolor: "#2A2A2A"   
        property int selectedThemeIndex: 0
        property int currentBrightness: 0
    }

    property int arcWidth: 16
    property string errorText: "OBD2 Connection Failed!"

    SwipeView {
        id: mainView
        anchors.fill: parent

        property alias loaderItem1: loader1.item
        property alias loaderItem2: loader2.item

        currentIndex: 0

        Loader {
            active: true
            id: loader1
            sourceComponent: DefaultDash{}
        }

        Loader {
            active: false
            id: loader2
            sourceComponent: SimpleDash{}
        }

        onCurrentIndexChanged: {
            if (currentIndex == 0) {
                loader1.active = true
                loaderItem1.state = 'loaded'
                loaderItem2.state = 'unloaded'
            }
            else if (currentIndex == 1) {
                loader2.active = true
                loaderItem2.state = 'loaded'
                loaderItem1.state = 'unloaded'
            }
        }
    }

    MenuOverlay{}

    // Error message dialog
    Dialog {
        id: errorMsg
        
        anchors.centerIn: parent
        height: 540
        width: 540

        dim: true

        header: ToolBar {
            Rectangle {
                y: 50
                height: 50
                width: 540
                color: settings.color2
            }
            Label {
                text: "Error"
                color: "white"
                font.pixelSize: 54
                anchors.centerIn: parent
            }
            background: Rectangle {

                implicitHeight: 100
                color: settings.color2
                radius: 90
            }
        }

        background: Rectangle {
            color: "#2A2A2A"
            border.color: settings.color2
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
                color: settings.color2
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
                color: settings.color2
                radius: 45
            }

            DialogButtonBox.buttonRole: DialogButtonBox.AcceptRole
            onClicked: {
                backend.retry_connection()
                errorMsg.accept()
            }
        }
    }

    Connections {
        target: backend

        function onData (msg, msg2, msg3, msg4) {
            speed = msg
            rpm = msg2
            temp = msg3
            battery = msg4
        }

        function onError (errormsg) {
            
            if (errormsg == true) {
                errorMsg.open()
            }
        }
    }
}