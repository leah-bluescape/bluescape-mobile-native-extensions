package com.reactlibrary;

import com.facebook.react.bridge.NativeModule;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.WritableArray;
import com.facebook.react.bridge.WritableNativeArray;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.uimanager.IllegalViewOperationException;

public class NativeExtensionsModule extends ReactContextBaseJavaModule {

    public NativeExtensionsModule(ReactApplicationContext reactContext) {
        super(reactContext); //required by React Native
    }

    @Override
    //getName is required to define the name of the module represented in JavaScript
    public String getName() {
        return "NativeExtensions";
    }

    @ReactMethod
    public void calculateTextSize(String text, ReadableMap styles, Promise promise) {
        try {
            WritableArray contentSize = new WritableNativeArray();
            if (styles.hasKey("width") && !styles.isNull("width")) {
                contentSize.pushDouble(styles.getDouble("width"));
                System.out.println(contentSize);
            }

            if (styles.hasKey("height") && !styles.isNull("height")) {
                contentSize.pushDouble(styles.getDouble("height"));
                System.out.println(contentSize);
            }
            promise.resolve(contentSize);
        } catch (IllegalViewOperationException e) {
            promise.reject(e);
        }
    }
}