import QtQuick 1.1
import com.nokia.meego 1.1

PageStackWindow {
    id: appWindow

    initialPage: mainPage

    MainPage{id: mainPage}

    ToolBarLayout {
        id: commonTools
        visible: true
        ToolIcon { platformIconId: "toolbar-view-menu";
             anchors.right: parent===undefined ? undefined : parent.right
             onClicked: (myMenu.status == DialogStatus.Closed) ? myMenu.open() : myMenu.close()
        }
    }

    Menu {
        id: myMenu
        visualParent: pageStack
        MenuLayout {
			MenuItem { 
				text: mainPage.secretText.opacity == 0.0 ? qsTr("Show secret") : qsTr("Hide secret")
				onClicked: {
					if (mainPage.secretText.opacity == 0.0) {
						mainPage.secretText.text = passcodeGenerator.secret
						mainPage.secretText.opacity = 1.0
						mainPage.secretText.focus = true
					} else {
						mainPage.secretText.opacity = 0.0
						passcodeGenerator.secret = mainPage.secretText.text
					}
				}
			}
			MenuItem { text: qsTr("About") }
        }
    }
}
