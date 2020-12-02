# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

include($$PWD/../version.pri)
DEFINES += APP_VERSION=\\\"$$VERSION\\\"

QT += network
QT += quick
QT += widgets
QT += charts

CONFIG += c++1z

TEMPLATE  = app

DEFINES += QT_DEPRECATED_WARNINGS

INCLUDEPATH += \
            hacl-star \
            hacl-star/kremlin \
            hacl-star/kremlin/minimal

DEPENDPATH  += $${INCLUDEPATH}

OBJECTS_DIR = .obj
MOC_DIR = .moc
RCC_DIR = .rcc
UI_DIR = .ui

SOURCES += \
        apppermission.cpp \
        authenticationlistener.cpp \
        captiveportal/captiveportal.cpp \
        captiveportal/captiveportalactivator.cpp \
        captiveportal/captiveportaldetection.cpp \
        captiveportal/captiveportalrequest.cpp \
        closeeventhandler.cpp \
        command.cpp \
        commandlineparser.cpp \
        commands/commandactivate.cpp \
        commands/commanddeactivate.cpp \
        commands/commanddevice.cpp \
        commands/commandlogin.cpp \
        commands/commandlogout.cpp \
        commands/commandselect.cpp \
        commands/commandservers.cpp \
        commands/commandstatus.cpp \
        commands/commandui.cpp \
        connectiondataholder.cpp \
        connectionhealth.cpp \
        controller.cpp \
        cryptosettings.cpp \
        curve25519.cpp \
        errorhandler.cpp \
        fontloader.cpp \
        hacl-star/Hacl_Chacha20.c \
        hacl-star/Hacl_Chacha20Poly1305_32.c \
        hacl-star/Hacl_Curve25519_51.c \
        hacl-star/Hacl_Poly1305_32.c \
        ipaddressrange.cpp \
        leakdetector.cpp \
        localizer.cpp \
        logger.cpp \
        loghandler.cpp \
        logoutobserver.cpp \
        main.cpp \
        models/helpmodel.cpp \
        models/user.cpp \
        models/device.cpp \
        models/devicemodel.cpp \
        models/keys.cpp \
        models/server.cpp \
        models/servercity.cpp \
        models/servercountry.cpp \
        models/servercountrymodel.cpp \
        models/serverdata.cpp \
        mozillavpn.cpp \
        networkmanager.cpp \
        networkrequest.cpp \
        notificationhandler.cpp \
        pingsender.cpp \
        qmlengineholder.cpp \
        releasemonitor.cpp \
        rfc1918.cpp \
        settingsholder.cpp \
        simplenetworkmanager.cpp \
        statusicon.cpp \
        systemtrayhandler.cpp \
        tasks/accountandservers/taskaccountandservers.cpp \
        tasks/adddevice/taskadddevice.cpp \
        tasks/authenticate/taskauthenticate.cpp \
        tasks/captiveportallookup/taskcaptiveportallookup.cpp \
        tasks/controlleraction/taskcontrolleraction.cpp \
        tasks/function/taskfunction.cpp \
        tasks/removedevice/taskremovedevice.cpp \
        timercontroller.cpp \
        timersingleshot.cpp

HEADERS += \
        apppermission.h \
        applistprovider.h \
        authenticationlistener.h \
        captiveportal/captiveportal.h \
        captiveportal/captiveportalactivator.h \
        captiveportal/captiveportaldetection.h \
        captiveportal/captiveportalrequest.h \
        closeeventhandler.h \
        command.h \
        commandlineparser.h \
        commands/commandactivate.h \
        commands/commanddeactivate.h \
        commands/commanddevice.h \
        commands/commandlogin.h \
        commands/commandlogout.h \
        commands/commandselect.h \
        commands/commandservers.h \
        commands/commandstatus.h \
        commands/commandui.h \
        connectiondataholder.h \
        connectionhealth.h \
        constants.h \
        controller.h \
        controllerimpl.h \
        cryptosettings.h \
        curve25519.h \
        errorhandler.h \
        fontloader.h \
        ipaddressrange.h \
        leakdetector.h \
        localizer.h \
        logger.h \
        loghandler.h \
        logoutobserver.h \
        models/device.h \
        models/devicemodel.h \
        models/helpmodel.h \
        models/keys.h \
        models/server.h \
        models/servercity.h \
        models/servercountry.h \
        models/servercountrymodel.h \
        models/serverdata.h \
        models/user.h \
        mozillavpn.h \
        networkmanager.h \
        networkrequest.h \
        notificationhandler.h \
        pingsender.h \
        pingsendworker.h \
        qmlengineholder.h \
        releasemonitor.h \
        rfc1918.h \
        settingsholder.h \
        simplenetworkmanager.h \
        statusicon.h \
        systemtrayhandler.h \
        task.h \
        tasks/accountandservers/taskaccountandservers.h \
        tasks/adddevice/taskadddevice.h \
        tasks/authenticate/taskauthenticate.h \
        tasks/captiveportallookup/taskcaptiveportallookup.h \
        tasks/controlleraction/taskcontrolleraction.h \
        tasks/function/taskfunction.h \
        tasks/removedevice/taskremovedevice.h \
        timercontroller.h \
        timersingleshot.h

