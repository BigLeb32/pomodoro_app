import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12


ApplicationWindow {
    title: "Pomodoro App"
    visible: true
    width: 360
    height: 520
    property int defaultTime: 25;
    property int remainingTime: defaultTime
    
     
    Action {
        id: optionsMenuAction
        onTriggered: optionsMenu.open()
    }
    
    header: ToolBar {
        RowLayout {
            
            spacing: 20
            anchors.fill: parent
            
            Label {
                id: titleLabel
                text: "Pomodoro App"
                font.pixelSize: 20
                elide: Label.ElideRight
                horizontalAlignment: Qt.AlignHCenter
                verticalAlignment: Qt.AlignVCenter
                Layout.fillWidth: true
                
            }
            
            ToolButton {
                action: optionsMenuAction
                icon.source: "qrc:/assets/icons/menu.png"

                Menu {
                    id: optionsMenu
                    x: parent.width - width
                    transformOrigin: Menu.TopRight
                    
                    Action {
                        text: "Settings"
                    }
                    Action {
                        text: "Help"
                    }
                    Action {
                        text: "About"
                    }
                }
                
            }
        }
    }
    
    
    Rectangle {
        id: rectangle
        anchors.fill: parent
        Text {
            id: text
            // set remainingTime as the initial value format to "25:00"
            text: (defaultTime < 10 ? '0' + defaultTime : defaultTime) + ":00"
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: 40
            anchors.centerIn: parent
        }
        
        Button {
            id: startButton
            text: "Start"
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            width: 100
            onClicked: {
                remainingTime = 25; // Reset to 25 minutes.
                updateTimer();
                timer.start();
                startButton.enabled = false; // Disable the button.
            }
        }
        
        Timer {
            id: timer
            interval: 60000 // 60 seconds
            repeat: true
            onTriggered: updateTimer()
        }
    }
    
    function updateTimer() {
        remainingTime--;
        var minutes = parseInt(remainingTime % 60);
        var seconds = parseInt(remainingTime / 60);
        
        text.text = (minutes < 10 ? '0' + minutes : minutes) + ":" 
                + (seconds < 10 ? '0' + seconds : seconds);
        
        if (remainingTime === 0) {
            timer.stop();
            startButton.enabled = true;
        }
    }
    
}



