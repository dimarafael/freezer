import QtQuick
import QtQuick.VirtualKeyboard
import Qt5Compat.GraphicalEffects
import com.kometa.ProductsModel

import QtQuick.Controls

Rectangle{
    id: root
    width: 200
    height: 200
    color: "white"
    property int index: 0
    property int buttonWidth: 50
    property int fontSize: 30
    property int targetLine: 1 // 1, 2, 3

    signal start(int index, string productName, real setpoint, bool coolMode, int targetLine, real setpoint2)

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
        property real setpointSelected: 0
        property real setpoint2Selected: 0
        property bool coolModeSelected: false

        model: ProductsModel

        delegate: Item {
            id: delegate
            height: listProducts.height / 4
            width: listProducts.width

            required property string productName
            required property real setpoint
            required property real setpoint2
            required property bool coolMode
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
                        listProducts.setpointSelected = delegate.setpoint
                        listProducts.setpoint2Selected = delegate.setpoint2
                        listProducts.coolModeSelected = delegate.coolMode
                    }
                }

                Item {
                    id: itemTxtProductName
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: parent.height / 4
                    anchors.rightMargin: parent.height / 4
                    anchors.right: txtProductSetpoint.left
                    height: parent.height
                    clip: true

                    Text {
                        id: txtProductName
                        anchors.verticalCenter: parent.verticalCenter
                        height: parent.height
                        verticalAlignment: Text.AlignVCenter
                        font.pixelSize: root.fontSize
                        // font.bold: delegate.index === listProducts.indexSelected
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
                Text{
                    id:txtProductSetpoint
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: txtProductSetpoint2.left
                    anchors.rightMargin: root.fontSize
                    font.pixelSize: root.fontSize
                    font.bold: delegate.index === listProducts.indexSelected
                    color: (delegate.index === listProducts.indexSelected)?"white":"black"
                    text: delegate.setpoint.toFixed(1)  + "℃"
                }
                Text{
                    id:txtProductSetpoint2
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: itemModeIcon.left
                    font.pixelSize: root.fontSize
                    font.bold: delegate.index === listProducts.indexSelected
                    color: (delegate.index === listProducts.indexSelected)?"#f6cfd5":"#ce253c"
                    text: delegate.setpoint2.toFixed(1)  + "℃"
                }
                Item{
                    id: itemModeIcon
                    anchors{
                        top: parent.top
                        right: parent.right
                        bottom: parent.bottom
                    }
                    width: height * 2

                    Image {
                        id: imgModeIcon
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.verticalCenter: parent.verticalCenter
                        height: parent.height * 0.8
                        fillMode: Image.PreserveAspectFit
                        source: delegate.coolMode?"img/mode_1.svg":"img/mode_0.svg"
                        sourceSize.height: height
                        smooth: false
                    }
                    ColorOverlay{
                        anchors.fill: imgModeIcon
                        source:imgModeIcon
                        color:"black"
                        antialiasing: true
                        visible: delegate.index != listProducts.indexSelected
                    }
                }
            }
        }
    }

    Item{
        id: itemLine3
        anchors.top: listProducts.bottom
        width: parent.width * 0.9
        height: parent.height * 0.18
        anchors.horizontalCenter: parent.horizontalCenter
        Rectangle{
            id: targetBg
            width: parent.width
            height: root.buttonWidth * 0.3
            anchors.centerIn: parent
            color: "lightgrey"
            radius: height / 2
            MouseArea{
                id: mouseAreaTarget1
                height: parent.height
                width: parent.width / 3
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                onClicked: root.targetLine = 1
            }
            MouseArea{
                id: mouseAreaTarget2
                height: parent.height
                width: parent.width / 3
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                onClicked: root.targetLine = 2
            }
            MouseArea{
                id: mouseAreaTarget3
                height: parent.height
                width: parent.width / 3
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
                onClicked: root.targetLine = 3
            }
        }
        Rectangle{
            id: btnTarget
            height: root.buttonWidth * 0.3
            width: root.buttonWidth
            x: {
                if(root.targetLine === 1) return 0
                if(root.targetLine === 2) return (targetBg.width / 2) - width / 2
                if(root.targetLine === 3) return targetBg.width - width
            }
            anchors.verticalCenter: targetBg.verticalCenter
            color: "#3E95F9"
            radius: height / 2
            Behavior on x{
                NumberAnimation{
                    duration: 150
                    easing.type: Easing.InOutQuad
                }
            }
        }
        Text{
            id: txtTarget1
            anchors.left: parent.left
            anchors.leftMargin: root.buttonWidth / 2 - root.fontSize / 2
            anchors.verticalCenter: parent.verticalCenter
            font.pixelSize: root.fontSize * 2
            font.bold: true
            color: (root.targetLine === 1)?"white":"#3E95F9"
            text: "2"
            Behavior on color {
                ColorAnimation {
                    duration: 150
                }
            }
        }
        Text{
            id: txtTarget2
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            font.pixelSize: root.fontSize * 2
            font.bold: true
            color: (root.targetLine === 2)?"white":"#3E95F9"
            text: "3"
            Behavior on color {
                ColorAnimation {
                    duration: 150
                }
            }
        }
        Text{
            id: txtTarget3
            anchors.right: parent.right
            anchors.rightMargin: root.buttonWidth / 2 - root.fontSize / 2
            anchors.verticalCenter: parent.verticalCenter
            font.pixelSize: root.fontSize * 2
            font.bold: true
            color: (root.targetLine === 3)?"white":"#3E95F9"
            text: "4"
            Behavior on color {
                ColorAnimation {
                    duration: 150
                }
            }
        }
    }

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
                    if(listProducts.indexSelected >= 0){
                        root.start(root.index, listProducts.nameSelected, listProducts.setpointSelected, listProducts.coolModeSelected, root.targetLine, listProducts.setpoint2Selected)
                        root.visible = false
                    }
                }
            }
        }
    }
}