debug {
    message(Adding the inspector)
    QT+= testlib
    CONFIG += no_testcase_installs

    SOURCES += \
            inspector/inspectorconnection.cpp \
            inspector/inspectorserver.cpp

    HEADERS += \
            inspector/inspectorconnection.h \
            inspector/inspectorserver.h
}

# Signal handling for unix platforms
unix {
    SOURCES += signalhandler.cpp
    HEADERS += signalhandler.h
}

RESOURCES += qml.qrc

QML_IMPORT_PATH =
QML_DESIGNER_IMPORT_PATH =

production {
    DEFINES += MVPN_PRODUCTION_MODE
    RESOURCES += logo_prod.qrc
} else {
    RESOURCES += logo_beta.qrc
}

DUMMY {
    message(Dummy build)

    QMAKE_CXXFLAGS *= -Werror

    TARGET = mozillavpn
    QT += networkauth
    QT += svg

    DEFINES += MVPN_DUMMY

    SOURCES += \
            platforms/dummy/dummycontroller.cpp \
            platforms/dummy/dummycryptosettings.cpp \
            platforms/dummy/dummypingsendworker.cpp \
            systemtraynotificationhandler.cpp \
            tasks/authenticate/desktopauthenticationlistener.cpp

    HEADERS += \
            platforms/dummy/dummycontroller.h \
            platforms/dummy/dummypingsendworker.h \
            systemtraynotificationhandler.h \
            tasks/authenticate/desktopauthenticationlistener.h
}

# Platform-specific: Linux
else:linux:!android {
    message(Linux build)

    QMAKE_CXXFLAGS *= -Werror

    TARGET = mozillavpn
    QT += networkauth
    QT += svg

    DEFINES += MVPN_LINUX
    DEFINES += PROTOCOL_VERSION=\\\"$$DBUS_PROTOCOL_VERSION\\\"

    SOURCES += \
            platforms/linux/backendlogsobserver.cpp \
            platforms/linux/dbus.cpp \
            platforms/linux/linuxcontroller.cpp \
            platforms/linux/linuxcryptosettings.cpp \
            platforms/linux/linuxdependencies.cpp \
            platforms/linux/linuxpingsendworker.cpp \
            systemtraynotificationhandler.cpp \
            tasks/authenticate/desktopauthenticationlistener.cpp

    HEADERS += \
            platforms/linux/backendlogsobserver.h \
            platforms/linux/dbus.h \
            platforms/linux/linuxcontroller.h \
            platforms/linux/linuxdependencies.h \
            platforms/linux/linuxpingsendworker.h \
            systemtraynotificationhandler.h \
            tasks/authenticate/desktopauthenticationlistener.h

    isEmpty(PREFIX) {
        PREFIX=/usr
    }

    QT += dbus
    DBUS_INTERFACES = ../linux/daemon/org.mozilla.vpn.dbus.xml

    target.path = $${PREFIX}/bin
    INSTALLS += target
}

