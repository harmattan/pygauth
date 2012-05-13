import QtQuick 1.1
import QtWebKit 1.0
import com.nokia.meego 1.0

Page {
    id: mainPage
    tools: commonTools

    property alias secretText: secretText
    property alias help: help

	Rectangle {
		id: nameRect
		color: "#000099"
//		gradient: Gradient {
//         		GradientStop { position: 0.8; color: "#000099" }
//         		GradientStop { position: 1.0; color: mainPage.color }
//		}
		Label {
			id: nameLabel
			text: passcodeGenerator.name
			anchors.centerIn: parent
			width: parent.width
			platformStyle: LabelStyle {
				textColor: "#ffffff"
			}
			horizontalAlignment: Text.AlignHCenter
			verticalAlignment: Text.AlignVCenter
		}
		anchors.top: parent.top
		anchors.left: parent.left
		width: parent.width
		height: nameLabel.height * 2
	}

	TextField {
		id: secretText
		opacity: 0.0
		width: parent.width
		anchors.top: parent.top
		anchors.left: parent.left
	}

	ProgressBar {
		id: bar
		width: parent.width
		anchors.top: nameRect.bottom
		anchors.left: parent.left

		NumberAnimation {
			id: animateValue
			target: bar
			properties: "value"
			from: 0.0
			to: 1.0
		}

		Connections {
			target: passcodeGenerator
			onValidityUpdated: {
				animateValue.from = 0.0;
				animateValue.duration = passcodeGenerator.validity * 1000; 
				animateValue.restart() 
			}
		}

		Component.onCompleted: { 
			if (!animateValue.running) { 
				animateValue.from = (30 - passcodeGenerator.validity) / 30; 
				animateValue.duration = passcodeGenerator.validity * 1000;
				animateValue.start() 
			}
		}
	}

	Label {
		id: pinLabel
		width: parent.width
		anchors.top: bar.bottom
		anchors.bottom: parent.bottom
//		anchors.fill: parent
		text: passcodeGenerator.pin
		horizontalAlignment: Text.AlignHCenter
		verticalAlignment: Text.AlignVCenter
		platformStyle: LabelStyle {
			id: pinStyle
			textColor: "#000099"
			fontPixelSize: (parent.width > parent.height) ? 0.5 * parent.height : 0.25 * parent.width
		}

		NumberAnimation {
			id: animateOpacity
			target: pinLabel
			properties: "opacity"
			from: 1.0
			to: 0.0
			easing.type: Easing.InQuart
		}

		ColorAnimation {
			id: animateColor
			target: pinStyle
			properties: "textColor"
			from: "#000099"
			to: "#990000"
			easing.type: Easing.InQuart
		}
	
		Connections {
			target: passcodeGenerator
			onValidityUpdated: {
				var v = passcodeGenerator.validity
				animateOpacity.duration = v * 1000;
				animateOpacity.restart();
				if (v > 3) {
					animateColor.duration = (v - 3) * 1000
					animateColor.restart()
				} else {
					pinLabel.textColor = animateColor.to
				}
			}
		}

		Connections {
			target: passcodeGenerator
			onPinChanged: { console.log("Pin changed to: " + passcodeGenerator.pin); animateOpacity.stop(); pinLabel.opacity = 1.0 }
		}

		Component.onCompleted: {
			var v = passcodeGenerator.validity
			if (!animateOpacity.running) {
				animateOpacity.duration = v * 1000;
				animateOpacity.start();
			}

			if (v > 3 && !animateColor.running) {
				animateColor.duration = (v - 3) * 1000
				animateColor.start()
			} else if (!animateColor.running) {
				pinStyle.textColor = animateColor.to
			}

			if (passcodeGenerator.secret == '')
				help.visible = true
		}
	}

    Flickable {
        visible: false
        id: help
        anchors.fill: parent
        clip: true
        contentWidth: parent.width
        contentHeight: web.height

        WebView {
            id: web
	    url: "file://" + host.root + "html/help.html"
            preferredWidth: parent.width
        }
    }

    ScrollDecorator {
        flickableItem: help
    }
}
