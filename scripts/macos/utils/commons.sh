#!/bin/bash

# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Internal methods

_cleanup() {
  rm -rf "$1" "$2" || die
  rm -rf .qm .moc .obj .rcc || die
}

_qmake() {
  QMAKE=qmake
  if [[ "$QT_MACOS_BIN" ]]; then
    QT_BIN=$QT_MACOS_BIN
    QMAKE="$QT_BIN/qmake"
    export PATH="$QT_BIN:$PATH"
  fi

  [ -d "$2" ] && die "Unexpected $2 folder"

  $QMAKE \
    -spec macx-xcode \
    QTPLUGIN+=qsvg \
    MVPN_MACOS=1 \
    CONFIG-=debug CONFIG+=release CONFIG-=debug_and_release \
    CONFIG+=sdk_no_version_check \
    QMAKE_CXXFLAGS+=--coverage QMAKE_LFLAGS+=--coverage \
    "$1" || die "Compilation failed"

  [ -d "$2" ] || die "Expected $2 folder"
}

_compile() {
  [ -f "$2" ] && die "Unexpected $2 binary"

  xcodebuild build \
  HEADER_SEARCH_PATHS="\$(HEADER_SEARCH_PATHS) $(brew --prefix oath-toolkit)/include" \
    CODE_SIGN_IDENTITY="" \
    CODE_SIGNING_REQUIRED=NO \
    -derivedDataPath=/build \
    -resultBundlePath=/tmp \
    -enableCodeCoverage=YES \
    -project "$1" || die

  [ -f "$2" ] || die "Expected $2 binary"
}

# Public methods

## Unit-tests

utest_dependencies() {
  brew install oath-toolkit || die
}

utest_compile_unit() {
  _qmake tests/unit/unit.pro tests.xcodeproj/|| die
  _compile tests.xcodeproj ./Release/tests || die
}

utest_compile_auth() {
  _qmake tests/auth/auth.pro tests.xcodeproj/ || die
  _compile tests.xcodeproj ./Release/tests || die
}

utest_compile_nativemessaging() {
  _qmake tests/nativemessaging/nativemessaging.pro tests.xcodeproj/ || die
  _compile tests.xcodeproj ./Release/tests || die

  (cd extension/bridge && cargo build --release) || die
  [ -f extension/bridge/target/release/mozillavpnnp ] || die "Expected extension/bridge/target/release/mozillavpnnp"
}

utest_run_unit() {
  ./Release/tests || die
}

utest_run_auth() {
  ./Release/tests || die
}

utest_run_nativemessaging() {
  ./Release/tests extension/bridge/target/release/mozillavpnnp || die
}

utest_cleanup_unit() {
  _cleanup tests.xcodeproj/ ./Release/tests || die
}

utest_cleanup_auth() {
  _cleanup tests.xcodeproj/ ./Release/tests || die
}

utest_cleanup_nativemessaging() {
  (cd extension/bridge && cargo clean) || die
  _cleanup tests.xcodeproj/ ./Release/tests || die
}

## Lottie tests

lottie_compile_unit() {
  _qmake lottie/tests/unit/unit.pro lottie_tests.xcodeproj || die
  _compile lottie_tests.xcodeproj ./Release/lottie_tests || die
}

lottie_compile_qml() {
  _qmake lottie/tests/qml/qml.pro tst_lottie.xcodeproj || die
  _compile tst_lottie.xcodeproj ./Release/tst_lottie || die
}

lottie_run_unit() {
  ./Release/lottie_tests || die
}

lottie_run_qml() {
  ./Release/tst_lottie || die
}

lottie_cleanup_unit() {
  _cleanup lottie_tests.xcodeproj ./Release/lottie_tests || die
}

lottie_cleanup_qml() {
  _cleanup tst_lottie.xcodeproj ./Release/tst_lottie || die
}

## QML tests

qmltest_compile() {
  _qmake tests/qml/qml.pro qml_tests.xcodeproj || die
  _compile qml_tests.xcodeproj ./Release/qml_tests || die
}

qmltest_run() {
  ./Release/qml_tests || die
}

qmltest_cleanup() {
  _cleanup qml_tests.xcodeproj ./Release/qml_tests || die
}