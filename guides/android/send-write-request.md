# __Send Write Request__

[AndroidBleManager](https://github.com/project-chip/connectedhomeip/blob/master/src/platform/android/java/chip/platform/AndroidBleManager.java)

Subscribe Characteristic

```java
onSubscribeCharacteristic(int connId, byte[] svcId, byte[] charId);
```

Unsubscribe Characteristic

```java
onUnsubscribeCharacteristic(int connId, byte[] svcId, byte[] charId);
```

Send Write Request 

```java
onSendWriteRequest(int connId, byte[] svcId, byte[] charId, byte[] characteristicData);
```