// DM July 2024
// Speedometer
    
import QtQuick 2.15
import QtQuick.Shapes 1.15

Item {

    id: speedometer

    property int textSize: 160
    property int timerCount: 0
    property int borderOffset: 100

    // Draw background gradient
    Shape {

        x: parent.height/2
        y: parent.height/2

        ShapePath {

            strokeColor: "transparent"   
            strokeWidth: 6

            fillGradient: RadialGradient {
                centerX: 0; centerY: 0
                centerRadius: 360
                focalX: centerX; focalY: centerY
                GradientStop { position: 0; color: "black"; NumberAnimation on position { to: 0.7; easing.type: Easing.InOutQuad; duration: animationDur }}
                GradientStop { position: 0; color: settings.color4; NumberAnimation on position { to: .95; easing.type: Easing.InOutQuad; duration: animationDur }}
                GradientStop { position: 0; color: "black"; NumberAnimation on position { to: 1.5; easing.type: Easing.InOutQuad; duration: animationDur }}
            }

            PathAngleArc {
                centerX: 0; centerY: 0
                radiusX: 360; radiusY: 360;
                startAngle: 0
                sweepAngle: 360
            }
        } 
    }

    // Gauge border
    Repeater {

        id: borderRepeater

        model: (maxMPH/10)*5

        Rectangle {
            x: parent.width/2 - arcWidth/4
            y: -borderOffset
            width: arcWidth/2
            height: arcWidth
            radius: 180
            color: (speed/10*5 >= index) ? settings.color1 : "#B4B4B4"

            property int transY: parent.width/2 + borderOffset

            transform: Rotation { origin.x: arcWidth/4; origin.y: transY; angle: index*(270/(maxMPH/10*5))-135 } 

            // Startup animation
            NumberAnimation on y { to: y + borderOffset; easing.type: Easing.InOutQuad; duration: animationDur }
            NumberAnimation on transY { to: transY - borderOffset; easing.type: Easing.InOutQuad; duration: animationDur }
        }
    }

    // MPH markers
    Repeater {

        id: markerRepeater

        model: maxMPH/10+1

        Rectangle {
            x: parent.width/2 - arcWidth/2
            y: -borderOffset
            width: arcWidth
            height: arcWidth*2
            radius: 180
            color: (speed/10 >= index) ? settings.color1 : "white"

            property int transY: parent.width/2 + borderOffset

            transform: Rotation { origin.x: arcWidth/2; origin.y: transY; angle: index*(270/(maxMPH/10))-135 } 

            Behavior on y { NumberAnimation { duration: 300 } }
            Behavior on transY { NumberAnimation { duration: 300 } }
        }
    }
    
    // MPH border text
    Repeater {

        id: textRepeater

        model: maxMPH/10+1

        Item {
            x: parent.height/2 + Math.round((parent.width/2*.76)*Math.cos((index*(270/(maxMPH/10))+135)* Math.PI / 180))
            y: parent.height/2 + Math.round((parent.width/2*.82)*Math.sin((index*(270/(maxMPH/10))+135)* Math.PI / 180))

            visible: false
            
            Text {
                anchors.centerIn: parent
                text: (index)*10
                rightPadding: 15
                font.pixelSize: 60
                font.bold: true
                font.italic: true
                color: "white"
            }
        }
    }

    // MPH needle
    Rectangle {
        x: parent.width/2-arcWidth/2
        y: parent.height/2-arcWidth/2 + 1000
        width: arcWidth
        height: parent.width/2*.92
        radius: 180
        color: "red"

        transform: Rotation { origin.x: arcWidth/2; origin.y: arcWidth/2; angle: 45 + 270/maxMPH*speed; Behavior on angle { enabled: enableAnimation; SmoothedAnimation { velocity: 1; duration: 500 } }}

        NumberAnimation on y { to: speedometer.width/2 - arcWidth/2; easing.type: Easing.InOutQuad; duration: animationDur }

    }

    Rectangle {
        x: parent.width/2-37.5
        y: parent.width/2-37.5 + 1000
        width: 75
        height: 75
        radius: 180
        color: "#B4B4B4"

        NumberAnimation on y { to: speedometer.width/2-37.5; easing.type: Easing.InOutQuad; duration: animationDur }
    }

    // MPH text
    Item {

        width: parent.width
        height: parent.height
        y: 1000

        Text {
            id: mph
            y: parent.width*(.66)
            anchors.horizontalCenter: parent.horizontalCenter
            text: speed
            font.pixelSize: textSize
            font.bold: true
            font.italic: true
            color: "white"
        }
        Text {
            anchors.left: mph.right
            anchors.bottom: mph.bottom
            anchors.bottomMargin: 33
            text: "MPH"
            font.pixelSize: 40
            font.bold: true
            font.italic: true
            color: "red"
        }

        NumberAnimation on y { to: y; easing.type: Easing.InOutQuad; duration: animationDur }
    }

    //                                     STARTUP SEQUENCE 

    // Animate items in repeater for startup animation
    Timer {
        id: startupTimer
        interval: 75
        running: true
        repeat: true
        onTriggered: {
            var element1 = textRepeater.itemAt(timerCount);
            var element2 = markerRepeater.itemAt(timerCount);
            element1.visible = "true";
            element2.y = element2.y + borderOffset
            element2.transY = element2.transY - borderOffset
            timerCount = timerCount + 1;
            if (timerCount == maxMPH/10+1) {
                startupTimer.stop()
                delayTimer.start()
                timerCount = 0
            }
        }
    }

    // Wait for previous animations to complete before gauge sweep
    Timer {
        id: delayTimer
        interval: 1000
        running: false
        repeat: false
    }

    // Gauge sweep because it looks cool :)
    SequentialAnimation {
        running: !(startupTimer.running || delayTimer.running)
        ParallelAnimation {
            NumberAnimation { target: main; property: "speed"; easing.type: Easing.InOutQuad; to: maxMPH; duration: 1000 }
            NumberAnimation { target: main; property: "rpm"; easing.type: Easing.InOutQuad; to: maxRPM; duration: 1000 }
            NumberAnimation { target: main; property: "temp"; easing.type: Easing.InOutQuad; to: maxTemp; duration: 1000 }
            NumberAnimation { target: main; property: "battery"; easing.type: Easing.InOutQuad; to: maxBatt; duration: 1000 }
        }
        ParallelAnimation {
            NumberAnimation { target: main; property: "speed"; easing.type: Easing.InOutQuad; to: 0; duration: 1000 }
            NumberAnimation { target: main; property: "rpm"; easing.type: Easing.InOutQuad; to: 0; duration: 1000 }
            NumberAnimation { target: main; property: "temp"; easing.type: Easing.InOutQuad; to: 0; duration: 1000 }
            NumberAnimation { target: main; property: "battery"; easing.type: Easing.InOutQuad; to: minBatt; duration: 1000 }
        }
        onFinished: {
            console.log("Starting animation complete")
            enableMask = false
            enableAnimation = true
        }
    }

    //                                       Testing stuff
    states: [
        State {
            name: "errorState"
            PropertyChanges { target: errorIcon; visible: true }
        },
        State {
            name: "clicked"
            PropertyChanges { target: main; speed: maxMPH }
            PropertyChanges { target: main; rpm: maxRPM }
            PropertyChanges { target: main; temp: maxTemp }
            PropertyChanges { target: main; battery: maxBatt }
        },
        State {
            name: "clicked2"
            PropertyChanges { target: main; speed: 60 }
            PropertyChanges { target: main; rpm: 7000 }
            PropertyChanges { target: main; temp: 200 }
            PropertyChanges { target: main; battery: 14.3 }
        }
    ]

    Rectangle {
        width: 80
        height: 80
        color: "grey"

        visible: false

        MouseArea {
            anchors.fill: parent
            onClicked: {
                speedometer.state == 'clicked' ? speedometer.state = "" : speedometer.state = 'clicked';
                defaultDash.state == 'unloaded' ? defaultDash.state = "" : defaultDash.state = 'unloaded';
                console.log("Clicked")
            }
        }
    }

    Rectangle {
        x: 0
        y: 640
        width: 80
        height: 80

        visible: true

        color: "grey"

        MouseArea {
            anchors.fill: parent
            onClicked: {
                speedometer.state == 'clicked2' ? speedometer.state = "" : speedometer.state = 'clicked2';
                console.log("Clicked2")
            }
        }
    }
}
