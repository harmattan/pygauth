import QtQuick 1.1
import com.nokia.meego 1.1

PageStackWindow {
	id: appWindow

	initialPage: mainPage
	Dialog {
		id: secretDialog
		title: Label {
			text: qsTr("Enter the secret")
		}
		content: TextEdit {
			id: text1
			width: parent.width
			text: passcodeGenerator.secret
		}
		buttons: ButtonRow {
			anchors.horizontalCenter: parent.horizontalCenter  
       			Button {text: "OK"; onClicked: myDialog.accept() }
			Button {text: "Cancel"; onClicked: secretDialog.reject() }
		}
		visualParent: appWindow
		onAccepted: passcodeGenerator.secret = text1.text
	}

	Page {
		id: mainPage
		tools: commonTools

		TextField {
			id: secretText
			opacity: 0.0
			width: parent.width
			anchors.top: parent.top
			anchors.left: parent.left
		}

		Label {
			id: pinLabel
			anchors.fill: parent
			text: passcodeGenerator.pin
			horizontalAlignment: Text.AlignHCenter
			verticalAlignment: Text.AlignVCenter
			platformStyle: LabelStyle {
				textColor: "#000099"
				fontPixelSize: 80
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

	ToolBarLayout {
		id: commonTools
		visible: true

		ToolIcon {
			platformIconId: "toolbar-view-menu"
			anchors.right: (parent === undefined) ? undefined : parent.right
			onClicked: (myMenu.status === DialogStatus.Closed) ? myMenu.open() : myMenu.close()
		}
	}

	Menu {
		id: myMenu
		visualParent: pageStack
		MenuLayout {
			MenuItem { 
				text: secretText.opacity == 0.0 ? qsTr("Show secret") : qsTr("Hide secret")
				onClicked: {
					if (secretText.opacity == 0.0) {
						secretText.text = passcodeGenerator.secret
						secretText.opacity = 1.0
						secretText.focus = true
					} else {
						secretText.opacity = 0.0
						passcodeGenerator.secret = secretText.text
					}
				}
			}
			MenuItem { text: qsTr("About") }
		}
	}
}
