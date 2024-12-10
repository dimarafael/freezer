import QtQuick
import QtQuick.VirtualKeyboard
import Qt5Compat.GraphicalEffects
import com.kometa.ProcessModel

Item{
    id: root
    property int defMargin: 5
    property string prodName: ""
    property color textColor: "#04109B"
    property string timer: "00:00"
    property color colorGrad1 : "#75B5FF"
    property color colorGrad2 : "#3E95F9"
    property real value: 0
    property string posNum: ""
    
    Rectangle{
        id: rectBase
        anchors.fill: parent
        anchors.margins: window.defMargin / 2
        radius: root.defMargin
        color: root.textColor
    }
    RadialGradient { // blue
        id: gradientBlue
        property real gradShift: 0.0
        anchors.fill: rectBase
        source: rectBase
        gradient: Gradient {
            GradientStop { position: 0; color: root.colorGrad1 }
            GradientStop { position: 0.5; color: root.colorGrad2 }
        }
    }
    
    Item{
        id: itemPositionNumber
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.margins: root.defMargin
        height: parent.height / 10
        width: height
        
        Text{
            id: textPositionNumber
            anchors.verticalCenter: parent.verticalCenter
            font.pixelSize: parent.height
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
            color: root.textColor
            text: root.posNum
        }
    }
    
    Item {
        id: itemTemperature
        height: parent.height / 10
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.margins: root.defMargin
        Text {
            id: textTemperature
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.right: parent.right
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignRight
            font.pixelSize: parent.height
            color: root.textColor
            text: temperature.toFixed(1) + " °C"
        }
    }
    
    Item {
        id: itemProductName
        height: (root.height - radialBar.height ) / 2
        // width: parent.width
        anchors.bottom: radialBar.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.leftMargin: root.defMargin
        anchors.rightMargin: root.defMargin
        clip: true
        
        Text {
            id: textProductName
            anchors.verticalCenter: parent.verticalCenter
            height: parent.height
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignLeft
            font.pixelSize: root.height / 10
            color: root.textColor
            text: root.prodName
        }
        
    }
    
    RadialBarShape {
        id: radialBar
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: root.defMargin * 2
        height: parent.width - root.defMargin * 4
        progressColor: root.textColor
        dialColor: "#7F7F7F"
        value: root.value
        dialType: RadialBarShape.DialType.FullDial
        backgroundColor: "transparent"
        dialWidth: width / 7
        
        Text{
            anchors.centerIn: parent
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            color: root.textColor
            font.pixelSize: parent.width / 4
            text: root.timer
        }
    }
}
