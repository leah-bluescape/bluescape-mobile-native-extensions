package com.bluescapeNativeExtensions;

import android.content.res.AssetManager;
import com.bluescapeNativeExtensions.Services.TextSizeCalculator;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.uimanager.IllegalViewOperationException;

public class NENativeExtensionsModule extends ReactContextBaseJavaModule {

    private final ReactApplicationContext reactContext;

    public NENativeExtensionsModule(ReactApplicationContext reactContext) {
        super(reactContext); //required by React Native
        this.reactContext = reactContext;
    }

    @Override
    //getName is required to define the name of the module represented in JavaScript
    public String getName() {
        return "NENativeExtensions";
    }

    @ReactMethod
    public void calculateTextSize(String text, ReadableMap styles, Promise promise) {
        try {
            AssetManager assetManager = getCurrentActivity().getAssets();
            WritableMap contentSize = TextSizeCalculator.calculatedTextSize(assetManager, text, styles);
            promise.resolve(contentSize);
        } catch (IllegalViewOperationException e) {
            promise.reject(e);
        }
    }
}
