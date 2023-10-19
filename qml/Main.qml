import QtQuick 2.12
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.12
import QtQuick.Controls.Universal 2.12
import QtMultimedia 

ApplicationWindow {
    title: "Pomodoro App"
    visible: true
    width: 360
    height: 450
    property int defaultTime: 25
    property int remainingTime: defaultTime * 60
    property real labelFontSize: 20
    property real buttonMinimumSize: 90
    property int timerInterval: 1000
    
    function formatTime(time){
        return (time < 10 ? '0' + time : time);
    }
    
    function updateTimer() {
        remainingTime--;
        var minutes = Math.floor(remainingTime / 60);
        var seconds = remainingTime % 60;
        text.text = formatTime(minutes) + ":" + formatTime(seconds);
        
        if (remainingTime === 0) {
            timer.stop();
            audioEndSignal.play(); 
            startButton.enabled = true;
            reminderWindow.showFullScreen()
            reminderTimer.start();
            
        }
    }
    
    function resetTimer(){
        remainingTime = defaultTime * 60;
        text.text = formatTime(defaultTime) + ":00";
    }
    
    
    
    Popup {
        id: timePopup
        x: parent.width / 2 - width / 2
        y: parent.height / 2 - height / 2
        width: 200
        height: 100
        modal: true
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
        
        onOpened: { 
            timeInput.forceActiveFocus()
            
        }
        
        ColumnLayout {
            anchors.centerIn: parent
            
            TextField {
                id: timeInput
                Layout.alignment: Qt.AlignHCenter 
                Layout.fillWidth: true
                inputMask: '99'
                Keys.onReturnPressed: {
                    submitButton.forceActiveFocus()
                    
                }
            }
            
            Button {
                id: submitButton
                text: "Submit"
                Layout.alignment: Qt.AlignHCenter 
                Layout.fillWidth: true
                
                onClicked: {
                    defaultTime = parseInt(timeInput.text);
                    timePopup.close();
                    timer.stop();
                    resetTimer();
                    startButton.enabled = true;
                }
            }
        }
        
    }
    
    Action {
        id: optionsMenuAction
        onTriggered: optionsMenu.open()
    }
    
    header: ToolBar {
        RowLayout {
            
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
                        text: "Set default time"
                        onTriggered: timePopup.open()
                    }
                    
                }
                
            }
        }
    }
    
    
    Rectangle {
        id: rectangle
        anchors.fill: parent
        anchors.topMargin: -65
        
        Text {
            id: text
            text: formatTime(defaultTime) + ":00"
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: 60
            anchors.centerIn: parent
            anchors.topMargin: -900
        }
        
        RowLayout {
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 30
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 15
            
            Button {
                id: startButton
                font.pixelSize: 18
                Layout.minimumHeight: buttonMinimumSize
                Layout.minimumWidth: buttonMinimumSize
                text: "Start"
                onClicked: {
                    timer.start();
                    startButton.enabled = false;
                }
            }
            
            Button {
                font.pixelSize: 18
                Layout.minimumHeight: buttonMinimumSize
                Layout.minimumWidth: buttonMinimumSize
                text: "Pause"
                onClicked: {
                    timer.stop()
                    startButton.enabled = true;
                }
            }
            
            Button {
                font.pixelSize: 18
                Layout.minimumHeight: buttonMinimumSize
                Layout.minimumWidth: buttonMinimumSize
                text: "Stop"
                onClicked: {
                    timer.stop();
                    resetTimer();
                    startButton.enabled = true;
                }
            }
        }
    }
    
    //This will be your separate window.
    Window {
        id: reminderWindow
        width: 200 
        height: 100   
        visible: false //Don't show it until the button is pressed.    
        title: "Reminder Window"
        modality:Qt.ApplicationModal //Makes it modal - users must first close this window to interact with the main window.
        color: "black" // To make the window background transparent.
        opacity: 0.7 // To make the window background transparent.
        
        Text {
            text: "Time's up!"
            color: "white"
            font.pixelSize: 60 // Making the text bigger.
            anchors.centerIn: parent
        }
    }
    
    Timer {
        id: reminderTimer
        interval: 2000; repeat: false; running: false
        
        onTriggered: {
             reminderWindow.close()
        }
    }
    
    Timer {
        id: timer
        interval: timerInterval 
        repeat: true
        onTriggered: updateTimer()
    }
    
    MediaPlayer {
        id: audioEndSignal
        audioOutput: AudioOutput {}
        source: "qrc:/assets/sounds/end.mp3"   
    }
    
}
