import QtQuick
import QtQuick.VirtualKeyboard
import Qt5Compat.GraphicalEffects
import com.kometa.ProductsModel
import com.kometa.ProcessModel

import QtQuick.Controls

Rectangle{
    id: root
    width: 200
    height: 200
    color: "white"
    property int index: 0
    property int buttonWidth: 50
    property int fontSize: 30

    signal start(int index, string productName)

    function getTextTime(totalMinutes){
        var hours = Math.floor(totalMinutes / 60);
        var minutes = totalMinutes % 60;

        hours = String(hours).padStart(2, '0')
        minutes = String(minutes).padStart(2, '0')

        return hours + ":" + minutes
    }

    onVisibleChanged: {
        if(visible === true) listProducts.indexSelected = -1
    }

    Text{
        id: txtLine1
        width: parent.width
        height: parent.height / 8
        anchors.top: parent.top
        verticalAlignment: Text.AlignBottom
        horizontalAlignment: Text.AlignHCenter
        color: "#416f4c"
        font.pixelSize: root.fontSize * 2
        text: "Start process on place " + (root.index + 1)
    }

    ListView{
        id: listProducts
        anchors.top: txtLine1.bottom
        anchors.topMargin: parent.height / 100
        anchors.horizontalCenter: parent.horizontalCenter
        width: parent.width * 0.9
        height: parent.height / 2
        clip: true
        ScrollBar.vertical: ScrollBar { }

        property int indexSelected: -1
        property string nameSelected: ""

        model: ProductsModel

        delegate: Item {
            id: delegate
            height: listProducts.height / 4
            width: listProducts.width

            required property string productName
            required property int index

            Rectangle{
                anchors.fill: parent
                border.color: "lightgrey"
                border.width: 1
                color: "white"
                Rectangle{ // selected line
                    anchors.fill: parent
                    color: "#3E95F9"
                    visible: delegate.index === listProducts.indexSelected
                }
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        focus = true
                        listProducts.indexSelected = delegate.index
                        listProducts.nameSelected = delegate.productName
                    }
                }

                Item {
                    id: itemTxtProductName
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: parent.height / 4
                    anchors.rightMargin: parent.height / 4
                    anchors.right: parent.right
                    height: parent.height
                    clip: true

                    Text {
                        id: txtProductName
                        anchors.verticalCenter: parent.verticalCenter
                        height: parent.height
                        verticalAlignment: Text.AlignVCenter
                        font.pixelSize: root.fontSize
                        color: (delegate.index === listProducts.indexSelected)?"white":"black"
                        text: delegate.productName

                        SequentialAnimation{
                            id: animationName
                            running: (root.visible === true) && (itemTxtProductName.width < txtProductName.width)
                            loops: Animation.Infinite
                            alwaysRunToEnd: true

                            NumberAnimation{
                                id: ani1
                                target: txtProductName
                                property: "x"
                                from: 0
                                to: itemTxtProductName.width - txtProductName.width
                                duration: 2000
                            }
                            PauseAnimation { duration: 500 }
                            NumberAnimation{
                                id: ani2
                                targets: txtProductName
                                property: "x"
                                from: itemTxtProductName.width - txtProductName.width
                                to: 0
                                duration: 2000
                            }
                            PauseAnimation { duration: 500 }
                        }
                    }
                }
            }
        }
    }

    // Calculated required time
    Item{
        id: itemLine3
        anchors.top: listProducts.bottom
        width: parent.width * 0.9
        height: parent.height * 0.18
        anchors.horizontalCenter: parent.horizontalCenter
        Text{
            id: txtLine3
            visible: ProcessModel.sensorStatus === 0
            anchors.fill: parent
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            color: "#416f4c"
            font.pixelSize: popUpStop.fontSize * 2
            text: ProcessModel.temperature.toFixed(1) + " °C    :    " + getTextTime(ProcessModel.minutesRequired)
        }
        Text{
            id: txtLine3SensorAlarm
            visible: ProcessModel.sensorStatus > 0
            anchors.fill: parent
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            color: "red"
            font.pixelSize: popUpStop.fontSize * 2
            text: "Temperature sensor problem"
        }
    }

    // Buttons Start Stop
    Item{
        id: itemLine4
        anchors.top: itemLine3.bottom
        width: parent.width * 0.9
        height: parent.height * 0.18
        anchors.horizontalCenter: parent.horizontalCenter

        Rectangle{
            id: btnCancel
            height: root.buttonWidth * 0.3
            width: root.buttonWidth
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            color: mouseAreaCancel.pressed? "red":"#d83324"
            radius: height / 2
            Text{
                anchors.centerIn: parent
                font.pixelSize: root.fontSize
                color: "white"
                text: "CANCEL"
            }

            MouseArea{
                id: mouseAreaCancel
                anchors.fill: parent
                onClicked: {
                    root.visible = false
                }
            }
        }

        Rectangle{
            id: btnStart
            height: root.buttonWidth * 0.3
            width: root.buttonWidth
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            color: mouseAreaOk.pressed? "green":"#416f4c"
            radius: height / 2
            Text{
                anchors.centerIn: parent
                font.pixelSize: root.fontSize
                color: "white"
                text: "START"
            }
            MouseArea{
                id: mouseAreaOk
                anchors.fill: parent
                onClicked: {
                    // if(listProducts.indexSelected >= 0 && ProcessModel.sensorStatus === 0){
                    if(listProducts.indexSelected >= 0){
                        root.start(root.index, listProducts.nameSelected)
                        root.visible = false
                    }
                }
            }
        }
    }
}
