# __Pair Device__

## __Step 1:__ Make Chip Device Controller

- __Java__

```java

import android.content.Context;
import chip.devicecontroller.ChipDeviceController;
import chip.devicecontroller.GetConnectedDeviceCallbackJni.GetConnectedDeviceCallback;
import chip.platform.AndroidBleManager;
import chip.platform.AndroidChipPlatform;
import chip.platform.ChipMdnsCallbackImpl;
import chip.platform.NsdManagerServiceResolver;
import chip.platform.PreferencesConfigurationManager;
import chip.platform.PreferencesKeyValueStoreManager;
...

private static ChipDeviceController mChipDeviceController;
private static AndroidChipPlatform mAndroidChipPlatform;

public static ChipDeviceController getDeviceController(Context context) {
    getAndroidChipPlatform(context);

    if (mChipDeviceController == null) {

        mChipDeviceController = ChipDeviceController();
      
    }

    return mChipDeviceController;
}

public static AndroidChipPlatfrom getAndroidChipPlatform(@Nullable Context context) {

    if (mAndroidChipPlatform == null && context != null) {

        ChipDeviceController.loadJni();
        mAndroidChipPlatform = new AndroidChipPlatform(new AndroidBleManager(),PreferencesKeyValueStoreManager(context), PreferencesConfigurationManager(context), NsdManagerServiceResolver(context), ChipMdnsCallbackImpl());
        
    }
    return mAndroidChipPlatform;
}


```

## __Step 2:__ Pair Device with Address or BLE Connection

ChipDeviceController required execution function loadJni before new AndroidChipPlatform

- __ChipDeviceController__

```java
pairDevice(BluetoothGatt bleServer,int connId,long deviceId,long setupPincode,@Nullable byte[] csrNonce,NetworkCredentials networkCredentials);
```

Connect Device with BLE

```java
pairDeviceWithAddress(long deviceId,String address,int port,int discriminator,long pinCode,@Nullable byte[] csrNonce);
```

Connect Device with Ip Address