else:android {
    message(Android build)

    QMAKE_CXXFLAGS *= -Werror

    TARGET = mozillavpn
    QT += networkauth
    QT += svg
    QT += androidextras
    QT += qml
    QT += xml

    DEFINES += MVPN_ANDROID

    INCLUDEPATH += platforms/android

    SOURCES +=  platforms/android/androidauthenticationlistener.cpp \
                platforms/android/androidcontroller.cpp \
                platforms/android/androidnotificationhandler.cpp \
                platforms/android/androidutils.cpp \
                platforms/android/androidwebview.cpp \
                platforms/android/androidstartatbootwatcher.cpp \
                platforms/android/androiddatamigration.cpp \
                platforms/android/androidsharedprefs.cpp
    HEADERS +=  platforms/android/androidauthenticationlistener.h \
                platforms/android/androidcontroller.h \
                platforms/android/androidnotificationhandler.h \
                platforms/android/androidutils.h \
                platforms/android/androidwebview.h \
                platforms/android/androidstartatbootwatcher.h\
                platforms/android/androiddatamigration.h\
                platforms/android/androidsharedprefs.h

    # Usable Linux Imports
    SOURCES += platforms/linux/linuxpingsendworker.cpp \
               platforms/linux/linuxcryptosettings.cpp

    HEADERS += platforms/linux/linuxpingsendworker.h

    # We need to compile our own openssl :/
    exists(../3rdparty/openSSL/openssl.pri) {
       include(../3rdparty/openSSL/openssl.pri)
    } else{
       message(Have you imported the 3rd-party git submodules? Read the README.md)
       error(Did not found openSSL in 3rdparty/openSSL - Exiting Android Build )
    }

    # For the android build we need to unset those
    # Otherwise the packaging will fail 🙅
    OBJECTS_DIR =
    MOC_DIR =
    RCC_DIR =
    UI_DIR =
    ANDROID_ABIS = x86 armeabi-v7a arm64-v8a

    DISTFILES += \
        ../android/AndroidManifest.xml \
        ../android/build.gradle \
        ../android/gradle/wrapper/gradle-wrapper.jar \
        ../android/gradle/wrapper/gradle-wrapper.properties \
        ../android/gradlew \
        ../android/gradlew.bat \
        ../android/res/values/libs.xml

    ANDROID_PACKAGE_SOURCE_DIR = $$PWD/../android
}

