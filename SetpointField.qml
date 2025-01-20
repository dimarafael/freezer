import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Qt5Compat.GraphicalEffects
import QtQuick.VirtualKeyboard

Rectangle {
    id: root
    color: "#FFFFFF"
    width: 100
    height: 40

    property real minVal: 0
    property real maxVal: 100
    property real value;
    property string units: ""
    signal setValue(real value);

    property bool dummy: false // to force update text in text field

    Rectangle{
        id: tooltip
        width: tooltipText.width + height
        height: root.height / 2
        color: "lightgrey"
        anchors.horizontalCenter: root.horizontalCenter
        y: -(height + 2)
        radius: height / 4
        opacity: txtFld.focus ? 1:0
        Text {
            id: tooltipText
            text: root.minVal + " ... " + root.maxVal
            anchors.horizontalCenter: parent.horizontalCenter
            height: root.height / 2
            font.pixelSize: height * 0.7
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            color: "#416f4c"
        }

        Behavior on opacity {
            NumberAnimation{
                duration: 250
            }
        }
    }

    TextField{
        id: txtFld
        width: parent.width
        height: parent.height
        validator: IntValidator{bottom: root.minVal; top: root.maxVal;}
        inputMethodHints: Qt.ImhDigitsOnly | Qt.ImhNoTextHandles // | hide selection handles
        font.pixelSize: height*0.7
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignRight
        rightPadding: units.width + height * 0.1

        text: root.dummy? root.value : root.value

        onAccepted: {
            setValue(Number(text))
            focus = false
        }

        onFocusChanged: {
            if(!focus) root.dummy = ! root.dummy
            else txtFld.selectAll()
        }

        background: Rectangle {
            color: "#00FFFFFF"
            border.width: parent.activeFocus ? 2 : 1
            border.color: parent.activeFocus ? "#416f4c" : "lightgrey"
            Behavior on border.color {
                ColorAnimation {
                    duration: 250
                }
            }
        }
    }

    Text {
        id: units
        height: txtFld.height
        verticalAlignment: Text.AlignVCenter
        font.pixelSize: txtFld.font.pixelSize
        rightPadding: height * 0.2
        anchors.right: root.right
        text: root.units
    }
}
