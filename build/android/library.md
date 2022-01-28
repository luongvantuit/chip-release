# __Build Android Required Libs__

## __Source files__

You can find source files of the Android applications in the `src/android/`
directory.

## __Requirements for building__

You need Android SDK 21 & NDK downloaded to your machine. Set the
`$ANDROID_HOME` environment variable to where the SDK is downloaded and the
`$ANDROID_NDK_HOME` environment variable to point to where the NDK package is
downloaded.


### __ABIs and TARGET_CPU__

`TARGET_CPU` can have the following values, depending on your smartphone CPU
architecture:

| ABI         | TARGET_CPU |
| ----------- | ---------- |
| armeabi-v7a | arm        |
| arm64-v8a   | arm64      |
| x86         | x86        |
| x86_64      | x64        |

### __Gradle & JDK Version__

We are using Gradle 7.1.1 for all android project which does not support Java 17
(https://docs.gradle.org/current/userguide/compatibility.html) while the default
JDK version on MacOS for Apple Silicon is 'openjdk 17.0.1' or above.

Using JDK bundled with Android Studio will help with that.

```shell
export JAVA_HOME=/Applications/Android\ Studio.app/Contents/jre/Contents/Home/
```

## __Preparing for build__

Complete the following steps to prepare the Matter build:

1. Check out the Matter repository.

2. Run bootstrap (**only required first time**)

    ```shell
    source scripts/bootstrap.sh
    ```

3. Choose how you want to build the Android CHIPTool. There are **two** ways:
   from script, or from source within Android Studio.

## __Build out CHIP__

1. In the command line, run the following command from the top Matter directory:

```
TARGET_CPU=arm64 ./scripts/examples/android_app_ide.sh
```

See the table above for other values of `TARGET_CPU`.

2. Build ninja out source:

```
cd out
ninja -C android_arm64
```

Build all 4 structure CPU: arm, arm64, x64, x86.

3. Get all file *.so *.jar structure folder:

Find file in `out/android_$TARGET_CPU`

Struct folder for module project all `TARGET_CPU`

```bash
.
├── libs
│   ├── jni
│   │   ├── armeabi-v7a
│   │   │   ├── libc++_shared.so
│   │   │   ├── libCHIPController.so
│   │   │   └── libSetupPayloadParser.so
│   │   ├── arm64-v8a
│   │   │   ├── libc++_shared.so
│   │   │   ├── libCHIPController.so
│   │   │   └── libSetupPayloadParser.so
│   │   ├── x86
│   │   │   ├── libc++_shared.so
│   │   │   ├── libCHIPController.so
│   │   │   └── libSetupPayloadParser.so
│   │   └── x86_64
│   │   │   ├── libc++_shared.so
│   │   │   ├── libCHIPController.so
│   │   │   └── libSetupPayloadParser.so
│   ├── CHIPController.jar
│   ├── AndroidPlatform.jar
│   └── SetupPayloadParser.jar
└──
```

Copy to `libs` folder in module in project.

4. Config file `build.gradle` module

```gradle
android {
    ... 
    defaultConfig {
        externalNativeBuild {
            cmake {
                targets "default"
            }
        }
    }

    ...
    // Not requirement.
    configurations.all {
        resolutionStrategy.eachDependency { DependencyResolveDetails details ->
            def requested = details.requested
            if (requested.group == "androidx") {
                if (!requested.name.startsWith("multidex")) {
                    details.useVersion "${targetSdk}.+"
                }
            }
        }
    }

    ...
    sourceSets {
        main {
            jniLibs.srcDirs = ['libs/jni'] // Path library jni folder contain *.so file.
        }
    }
}
```


```gradle
dependencies {
    ...
    implementation fileTree(dir: "libs", include: ["*.jar", "*.so"])
}
```

Run __Sync Project__ 

