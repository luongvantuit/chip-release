set -e

CHIP_ROOT="$(dirname "$0")"

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

cd out 

ninja_build() {
    ninja -C android_$1
}

ninja_build "arm64"
ninja_build "arm"
ninja_build "x64"
ninja_build "x86"

