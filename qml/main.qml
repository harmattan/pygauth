import QtQuick 1.1
import com.nokia.meego 1.0

PageStackWindow {
    id: appWindow

    property string version: "1.1"

    initialPage: mainPage

    MainPage {
	id: mainPage
    }

    Connections {
        target: platformWindow
	onActiveChanged: if (platformWindow.active) passcodeGenerator.readConfig()
    }

    TextField {
        id: shadowPin
        text: passcodeGenerator.pin
        visible: false
    }

    ToolBarLayout {
        id: commonTools
        visible: true
        ToolButton {
             text: qsTr("Copy")
             onClicked: { shadowPin.selectAll(); shadowPin.copy() }
        }
	ToolIcon { platformIconId: "toolbar-settings";
             onClicked: passcodeGenerator.openSettings()
	}
        ToolIcon { platformIconId: "toolbar-view-menu";
             anchors.right: parent===undefined ? undefined : parent.right
             onClicked: (myMenu.status == DialogStatus.Closed) ? myMenu.open() : myMenu.close()
        }
    }

    QueryDialog {
	id: aboutDialog
	icon: "file:///usr/share/icons/hicolor/80x80/apps/pygauth80.png"
	titleText: qsTr("About GAuth v") + version
	message: qsTr("This Authenticator provides token values needed for using two-step authentication with Google or other online services.\nCopyright Joshua King 2012")
    }

    Menu {
        id: myMenu
        visualParent: pageStack
        MenuLayout {
//			MenuItem { 
//				text: mainPage.secretText.opacity == 0.0 ? qsTr("Show secret") : qsTr("Hide secret")
//				onClicked: {
//					if (mainPage.secretText.opacity == 0.0) {
//						mainPage.secretText.text = passcodeGenerator.secret
//						mainPage.secretText.opacity = 1.0
//						mainPage.secretText.focus = true
//					} else {
//						mainPage.secretText.opacity = 0.0
//						passcodeGenerator.secret = mainPage.secretText.text
//					}
//				}
//			}
			MenuItem {
				text: qsTr("About")
				onClicked: aboutDialog.open()
			}
        }
    }
}
