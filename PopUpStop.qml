import QtQuick
import QtQuick.VirtualKeyboard
import Qt5Compat.GraphicalEffects
import com.kometa.ProcessModel

import QtQuick.Controls

Rectangle{
    id: popUpStop
    width: 200
    height: 200
    color: "white"
    property int index: 0
    property int buttonWidth: 50
    property int fontSize: 30

    signal stop(int index)

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

    Text{
        id: txtPopUpStopLine1
        width: parent.width
        height: parent.height / 4
        anchors.top: parent.top
        verticalAlignment: Text.AlignBottom
        horizontalAlignment: Text.AlignHCenter
        color: "#416f4c"
        font.pixelSize: popUpStop.fontSize * 2
        text: "Stop?"
    }
    Text{
        id: txtPopUpStopLine2
        width: parent.width
        height: parent.height / 4
        anchors.top: txtPopUpStopLine1.bottom
        verticalAlignment: Text.AlignTop
        horizontalAlignment: Text.AlignHCenter
        color: "#416f4c"
        font.pixelSize: popUpStop.fontSize * 2
        text: "Place " + getPositionNumber(popUpStop.index)
    }

    Item {
        id: itemPopUpStopLine3
        height: parent.height / 2
        width: parent.width * 0.85
        anchors.top: txtPopUpStopLine2.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        Rectangle{
            id: btnPopUpStopCancel
            height: popUpStop.buttonWidth * 0.3
            width: popUpStop.buttonWidth
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            color: mouseAreaStopCancel.pressed? "red":"#d83324"
            radius: height / 2
            Text{
                anchors.centerIn: parent
                font.pixelSize: popUpStop.fontSize
                color: "white"
                text: "CANCEL"
            }

            MouseArea{
                id: mouseAreaStopCancel
                anchors.fill: parent
                onClicked: {
                    popUpStop.visible = false
                }
            }
        }

        Rectangle{
            id: btnPopUpStopOk
            height: popUpStop.buttonWidth * 0.3
            width: popUpStop.buttonWidth
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            color: mouseAreaStopOk.pressed? "green":"#416f4c"
            radius: height / 2
            Text{
                anchors.centerIn: parent
                font.pixelSize: popUpStop.fontSize
                color: "white"
                text: "STOP"
            }
            MouseArea{
                id: mouseAreaStopOk
                anchors.fill: parent
                onClicked: {
                    popUpStop.stop(popUpStop.index)
                    popUpStop.visible = false
                }
            }
        }
    }
}
