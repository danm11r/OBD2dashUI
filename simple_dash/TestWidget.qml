// DM Aug 2024
// Test widget for placement
    
import QtQuick 2.15
import QtQuick.Shapes 1.15

Item {

    width: widgetRadius*2
    height: widgetRadius*2

    // Background
    Rectangle {

        width: parent.width
        height: parent.height
        radius: width/2

        color: settings.color4
    }
}