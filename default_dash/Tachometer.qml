// DM July 2024
// Tachometer
    
import QtQuick 2.15
import QtQuick.Shapes 1.15

Item {

    id: tachometer

    property int textSize: 120
    property int timerCount: 0
    property int borderOffset: 100
    property int animationDur: 2000
    property bool animation: false

    // Gauge border
    Repeater {

        id: borderRepeater

        model: (maxRPM/1000)*6

        Rectangle {
            x: parent.width/2 - arcWidth/4
            y: -borderOffset
            width: arcWidth/2
            height: arcWidth
            radius: 180
            color: (rpm/1000*6 >= index && index/6*1000 >= redLine) ? "red" : (rpm/1000*6 >= index) ? "#50C878" : ((index/6)*1000 >= redLine) ? "#CE2029" : "#B4B4B4"            // color: (rpm/1000*6 >= index) ? "#50C878" : ((index/6)*1000 >= redLine) ? "#CE2029" : "#B4B4B4"

            property int transY: parent.width/2 + borderOffset

            transform: Rotation { origin.x: arcWidth/4; origin.y: transY; angle: index*(270/(maxRPM/1000*6))-135 } 

            // Startup animation
            NumberAnimation on y { to: y + borderOffset; easing.type: Easing.InOutQuad; duration: animationDur }
            NumberAnimation on transY { to: transY - borderOffset; easing.type: Easing.InOutQuad; duration: animationDur }
        }
    }

    // RPM markers
    Repeater {

        id: markerRepeater

        model: (maxRPM/1000)+1

        Rectangle {
            x: parent.width/2 - arcWidth/2
            y: -borderOffset
            width: arcWidth
            height: arcWidth*2
            radius: 180
            color: (rpm/1000 >= index && index*1000 >= redLine) ? "red" : (rpm/1000 >= index) ? "#50C878" : ((index)*1000 >= redLine) ? "#CE2029" : "white"

            property int transY: parent.width/2 + borderOffset

            transform: Rotation { origin.x: arcWidth/2; origin.y: transY; angle: index*(270/(maxRPM/1000))-135 } 
            Behavior on y { NumberAnimation { duration: 300 } }
            Behavior on transY { NumberAnimation { duration: 300 } }
        }
    }
    
    // RPM text
    Repeater {

        id: textRepeater

        model: maxRPM/1000+1

        Item {
            x: parent.height/2 + Math.round((parent.width/2*.78)*Math.cos((index*(270/(maxRPM/1000))+135)* Math.PI / 180))
            y: parent.height/2 + Math.round((parent.width/2*.82)*Math.sin((index*(270/(maxRPM/1000))+135)* Math.PI / 180))

            visible: false
            
            Text {
                anchors.centerIn: parent
                text: index
                font.pixelSize: 60
                font.bold: true
                font.italic: true
                color: "white"
            }
        }
    }

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
            if (timerCount == maxRPM/1000+1) {
                startupTimer.stop()
                delayTimer.start()
                timerCount = 0
            }
        }
    }

    // RPM needle
    Rectangle {
        x: parent.width/2-arcWidth/2
        y: parent.height/2-arcWidth/2 + 1000
        width: arcWidth
        height: parent.width/2*.92
        radius: 180
        color: "red"

        transform: Rotation { origin.x: arcWidth/2; origin.y: arcWidth/2; angle: 45 + 270/maxRPM*rpm; Behavior on angle { enabled: enableAnimation; SmoothedAnimation { velocity: 1; duration: 500 } }}

        NumberAnimation on y { to: tachometer.width/2 - arcWidth/2; easing.type: Easing.InOutQuad; duration: animationDur }

    }

    Rectangle {
        x: parent.width/2-37.5
        y: parent.width/2-37.5 + 1000
        width: 75
        height: 75
        radius: 180
        color: "#B4B4B4"

        NumberAnimation on y { to: tachometer.width/2-37.5; easing.type: Easing.InOutQuad; duration: animationDur }
    }

    Item {

        width: parent.width
        height: parent.height
        y: 1000

        Text {
            id: mph
            y: parent.width*(.72)
            anchors.horizontalCenter: parent.horizontalCenter
            text: rpm
            font.pixelSize: textSize
            font.bold: true
            font.italic: true
            color: "white"
        }
        Text {
            anchors.left: mph.right
            anchors.bottom: mph.bottom
            anchors.bottomMargin: 24
            text: "RPM"
            font.pixelSize: 40
            font.bold: true
            font.italic: true
            color: "red"
        }

        NumberAnimation on y { to: y; easing.type: Easing.InOutQuad; duration: animationDur }
    }

    // Wait for previous animations to complete before gauge sweep
    Timer {
        id: delayTimer
        interval: 1000
        running: false
        repeat: false
    }
}
