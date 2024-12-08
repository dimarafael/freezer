import QtQuick
import QtQuick.VirtualKeyboard
import Qt5Compat.GraphicalEffects
import com.kometa.ProcessModel

Window {
    id: window
    width: 1024
    height: 768
    visible: true
    title: qsTr("Freezer")

    readonly property int defMargin: window.height * 0.01
    readonly property color shadowColor: "#88000000"

    property bool showSettings: false

    LinearGradient{
        anchors.fill: parent
        start: Qt.point(0,height)
        end: Qt.point(width,0)
        gradient: Gradient{
            GradientStop{
                position: 0.0;
                color: "#416f4c"
            }
            GradientStop{
                position: 0.5;
                color: "#ffffff"
            }
            GradientStop{
                position: 1.0;
                color: "#ce253c"
            }
        }
    }

    Item{
        id: itemRootContent
        anchors.fill: parent
        anchors.margins: window.defMargin

        DropShadow {
            anchors.fill: topMenu
            source: topMenu
            horizontalOffset: window.defMargin / 2
            verticalOffset: window.defMargin / 2
            radius: 3.0
            samples: 17
            color: window.shadowColor
            opacity: 0.8
        }

        Item {
            id: topMenu
            clip: true
            anchors.top: itemRootContent.top
            width: itemRootContent.width
            height: itemRootContent.height / 8.5
            Rectangle{
                id: topMenuBckground
                anchors.top: parent.top
                width: parent.width
                height: parent.height + window.defMargin
                color: "#416f4c"
                radius: window.defMargin
            }

            DropShadow {
                anchors.fill: logo
                source: logo
                horizontalOffset: window.defMargin / 3
                verticalOffset: window.defMargin / 3
                radius: 3.0
                samples: 17
                color: window.shadowColor
                opacity: 0.8
            }

            Image {
                id: logo
                anchors{
                    top: parent.top
                    bottom: parent.bottom
                    left: parent.left
                    margins: window.defMargin
                }
                fillMode: Image.PreserveAspectFit

                source: "img/logo.png"
            }

            Item{
                id: itemGear
                anchors{
                    top: parent.top
                    bottom: parent.bottom
                    right: parent.right
                }
                width: height * 1.5

                Rectangle{ //background if clicked
                    anchors.fill: parent
                    radius: window.defMargin
                    color: "#33ffffff"
                    visible: mouseAreaGear.pressed
                }

                MouseArea{
                    id: mouseAreaGear
                    anchors.fill: parent
                    onClicked: {
                        window.showSettings = !window.showSettings
                        // itemSettings.unlocked = false
                        // itemSettings.hideAllPopUps()
                        focus: true
                    }
                }

                DropShadow {
                    anchors.fill: imgGear
                    source: imgGear
                    horizontalOffset: window.defMargin / 3
                    verticalOffset: window.defMargin / 3
                    radius: 3.0
                    samples: 17
                    color: window.shadowColor
                    opacity: 0.8
                }
                Image {
                    id: imgGear
                    anchors{
                        centerIn: parent
                        margins: window.defMargin
                    }
                    fillMode: Image.PreserveAspectFit
                    source: "img/gear.svg"
                }


            }
        }

        GridView{
            id: gridViev
            anchors{
                top: topMenu.bottom
                left: parent.left
                right: parent.right
                bottom: parent.bottom
                margins: -( window.defMargin / 2)
                topMargin: window.defMargin / 2
            }
            cellWidth: width / 9
            cellHeight: height / 3
            interactive: false
            verticalLayoutDirection: GridView.TopToBottom

            model: ProcessModel
            delegate: ProcessItemDelegate {
                width: gridViev.cellWidth
                height: gridViev.cellHeight
                defMargin: window.defMargin
                shadowColor: window.shadowColor
            }
        }

    } // Item root content


    InputPanel {
        id: inputPanel
        z: 99
        x: 0
        y: window.height
        width: window.width

        states: State {
            name: "visible"
            when: inputPanel.active
            PropertyChanges {
                target: inputPanel
                y: window.height - inputPanel.height
            }
        }
        transitions: Transition {
            from: ""
            to: "visible"
            reversible: true
            ParallelAnimation {
                NumberAnimation {
                    properties: "y"
                    duration: 250
                    easing.type: Easing.InOutQuad
                }
            }
        }
    }
}
