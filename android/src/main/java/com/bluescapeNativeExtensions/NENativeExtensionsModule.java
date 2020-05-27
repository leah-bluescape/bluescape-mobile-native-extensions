package com.bluescapeNativeExtensions;

import android.graphics.Typeface;
import android.text.Layout;
import android.text.StaticLayout;
import android.text.TextPaint;
import android.util.Log;

import com.facebook.react.bridge.NativeModule;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.bridge.WritableNativeMap;
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
            validateStyleValue("actualWidth", styles);
            validateStyleValue("fontFamily", styles);
            validateStyleValue("fontSize", styles);
            validateStyleValue("fontWeight", styles);
            validateStyleValue("fontStyle", styles);

            String fontFamily = "fonts/" + styles.getString("fontFamily");
            String fontWeight = styles.getString("fontWeight");
            String fontStyle = styles.getString("fontStyle");
            float fontSize = (float) styles.getInt("fontSize");

            Typeface fontTypeface = Typeface.createFromAsset(getCurrentActivity().getAssets(), fontFamily);

            int weight = ((fontWeight == "bold") ? Typeface.BOLD : Typeface.NORMAL);
            boolean isItalic = (fontStyle == "italic");

            Typeface plain = Typeface.create(fontTypeface, weight, isItalic);
            TextPaint paint = new TextPaint();
            paint.setTypeface(plain);
            paint.setTextSize(fontSize);

            StaticLayout newLayout = measure(paint, text, (int) styles.getDouble("actualWidth"));
            float width = newLayout.getWidth();
            float height = newLayout.getHeight();

            WritableMap contentSize = new WritableNativeMap();
            contentSize.putDouble("height", (double) height);
            contentSize.putDouble("width", (double) width);

            promise.resolve(contentSize);
        } catch (IllegalViewOperationException e) {
            promise.reject(e);
        }
    }

    private void validateStyleValue( String key, ReadableMap styles ) {
        if (!styles.hasKey(key) || styles.isNull(key)) {
            throw new IllegalViewOperationException("Invalid parameters: " + key + " is invalid");
        }
    }

    private StaticLayout measure( TextPaint textPaint, String text, Integer wrapWidth ) {
        int boundedWidth = Integer.MAX_VALUE;
        if (wrapWidth != null && wrapWidth > 0 ) {
            boundedWidth = wrapWidth;
        }
        StaticLayout layout = new StaticLayout( text, textPaint, boundedWidth, Layout.Alignment.ALIGN_NORMAL, 1.0f, 0.0f, false );
        return layout;
    }

    private float getMaxLineWidth( StaticLayout layout ) {
        float maxLine = 0.0f;
        int lineCount = layout.getLineCount();
        for( int i = 0; i < lineCount; i++ ) {
            if( layout.getLineWidth( i ) > maxLine ) {
                maxLine = layout.getLineWidth( i );
            }
        }
        return maxLine;
    }
}
