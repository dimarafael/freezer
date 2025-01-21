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

    signal start(int index, string productName, real weight)

    function getTextTime(totalMinutes){
        var hours = Math.floor(totalMinutes / 60);
        var minutes = totalMinutes % 60;

        hours = String(hours).padStart(2, '0')
        minutes = String(minutes).padStart(2, '0')

        return hours + ":" + minutes
    }

    onVisibleChanged: {
        if(visible === true) {
            listProducts.indexSelected = -1
            setpointWeight.text = 0
            comboCrates.currentIndex = 6
        }
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

    Item{
        id: itemLine2
        anchors.top: txtLine1.bottom
        width: parent.width * 0.9
        height: parent.height * 0.18
        anchors.horizontalCenter: parent.horizontalCenter

        Item{
            id: itemWeight
            anchors.left: parent.left
            anchors.top: parent.top
            height: parent.height
            width: parent.width / 3

            Image {
                id: imgScale
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                height: parent.height / 3
                sourceSize.height: height
                fillMode: Image.PreserveAspectFit
                source: "img/scale.svg"
            }

            SetpointField{
                id: setpointWeight
                anchors.left: imgScale.right
                anchors.leftMargin: root.fontSize / 3
                anchors.verticalCenter: parent.verticalCenter
                width: parent.width * 0.7
                height: root.fontSize * 1.8

                minVal: 1
                maxVal: 999
                units: "kg"
            }
        }

        Item{
            id: itemCrates
            anchors.left: itemWeight.right
            anchors.top: parent.top
            height: parent.height
            width: parent.width / 3

            Image {
                id: imgCrates
                anchors.left: parent.left
                anchors.leftMargin: root.fontSize / 2
                anchors.verticalCenter: parent.verticalCenter
                height: parent.height / 3
                sourceSize.height: height
                fillMode: Image.PreserveAspectFit
                source: "img/stack.svg"
            }

            ComboBox{
                id: comboCrates
                width: parent.width / 2
                height: root.fontSize * 1.8
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: imgCrates.right
                anchors.leftMargin: root.fontSize / 3

                model: [1, 2, 3, 4, 5, 6, 7]
                currentIndex: 6

                contentItem: Text {
                                text: comboCrates.currentText
                                font.pixelSize: comboCrates.height * 0.7
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                                anchors.fill: parent
                            }

                delegate: Item {
                                width: comboCrates.width
                                height: comboCrates.height

                                Rectangle{
                                    anchors.fill: parent
                                    color: "#3E95F9"
                                    visible: comboCrates.currentIndex === index
                                }

                                Text {
                                    text: modelData
                                    font.pixelSize: comboCrates.height * 0.7
                                    horizontalAlignment: Text.AlignHCenter
                                    verticalAlignment: Text.AlignVCenter
                                    anchors.fill: parent
                                    color: (index === comboCrates.currentIndex) ? "white":"black"
                                }

                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: {
                                        comboCrates.currentIndex = index
                                        comboCrates.popup.close()
                                    }
                                }
                            }
            }
        }

        Item{
            id: itemTemperature
            anchors.top: parent.top
            anchors.right: parent.right
            height: parent.height / 2
            width: parent.width / 4
            Image {
                id: imgTemperature
                anchors.left: parent.left
                anchors.leftMargin: height / 4
                anchors.verticalCenter: parent.verticalCenter
                height: parent.height / 2
                sourceSize.height: height
                fillMode: Image.PreserveAspectFit
                source: "img/temperature.svg"
            }
            Text{
                visible: ProcessModel.sensorStatus === 0
                anchors.fill: parent
                anchors.leftMargin: height * 0.7
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignLeft
                color: "black" //"#416f4c"
                font.pixelSize: popUpStop.fontSize
                text: ProcessModel.temperature.toFixed(1) + " °C"
            }
            Text{
                visible: ProcessModel.sensorStatus > 0
                anchors.fill: parent
                anchors.leftMargin: height * 0.7
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignLeft
                color: "red"
                font.pixelSize: popUpStop.fontSize
                text: "Sensor problem"
            }
        }

        Item{
            id: itemMinutesRequired
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            height: parent.height / 2
            width: parent.width / 4
            Image {
                id: imgClock
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                height: parent.height / 2
                sourceSize.height: height
                fillMode: Image.PreserveAspectFit
                source: "img/clock.svg"
            }

            Text{
                anchors.fill: parent
                anchors.leftMargin: height * 0.7
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignLeft
                color: "black" // "#416f4c"
                font.pixelSize: popUpStop.fontSize
                text: getTextTime(ProcessModel.minutesRequired)
            }
        }
    }

    ListView{
        id: listProducts
        anchors.top: itemLine2.bottom
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


    // Buttons Start Stop
    Item{
        id: itemLineButtons
        anchors.top: listProducts.bottom
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
                        if(parseFloat(setpointWeight.text) > 0){
                            root.start(root.index,
                                       listProducts.nameSelected,
                                       parseFloat(setpointWeight.text) - ProcessModel.weightCart - ProcessModel.weightCrate * parseInt(comboCrates.currentIndex+1) )
                            root.visible = false
                        } else {
                            setpointWeight.setFocus()
                        }
                    }
                }
            }
        }
    }
}
