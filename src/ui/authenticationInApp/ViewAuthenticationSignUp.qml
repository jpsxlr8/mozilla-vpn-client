/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

import QtQuick 2.5
import Mozilla.VPN 1.0
import "../components"
import "../components/forms"

Item {
    // TODO
    // We show this view when the user is creating an account.
    // Things are happening in background. The next steps are:
    // - Verification by email needed
    // - errors

    Component.onCompleted: console.log("SIGN UP")

    VPNTextField {
        id: passwordInput

        anchors.top: parent.top
        anchors.bottomMargin: 24
        width: parent.width

        echoMode: TextInput.Password

        placeholderText: "secure password" // TODO
    }

    VPNButton {
        anchors.top: passwordInput.bottom
        anchors.bottomMargin: 24
        text: "Sign Up" // TODO
        anchors.horizontalCenterOffset: 0
        anchors.horizontalCenter: parent.horizontalCenter
        radius: 5
        onClicked: {
          VPNAuthInApp.setPassword(passwordInput.text);
          VPNAuthInApp.signUp();
        }
    }
}