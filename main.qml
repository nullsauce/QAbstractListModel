import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3

ApplicationWindow {
    visible: true
    width: 640
    height: 480
    title: qsTr("QAbstractListModel Shenanigans")

    ListView {
        model:testModel
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: controls.bottom
        anchors.bottom: parent.bottom
        width:400
        height: 400
        clip:true
        id:listView
        remove: Transition {
            ParallelAnimation {
                SmoothedAnimation {
                    property: "height"
                    velocity: 100
                    to: 0
                }
                SmoothedAnimation {
                    property: "opacity"
                    velocity: 4
                    to: 0
                }
            }
        }

        removeDisplaced: Transition {
             PropertyAnimation {
                 property: "y"
                 duration: 500
                 easing.type: Easing.OutBounce
             }
        }

        move: Transition {
            PropertyAnimation {
                property: "y"
                duration:500
                easing.type: Easing.OutExpo
            }
        }

        moveDisplaced: Transition {
            PropertyAnimation {
                property: "y"
                duration:500
                easing.type: Easing.OutExpo
            }
        }

        delegate: Item {
            width:parent.width
            height:50
            property bool hasPrev: index > 0
            property bool hasNext: index < (testModel.length-1)
            Rectangle {
                id:itemBackground
                anchors.fill: parent
                color:"grey"
                border.color: "black"
            }

            function sumChildren() {
                if(!hasNext) return 0;
                var sum = 0;
                for(var i = index + 1; i < testModel.length; i++) {
                    sum += testModel.get(i);
                }
                return sum;
            }

            Text {
                text:"Index: %1, Value: %2, Sum of children: %3"
                    .arg(index)
                    .arg(testModel.get(index))
                    .arg(sumChildren())
                anchors.fill: parent
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                color:"black"
            }

            MouseArea {
                width:30
                anchors.top: parent.top
                anchors.bottom: parent.verticalCenter
                anchors.right: parent.right
                anchors.margins: 1
                onClicked: testModel.remove(index, 1);
                cursorShape: Qt.PointingHandCursor
                Rectangle {
                    color:"yellow"
                    border.color: "black"
                    anchors.fill: parent
                    Text {
                        text:"X"
                        anchors.fill: parent
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                }
            }

            MouseArea {
                width:30
                anchors.top: parent.top
                anchors.bottom: parent.verticalCenter
                anchors.left: parent.left
                anchors.margins: 1
                anchors.bottomMargin: 0
                enabled:parent.hasPrev
                opacity:parent.hasPrev ? 1 : 0
                Behavior on opacity {
                    SmoothedAnimation {
                        velocity: 3.0
                        easing.type: Easing.OutCirc
                    }
                }

                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    testModel.move(index, index - 1 , 1);
                }
                Rectangle {
                    color:"yellow"
                    border.color: "#222"
                    anchors.fill: parent
                    Text {
                        text:"↑"
                        anchors.fill: parent
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                }
            }
            MouseArea {
                width:30
                anchors.top: parent.verticalCenter
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.margins: 1
                anchors.topMargin: 0
                enabled:parent.hasNext
                opacity:parent.hasNext ? 1 : 0
                Behavior on opacity {
                    SmoothedAnimation {
                        velocity: 3.0
                        easing.type: Easing.OutCirc
                    }
                }
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    testModel.move(index, index + 1 , 1);
                }
                Rectangle {
                    color:"yellow"
                    border.color: "#222"
                    anchors.fill: parent
                    Text {
                        text:"↓"
                        anchors.fill: parent
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                }
            }
        }
    }

    function addItems(howMany) {
        for(var i = 0; i < howMany; i++)
            testModel.append(Math.random()*100);
    }

    Column {
        id:controls
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        Text {
            text:"model has %1 items".arg(testModel.length)
            anchors.horizontalCenter: parent.horizontalCenter
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.bold: true
            font.pointSize: 20
        }

        Row {
            anchors.horizontalCenter: parent.horizontalCenter
            Repeater {
                model:[1,10,100]
                Button {
                    onClicked: addItems(modelData)
                    text:"Add %1".arg(modelData)
                }
            }
            Button {
                enabled: testModel.length > 0
                Behavior on opacity {
                    SmoothedAnimation {
                        velocity: 3.0
                        easing.type: Easing.OutCirc
                    }
                }
                onClicked: testModel.clear()
                text:"Clear"
            }
        }
    }

}
