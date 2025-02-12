import QtQuick
import QtQuick.VirtualKeyboard
import Qt5Compat.GraphicalEffects
import com.kometa.ProcessModel

Rectangle{
    id: root
    width: 200
    height: 200
    color: "white"

    property int fontSize: 30
    property int buttonWidth: 50

    onVisibleChanged: {
        if(visible === true) {
            setpointCartWeight.text = Math.round(ProcessModel.weightCart * 10) / 10
            setpointCrateWeight.text = Math.round(ProcessModel.weightCrate * 10) / 10
            setpointSensorCorrection.text = Math.round(ProcessModel.sensorCorrection * 10) / 10
        }
    }

    Text{
        id: txtLine1
        width: parent.width
        height: parent.height / 4
        anchors.top: parent.top
        verticalAlignment: Text.AlignBottom
        horizontalAlignment: Text.AlignHCenter
        color: "#416f4c"
        font.pixelSize: root.fontSize * 2
        text: "Parameters"
    }

    Rectangle{
        id: rectLine1
        width: parent.width * 0.9
        height: 1
        anchors.bottom: txtLine1.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        color: "lightgrey"
        border.width: 0
    }

    Item{
        id: itemLine2Left
        width: parent.width / 2
        height: parent.height / 4
        anchors.top: txtLine1.bottom
        anchors.left: parent.left

        Text{
            id: txtLine2Left
            width: parent.width
            height: parent.height / 3
            anchors.top: parent.top
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            color: "black"
            font.pixelSize: root.fontSize
            text: "Cart weight"
        }

        SetpointField{
            id: setpointCartWeight
            anchors.top: txtLine2Left.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width / 2
            height: root.fontSize * 1.8
            minVal: 1
            maxVal: 999
            units: "kg"
        }
    }

    Item{
        id: itemLine2Right
        width: parent.width / 2
        height: parent.height / 4
        anchors.top: txtLine1.bottom
        anchors.right: parent.right

        Text{
            id: txtLine2Right
            width: parent.width
            height: parent.height / 3
            anchors.top: parent.top
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            color: "black"
            font.pixelSize: root.fontSize
            text: "Tray weight"
        }

        SetpointField{
            id: setpointCrateWeight
            anchors.top: txtLine2Right.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width / 2
            height: root.fontSize * 1.8
            minVal: 1
            maxVal: 999
            units: "kg"
        }

    }

    Rectangle{
        id: rectLine2
        width: parent.width * 0.9
        height: 1
        anchors.bottom: itemLine2Left.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        color: "lightgrey"
        border.width: 0
    }

    Item{
        id: itemLine3Left
        width: parent.width / 2
        height: parent.height / 4
        anchors.top: itemLine2Left.bottom
        anchors.left: parent.left

        Text{
            id: txtLine3Left
            width: parent.width
            height: parent.height / 3
            anchors.top: parent.top
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            color: "black"
            font.pixelSize: root.fontSize
            text: "Sensor correction"
        }

        SetpointField{
            id: setpointSensorCorrection
            anchors.top: txtLine3Left.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width / 2
            height: root.fontSize * 1.8
            minVal: -5
            maxVal: +5
            units: "°C"
            inputMethodHints: Qt.ImhFormattedNumbersOnly | Qt.ImhNoTextHandles
        }
    }

    Rectangle{
        id: rectLine3
        width: parent.width * 0.9
        height: 1
        anchors.bottom: itemLine3Left.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        color: "lightgrey"
        border.width: 0
    }

    Item {
        id: itemLineButtons
        height: parent.height / 4
        width: parent.width * 0.85
        anchors.top: itemLine3Left.bottom
        anchors.horizontalCenter: parent.horizontalCenter

        Rectangle{
            id: btnCancel
            height: root.buttonWidth * 0.3
            width: root.buttonWidth
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            color: mouseAreaCancelBtn.pressed? "red":"#d83324"
            radius: height / 2
            Text{
                anchors.centerIn: parent
                font.pixelSize: root.fontSize
                color: "white"
                text: "Cancel"
            }

            MouseArea{
                id: mouseAreaCancelBtn
                anchors.fill: parent
                onClicked: {
                    root.visible = false
                }
            }
        }

        Rectangle{
            id: btnOK
            height: root.buttonWidth * 0.3
            width: root.buttonWidth
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            color: mouseAreaOkBtn.pressed? "green":"#416f4c"
            radius: height / 2
            Text{
                anchors.centerIn: parent
                font.pixelSize: root.fontSize
                color: "white"
                text: "OK"
            }

            MouseArea{
                id: mouseAreaOkBtn
                anchors.fill: parent
                onClicked: {
                    ProcessModel.weightCart = parseFloat(setpointCartWeight.text)
                    ProcessModel.weightCrate = parseFloat(setpointCrateWeight.text)
                    ProcessModel.sensorCorrection = parseFloat(setpointSensorCorrection.text)
                    root.visible = false
                }
            }
        }
    }

}
