import QtQuick
import QtQuick.VirtualKeyboard
import Qt5Compat.GraphicalEffects
import com.kometa.ProcessModel
import QtQuick.Controls
import com.kometa.ProductsModel

Item {
    id: root
    property int defMargin: 5
    property bool unlocked: false
    property int fontSize: 30
    property color textColor: "black" //"#bb000000"
    property int indexForDeleteEdit: 0
    property string nameForDeleteEdit: ""

    signal hidePanel()
    signal showParameters()

    function hideAllPopUps(){
        popUpDelete.visible = false
        popUpAddEdit.visible = false
    }

    function checkPassword(){
        if(txtFldPass.text === "123"){
            root.unlocked = true
            root.focus = true
        }
        txtFldPass.text = ""
    }

    MouseArea{
        anchors.fill: parent
        onClicked: {
            focus = true
        }
    }

    MouseArea{ // Hidden area for close application
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        width: 40
        height: 40

        onClicked: {
            Qt.callLater(Qt.quit)
        }
    }

    DropShadow {
        anchors.fill: root
        source: root
        horizontalOffset: root.defMargin / 2
        verticalOffset: root.defMargin / 2
        radius: 3.0
        samples: 17
        color: "#88000000"
    }

    Rectangle{
        id: bgRectangle
        width: parent.width
        height: parent.height + root.defMargin
        color: "lightgray"
        radius: root.defMargin
    }


    Item{ // show content
        id: itemRootContent
        visible: root.unlocked
        anchors.fill: parent

        Text{
            id: textLabelRootContent
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: parent.height / 100
            text: "Edit products recipes"
            color: "#416f4c"
            font.pixelSize: root.fontSize * 2
        }

        ListView{
            id: listProducts
            anchors.top: textLabelRootContent.bottom
            anchors.topMargin: parent.height / 100
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width * 0.9
            height: parent.height * 0.65
            clip: true
            ScrollBar.vertical: ScrollBar { }

            model: ProductsModel

            delegate: Item{
                id: delegate
                height: listProducts.height / 5
                width: listProducts.width
                required property string productName
                required property int index

                Rectangle{
                    anchors.fill: parent
                    border.color: "grey"
                    border.width: 1
                    color: bgRectangle.color

                    Item {
                        id: itemTxtProductName
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                        anchors.leftMargin: parent.height / 4
                        anchors.rightMargin: parent.height / 4
                        anchors.right: itemEdit.left
                        height: parent.height
                        clip: true

                        Text {
                            id: txtProductName
                            anchors.verticalCenter: parent.verticalCenter
                            height: parent.height
                            verticalAlignment: Text.AlignVCenter
                            font.pixelSize: root.fontSize
                            color: root.textColor
                            text: delegate.productName

                            SequentialAnimation{
                                id: animationName
                                running: (root.unlocked) && (itemTxtProductName.width < txtProductName.width)
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
                    Item{
                        id: itemEdit
                        anchors{
                            top: parent.top
                            bottom: parent.bottom
                            right: itemDelete.left
                        }
                        width: height * 1.5

                        Rectangle{ //background if clicked
                            anchors.fill: parent
                            color: "#33ffffff"
                            visible: mouseAreaEdit.pressed
                        }

                        MouseArea{
                            id: mouseAreaEdit
                            anchors.fill: parent
                            onClicked: {
                                focus: true
                                console.log("Edit " + delegate.index)
                                txtEditLine2.text = delegate.productName
                                popUpAddEdit.index = delegate.index
                                popUpAddEdit.isEdit = true
                                popUpAddEdit.visible = true
                            }
                        }

                        Image {
                            id: imgEdit
                            anchors.top: parent.top
                            anchors.bottom: parent.bottom
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.margins: parent.height / 7
                            fillMode: Image.PreserveAspectFit
                            sourceSize.height: height
                            source: "img/edit.svg"
                        }
                    }

                    Item{
                        id: itemDelete
                        anchors{
                            top: parent.top
                            bottom: parent.bottom
                            right: parent.right
                        }
                        width: height * 1.5

                        Rectangle{ //background if clicked
                            anchors.fill: parent
                            color: "#33ffffff"
                            visible: mouseAreaDelete.pressed
                        }

                        MouseArea{
                            id: mouseAreaDelete
                            anchors.fill: parent
                            onClicked: {
                                focus: true
                                console.log("Delete " + delegate.index)
                                root.indexForDeleteEdit = delegate.index
                                root.nameForDeleteEdit = delegate.productName
                                popUpDelete.visible = true
                            }
                        }

                        Image {
                            id: imgDelete
                            anchors.top: parent.top
                            anchors.bottom: parent.bottom
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.margins: parent.height / 8
                            fillMode: Image.PreserveAspectFit
                            sourceSize.height: height
                            source: "img/trash.svg"
                        }
                    }

                }
            } // delegate
        } //item listProducts

        Item{
            id: itemOkCancel
            width: parent.width * 0.9
            height: root.height - listProducts.height - listProducts.y
            anchors.top: listProducts.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            Rectangle{
                id: btnCanceSettings
                height: root.height / 9
                width: root.width / 5
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                color: mouseCancelSettings.pressed? "red":"#d83324"
                radius: height / 2
                Text{
                    anchors.centerIn: parent
                    font.pixelSize: root.fontSize
                    color: "white"
                    text: "CANCEL"
                }

                MouseArea{
                    id: mouseCancelSettings
                    anchors.fill: parent
                    onClicked: {
                        root.unlocked = false
                        root.hideAllPopUps()
                        root.hidePanel()
                    }
                }
            }

            Rectangle{
                id: btnAddSettings
                height: root.height / 9
                width: root.width / 5
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                color: mouseAddSettings.pressed? "blue":"#3E95F9"
                radius: height / 2
                Text{
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.topMargin: -(root.fontSize * 0.6)
                    font.pixelSize: root.fontSize * 3
                    verticalAlignment: Text.AlignVCenter
                    color: "white"
                    text: "+"
                }

                MouseArea{
                    id: mouseAddSettings
                    anchors.fill: parent
                    onClicked: {
                        txtEditLine2.text = ""
                        popUpAddEdit.index = 0
                        popUpAddEdit.isEdit = false
                        popUpAddEdit.visible = true
                    }
                }
            }

            Image {
                id: imgSettings
                anchors{
                    // centerIn: parent
                    // margins: window.defMargin
                    verticalCenter: parent.verticalCenter
                    right: parent.right
                    rightMargin: height
                }
                height: root.height / 9
                fillMode: Image.PreserveAspectFit
                source: "img/settings.svg"

                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        root.hidePanel()
                        root.showParameters()
                    }
                }
            }

        } // itemOkCancel

    } // show content

    Rectangle{
        id:popUpBG
        x: 0
        y: 0
        width: root.width
        height: root.height + root.defMargin
        radius: root.defMargin
        color: "gray"
        opacity: 0.7
        visible: popUpDelete.visible | popUpAddEdit.visible
        MouseArea{
            anchors.fill: parent
            onClicked: focus=true
        }
    }

    DropShadow {
        anchors.fill: popUpDelete
        source: popUpDelete
        horizontalOffset: root.defMargin / 3
        verticalOffset: root.defMargin / 3
        radius: 8.0
        samples: 17
        color: "#88000000"
        visible: popUpDelete.visible
    }
    Rectangle{
        id: popUpDelete
        width: parent.width / 2
        height: parent.height / 2
        radius: root.defMargin
        color: "white"
        anchors.centerIn: parent
        visible: false
        Text{
            id: txtPopUpDeleteLine1
            width: parent.width
            height: parent.height / 4
            anchors.top: parent.top
            verticalAlignment: Text.AlignBottom
            horizontalAlignment: Text.AlignHCenter
            color: "#416f4c"
            font.pixelSize: root.fontSize * 2
            text: "Delete?"
        }
        Text{
            id: txtPopUpDeleteLine2
            width: parent.width
            height: parent.height / 4
            anchors.top: txtPopUpDeleteLine1.bottom
            verticalAlignment: Text.AlignTop
            horizontalAlignment: Text.AlignHCenter
            color: "#416f4c"
            font.pixelSize: root.fontSize * 2
            text: root.nameForDeleteEdit
        }

        Item {
            id: itemPopUpDeleteLine3
            height: parent.height / 2
            width: parent.width * 0.85
            anchors.top: txtPopUpDeleteLine2.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            Rectangle{
                id: btnPopUpDeleteCancel
                height: root.height / 9
                width: root.width / 5
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                color: mouseAreaDeleteCancel.pressed? "red":"#d83324"
                radius: height / 2
                Text{
                    anchors.centerIn: parent
                    font.pixelSize: root.fontSize
                    color: "white"
                    text: "CANCEL"
                }

                MouseArea{
                    id: mouseAreaDeleteCancel
                    anchors.fill: parent
                    onClicked: {
                        popUpDelete.visible = false
                    }
                }
            }

            Rectangle{
                id: btnPopUpDeleteOk
                height: root.height / 9
                width: root.width / 5
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
                color: mouseAreaDeleteOk.pressed? "green":"#416f4c"
                radius: height / 2
                Text{
                    anchors.centerIn: parent
                    font.pixelSize: root.fontSize
                    color: "white"
                    text: "DELETE"
                }
                MouseArea{
                    id: mouseAreaDeleteOk
                    anchors.fill: parent
                    onClicked: {
                        ProductsModel.remove(root.indexForDeleteEdit)
                        popUpDelete.visible = false
                    }
                }
            }
        }
    } //popUpDelete

    Rectangle{
        id: popUpAddEdit
        width: parent.width / 2
        height: parent.height / 2
        radius: root.defMargin
        color: "white"
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: height / 8
        visible: false
        property bool mode: false
        property int index: 0
        property bool isEdit: false

        Item {
            id: popUpEditLine1
            width: parent.width
            height: parent.height / 4
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            Text{
                id: txtPopUpEditLine1
                // width: parent.width
                // height: parent.height
                // anchors.top: parent.top
                anchors.fill: parent
                verticalAlignment: Text.AlignBottom
                horizontalAlignment: Text.AlignHCenter
                color: "#416f4c"
                font.pixelSize: root.fontSize * 2
                text: popUpAddEdit.isEdit? "Edit product":"New product"
            }


        }

        Item {
            id: popUpEditLine2
            width: parent.width
            height: parent.height / 4
            // anchors.verticalCenter: parent.verticalCenter
            anchors.top: popUpEditLine1.bottom
            anchors.horizontalCenter: parent.horizontalCenter

            TextField{
                id: txtEditLine2
                width: parent.width * 0.8
                height: parent.height * 0.6
                anchors.centerIn: parent
                inputMethodHints: Qt.ImhNoTextHandles // | hide selection handles
                font.pixelSize: root.fontSize
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter

                onAccepted: {
                    console.log(text)
                    focus = false
                }

                background: Rectangle {
                    color: "#00FFFFFF"
                    border.width: 2
                    border.color: parent.activeFocus ? "#416f4c" : "lightgray"
                    Behavior on border.color {
                        ColorAnimation {
                            duration: 250
                        }
                    }
                }
            }
        }

        Item {
            id: popUpEditLine3
            width: parent.width * 0.9
            height: parent.height / 2
            anchors.top: popUpEditLine2.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            Rectangle{
                id: btnPopUpEditCancel
                height: root.height / 9
                width: root.width / 5
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                color: mouseAreaEditCancel.pressed? "red":"#d83324"
                radius: height / 2
                Text{
                    anchors.centerIn: parent
                    font.pixelSize: root.fontSize
                    color: "white"
                    text: "CANCEL"
                }

                MouseArea{
                    id: mouseAreaEditCancel
                    anchors.fill: parent
                    onClicked: {
                        popUpAddEdit.visible = false
                    }
                }
            }

            Rectangle{
                id: btnPopUpEditOk
                height: root.height / 9
                width: root.width / 5
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
                color: mouseAreaEditOk.pressed? "green":"#416f4c"
                radius: height / 2
                Text{
                    anchors.centerIn: parent
                    font.pixelSize: root.fontSize
                    color: "white"
                    text: "OK"
                }
                MouseArea{
                    id: mouseAreaEditOk
                    anchors.fill: parent
                    onClicked: {
                        if(txtEditLine2.text.length > 0){
                            if(popUpAddEdit.isEdit) ProductsModel.set(popUpAddEdit.index, txtEditLine2.text);
                            else{
                                ProductsModel.append(txtEditLine2.text);
                                listProducts.positionViewAtEnd();
                            }
                            popUpAddEdit.visible = false
                        }
                    }
                }
            }
        }

    }// popUpAddEdit


    Item{ // show password field
        id: itemPass
        visible: !root.unlocked
        anchors.fill: parent

        Text{
            id: textLabelPass
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: parent.height / 6
            text: "Enter password"
            color: "#416f4c"
            font.pixelSize: root.fontSize

        }

        TextField{
            id: txtFldPass
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: textLabelPass.bottom
            anchors.topMargin: height / 3
            width: parent.width / 4
            height: root.fontSize * 1.4
            inputMethodHints: Qt.ImhDigitsOnly | Qt.ImhNoTextHandles // | hide selection handles
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: root.fontSize
            echoMode: TextInput.Password
            onAccepted: root.checkPassword()
        }
    }
}
