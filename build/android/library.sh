#!/usr/bin/env bash

set -e

CHIP_ROOT=`pwd`

git -C "$CHIP_ROOT" submodule update --init

source "$CHIP_ROOT/scripts/activate.sh"

echo
echo 'To re-create the build environment from scratch, run:'
echo source "$CHIP_ROOT/scripts/bootstrap.sh"

if [ -z "$ANDROID_HOME" ]; then
    echo "ANDROID_HOME not set!"
    exit 1
fi

if [ -z "$ANDROID_NDK_HOME" ]; then
    echo "ANDROID_NDK_HOME not set!"
    exit 1
fi

python3 build/chip/java/tests/generate_jars_for_test.py
python3 third_party/android_deps/set_up_android_deps.py

gn_build() {
    gn gen --check --fail-on-unused-args out/"android_$1" --args="target_os=\"android\" target_cpu=\"$1\" android_ndk_root=\"$ANDROID_NDK_HOME\" android_sdk_root=\"$ANDROID_HOME\"" --ide=json --json-ide-script=//scripts/examples/gn_to_cmakelists.py
}

gn_build "arm64"
gn_build "arm"
gn_build "x64"
gn_build "x86"

cd $CHIP_ROOT/out 

ninja_build() {
    ninja -C android_$1
}

ninja_build "arm64"
ninja_build "arm"
ninja_build "x64"
ninja_build "x86"

if [ ! -d $CHIP_ROOT/"release" ] 
then
    mkdir $CHIP_ROOT/"release"
fi

if [ ! -d $CHIP_ROOT/"release"/jni ] 
then
    mkdir $CHIP_ROOT/"release"/jni
fi

render_release() {
    if [ ! -d $CHIP_ROOT/"release"/jni/$2 ] 
    then
        mkdir $CHIP_ROOT/"release"/jni/$2
    fi
    echo "Make release cpu structure is $1"
    cp $CHIP_ROOT/out/android_$1/lib/jni/$2/libc++_shared.so $CHIP_ROOT/"release"/jni/$2
    cp $CHIP_ROOT/out/android_$1/lib/jni/$2/libCHIPController.so $CHIP_ROOT/"release"/jni/$2
    cp $CHIP_ROOT/out/android_$1/lib/jni/$2/libSetupPayloadParser.so $CHIP_ROOT/"release"/jni/$2
}

render_release "arm64" "arm64-v8a"
render_release "arm" "armeabi-v7a"
render_release "x86" "x86"
render_release "x64" "x86_64"

cp $CHIP_ROOT/out/android_arm64/lib/src/controller/java/CHIPController.jar $CHIP_ROOT/"release"
cp $CHIP_ROOT/out/android_arm64/lib/src/platform/android/AndroidPlatform.jar $CHIP_ROOT/"release"
cp $CHIP_ROOT/out/android_arm64/lib/src/setup_payload/java/SetupPayloadParser.jar $CHIP_ROOT/"release"