# Platform-specific: MacOS
else:macos {
    message(MacOSX build)

    QMAKE_CXXFLAGS *= -Werror

    TARGET = MozillaVPN
    QMAKE_TARGET_BUNDLE_PREFIX = org.mozilla.macos
    QT += networkauth

    # For the loginitem
    LIBS += -framework ServiceManagement
    LIBS += -framework Security

    DEFINES += MVPN_MACOS

    SOURCES += \
            platforms/macos/macosmenubar.cpp \
            platforms/macos/macospingsendworker.cpp \
            platforms/macos/macosstartatbootwatcher.cpp \
            systemtraynotificationhandler.cpp \
            platforms/dummy/dummyapplistprovider.cpp\
            tasks/authenticate/desktopauthenticationlistener.cpp

    OBJECTIVE_SOURCES += \
            platforms/macos/macoscryptosettings.mm \
            platforms/macos/macosglue.mm \
            platforms/macos/macosutils.mm

    HEADERS += \
            platforms/macos/macosmenubar.h \
            platforms/macos/macospingsendworker.h \
            platforms/macos/macosstartatbootwatcher.h \
            systemtraynotificationhandler.h \
            platforms/dummy/dummyapplistprovider.h\
            tasks/authenticate/desktopauthenticationlistener.h

    OBJECTIVE_HEADERS += \
            platforms/macos/macosutils.h

    isEmpty(MVPN_MACOS) {
        message(No integration required for this build - let\'s use the dummy controller)

        SOURCES += platforms/dummy/dummycontroller.cpp
        HEADERS += platforms/dummy/dummycontroller.h
    } else {
        message(Wireguard integration)

        DEFINES += MVPN_MACOS_INTEGRATION

        OBJECTIVE_SOURCES += \
                platforms/macos/macoscontroller.mm

        OBJECTIVE_HEADERS += \
                platforms/macos/macoscontroller.h
    }

    INCLUDEPATH += \
                ../3rdparty/Wireguard-apple/WireGuard/WireGuard/Crypto \
                ../3rdparty/wireguard-apple/WireGuard/Shared/Model \

    QMAKE_MACOSX_DEPLOYMENT_TARGET = 10.14
    QMAKE_INFO_PLIST=../macos/app/Info.plist
    QMAKE_ASSET_CATALOGS_APP_ICON = "AppIcon"

    production {
        QMAKE_ASSET_CATALOGS = $$PWD/../macos/app/Images.xcassets
    } else {
        QMAKE_ASSET_CATALOGS = $$PWD/../macos/app/Images-beta.xcassets
    }
}

# Platform-specific: IOS
else:ios {
    message(IOS build)

    TARGET = MozillaVPN
    QMAKE_TARGET_BUNDLE_PREFIX = org.mozilla.ios
    QT += svg
    QT += gui-private

    # For the authentication
    LIBS += -framework AuthenticationServices

    # For notifications
    LIBS += -framework UIKit
    LIBS += -framework Foundation
    LIBS += -framework StoreKit
    LIBS += -framework UserNotifications

    DEFINES += MVPN_IOS

    SOURCES += \
            platforms/ios/taskiosproducts.cpp \
            platforms/macos/macospingsendworker.cpp

    OBJECTIVE_SOURCES += \
            platforms/ios/iaphandler.mm \
            platforms/ios/iosauthenticationlistener.mm \
            platforms/ios/iosdatamigration.mm \
            platforms/ios/iosnotificationhandler.mm \
            platforms/ios/iosutils.mm \
            platforms/macos/macoscryptosettings.mm \
            platforms/macos/macosglue.mm \
            platforms/macos/macoscontroller.mm

    HEADERS += \
            platforms/ios/taskiosproducts.h \
            platforms/macos/macospingsendworker.h

    OBJECTIVE_HEADERS += \
            platforms/ios/iaphandler.h \
            platforms/ios/iosauthenticationlistener.h \
            platforms/ios/iosdatamigration.h \
            platforms/ios/iosnotificationhandler.h \
            platforms/ios/iosutils.h \
            platforms/macos/macoscontroller.h

    QMAKE_INFO_PLIST= $$PWD/../ios/app/Info.plist
    QMAKE_ASSET_CATALOGS_APP_ICON = "AppIcon"

    production {
        QMAKE_ASSET_CATALOGS = $$PWD/../ios/app/Images.xcassets
    } else {
        QMAKE_ASSET_CATALOGS = $$PWD/../ios/app/Images-beta.xcassets
    }

    app_launch_screen.files = $$files($$PWD/../ios/app/MozillaVPNLaunchScreen.storyboard)
    QMAKE_BUNDLE_DATA += app_launch_screen

    ios_launch_screen_images.files = $$files($$PWD/../ios/app/launch.png)
    QMAKE_BUNDLE_DATA += ios_launch_screen_images
}

else:win* {
    message(Windows build)

    TARGET = MozillaVPN

    QT += networkauth
    QT += svg

    DEFINES += MVPN_WINDOWS

    SOURCES += \
        platforms/dummy/dummycontroller.cpp \
        platforms/windows/windowscryptosettings.cpp \
        platforms/windows/windowsdatamigration.cpp \
        platforms/windows/windowspingsendworker.cpp \
        tasks/authenticate/desktopauthenticationlistener.cpp \
        systemtraynotificationhandler.cpp

    HEADERS += \
        platforms/dummy/dummycontroller.h \
        platforms/windows/windowsdatamigration.h \
        platforms/windows/windowspingsendworker.h \
        tasks/authenticate/desktopauthenticationlistener.h \
        systemtraynotificationhandler.h
}

# Anything else
else {
    error(Unsupported platform)
}

exists($$PWD/../translations/translations.pri) {
    include($$PWD/../translations/translations.pri)
}
else{
    message(Languages were not imported - using fallback english)
    TRANSLATIONS += \
        ../translations/mozillavpn_en.ts

    ts.commands += lupdate $$PWD -no-obsolete -ts $$PWD/../translations/mozillavpn_en.ts
    ts.CONFIG += no_check_exist
    ts.output = $$PWD/../translations/mozillavpn_en.ts
    ts.input = .
    QMAKE_EXTRA_TARGETS += ts
    PRE_TARGETDEPS += ts
}


QMAKE_LRELEASE_FLAGS += -idbased
CONFIG += lrelease
CONFIG += embed_translations
