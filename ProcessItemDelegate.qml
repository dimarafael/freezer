import QtQuick
import QtQuick.VirtualKeyboard
import Qt5Compat.GraphicalEffects
import com.kometa.ProcessModel

Item{
    id: root
    property int defMargin: 5
    property color shadowColor: "#88000000"

    function getElapsedTime(cur, targ){
        var elapsed
        if (targ >= cur){
            elapsed = targ - cur;
        } else {
            elapsed = 0;
        }
        var hours = Math.floor(elapsed / 60);
        var minutes = elapsed % 60;

        hours = String(hours).padStart(2, '0')
        minutes = String(minutes).padStart(2, '0')

        return hours + ":" + minutes
    }

    function getPositionNumber(idx){
        var line = Math.floor(idx/9);
        if (line === 0){
            return "A" + ((idx % 9) + 1)
        } else if(line === 1){
            return "B" + ((idx % 9) + 1)
        } else  {
            return "1" + (idx % 9)
        }
    }

    MouseArea{
        anchors.fill: parent
        onClicked: {
            focus: true
            console.log("Delegate clicked " + (index+1).toString())
        }
    }
    DropShadow {
        anchors.fill: rect1
        source: rect1
        horizontalOffset: root.defMargin / 2
        verticalOffset: root.defMargin / 2
        radius: 3.0
        samples: 17
        color: root.shadowColor
        opacity: 0.8
    }
    Rectangle{
        id: rect1
        anchors.fill: parent
        anchors.margins: root.defMargin / 2
        radius: root.defMargin
        border.color: "#7F7F7F"
        border.width: stage > 0 ? 0:1
        color: Qt.lighter( "#7F7F7F" )
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
            color: "#416f4c"
            text: root.getPositionNumber(index)
        }
    }

    StatusCard {
        id: itemStatusCooling
        anchors.fill: parent
        defMargin: root.defMargin
        visible: stage === 1
        prodName: productName
        textColor: "#04109B"
        timer: getElapsedTime(minutesCurrent, minutesMin)
        colorGrad1 : "#75B5FF"
        colorGrad2 : "#3E95F9"
        value: (minutesCurrent / minutesMin) * 100
        posNum: root.getPositionNumber(index)
    }

    StatusCard {
        id: itemStatusReady
        anchors.fill: parent
        defMargin: root.defMargin
        visible: stage === 2
        prodName: productName
        textColor: "white" //"#3a5641"
        timer: getElapsedTime(minutesCurrent , minutesMax)
        colorGrad1 : "#61B94A"
        colorGrad2 : "#3E9149"
        value: ((minutesCurrent - minutesMin) / (minutesMax - minutesMin)) * 100
        posNum: root.getPositionNumber(index)
    }

    StatusCard {
        id: itemStatusOvercool
        anchors.fill: parent
        defMargin: root.defMargin
        visible: stage === 3
        prodName: productName
        textColor: "white" //"#ce253c"
        timer: getElapsedTime(minutesMax , minutesCurrent)
        colorGrad1 : "#CA7154"
        colorGrad2 : "#EE2F37"
        value: 100
        posNum: root.getPositionNumber(index)
    }
}
