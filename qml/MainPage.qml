import QtQuick 1.1
import com.nokia.meego 1.1

Page {
    id: mainPage
    tools: commonTools

    property alias secretText: secretText

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
		anchors.bottom: parent.bottom
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
			onValidityUpdated: { animateValue.from = (30 - passcodeGenerator.validity) / 30; animateValue.duration = passcodeGenerator.validity * 1000; animateValue.start() }
		}

		Component.onCompleted: { if (!animateValue.running) { animateValue.from = (30 - passcodeGenerator.validity) / 30; animateValue.duration = passcodeGenerator.validity * 1000; animateValue.start() } }
	}

	Label {
		id: pinLabel
		anchors.fill: parent
		text: passcodeGenerator.pin
		horizontalAlignment: Text.AlignHCenter
		verticalAlignment: Text.AlignVCenter
		platformStyle: LabelStyle {
			textColor: "#000099"
			fontPixelSize: (parent.width > parent.height) ? 0.5 * parent.height : 0.25 * parent.width
		}

		NumberAnimation {
			id: animateOpacity
			target: pinLabel
			properties: "opacity"
			from: 1.0
			to: 0.0
		}
	
		Connections {
			target: passcodeGenerator
			onValidityUpdated: { animateOpacity.duration = passcodeGenerator.validity * 1000; animateOpacity.start(); }
		}

		Connections {
			target: passcodeGenerator
			onPinChanged: { console.log("Pin changed to: " + passcodeGenerator.pin); animateOpacity.stop(); pinLabel.opacity = 1.0 }
		}

		Component.onCompleted: if (!animateOpacity.running) { animateOpacity.duration = passcodeGenerator.validity * 1000; animateOpacity.start(); }
	}
}
