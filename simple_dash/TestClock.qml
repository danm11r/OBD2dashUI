// DM Aug 2024
// Copied from clockUI to test out clock designs for simple dashs

import QtQuick 2.15
import QtQuick.Shapes 1.15

Item {

    id: analogClock

    width: parent.height
    height: parent.height

    property string hour
    property string minute
    property int textSize: 80
    property int clockRadius: height/2
    property var time: {'hour': 0, 'minute': 0, 'second': 0, 'hour_text': "0", 'minute_text': "0", 'PM': false } // This shares the same name as the signal and should probably be changed to something else
    property var currDate: {'day': "-", 'date': 0, 'totalDays': 0 }

    Item {
        id: timeText

        x: 360
        y: 500
        
        Text {
            anchors.centerIn: parent
            text: time.hour_text + ":" + time.minute_text
            font.pixelSize: textSize
            font.bold: true
            color: settings.color3
        }

        states: [
            State {
                name: "moved"
                PropertyChanges {target: timeText; x: 500; y: 360}
            }
        ]
    }

    Item {
        id: dateText

        x: 360
        y: 220

        Text {
            anchors.centerIn: parent
            text: currDate.day.toUpperCase() + currDate.date
            font.pixelSize: textSize
            font.bold: true
            color: settings.color3
        }

        states: [
            State {
                name: "moved"
                PropertyChanges {target: dateText; x: 220; y: 360}
            }
        ]
    }

    Item {

        anchors.fill: parent

        // border
        Repeater {

            model: 60

            Rectangle {
                x: clockRadius - arcWidth/2
                y: 0
                width: arcWidth
                height: arcWidth
                radius: 180
                color: "#B4B4B4"
                transform: Rotation { origin.x: arcWidth/2; origin.y: clockRadius; angle: index*6 } 
            }
        }

        // hour marks
        Repeater {

            model: 12

            Rectangle {
                x: clockRadius - arcWidth/2
                y: 0
                width: arcWidth
                height: arcWidth*2
                radius: 180
                color: "white"
                transform: Rotation { origin.x: arcWidth/2; origin.y: clockRadius; angle: index*30 } 
            }
        }

        // hour text
        Repeater {

            model: 12

            Item {
                x: parent.height/2 + Math.round(clockRadius*0.81*Math.cos((index*30-60)* Math.PI / 180))
                y: parent.height/2 + Math.round(clockRadius*0.81*Math.sin((index*30-60)* Math.PI / 180))
                
                Text {
                    anchors.centerIn: parent
                    text: index+1
                    font.pixelSize: 60
                    font.bold: true
                    color: "white"
                }
            }
        }

        // minute hand
        Rectangle {
            x: clockRadius-arcWidth/4
            y: clockRadius-arcWidth/4
            width: arcWidth/2
            height: 65
            radius: 180
            color: settings.color1

            transform: Rotation { origin.x: arcWidth/4; origin.y: arcWidth/4; angle: time.minute*6 + 180 } 
        }

        Rectangle {
            x: clockRadius-arcWidth
            y: clockRadius-arcWidth + 65
            width: arcWidth*2
            height: clockRadius-80
            radius: 180
            color: settings.color1

            transform: Rotation { origin.x: arcWidth; origin.y: arcWidth-65; angle: time.minute*6 + 180 } 
        }

        // hour hand
        Rectangle {
            x: clockRadius-arcWidth
            y: clockRadius-arcWidth + 65
            width: arcWidth*2
            height: clockRadius-220
            radius: 180
            color: settings.color2

            transform: Rotation { origin.x: arcWidth; origin.y: arcWidth-65; angle: time.hour*30 + 180 } 
        }

        Rectangle {
            x: clockRadius-arcWidth/4
            y: clockRadius-arcWidth/4
            width: arcWidth/2
            height: 65
            radius: 180
            color: settings.color2

            transform: Rotation { origin.x: arcWidth/4; origin.y: arcWidth/4; angle: time.hour*30 + 180 } 
        }

        // second hand
        Rectangle {
            x: clockRadius-arcWidth/4
            y: clockRadius-arcWidth/4
            width: arcWidth/2
            height: clockRadius
            radius: 180
            color: settings.accent

            transform: Rotation { origin.x: arcWidth/4; origin.y: arcWidth/4; angle: time.second*6 + 180 } 
        }

        Rectangle {
            anchors.centerIn: parent
            color: settings.accent
            height: 30
            width: 30
            radius: 180
        }
    }

    Connections {
        target: backend

        function onTime (hour, minute, second, hour_text, minute_text, PM) {
            time = {'hour': hour, 'minute': minute, 'second': second, 'hour_text': hour_text, 'minute_text': minute_text, 'PM': PM};
        
            if ((time.hour >= 4 && time.hour <= 8) || time.hour >= 10 || time.hour <= 2) {
                timeText.state = "moved"
                dateText.state = "moved"
            }
            else {
                timeText.state = ""
                dateText.state = ""
            }
        }

        function onDate (day, date, totalDays) {
            currDate = {'day': day, 'date': date, 'totalDays': totalDays}
        }
    }
}