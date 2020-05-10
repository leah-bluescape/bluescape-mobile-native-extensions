package com.bluescapeNativeExtensions.Services;

import android.content.res.AssetManager;
import android.graphics.Typeface;
import android.os.Build;
import android.text.Layout;
import android.text.StaticLayout;
import android.text.TextPaint;

import androidx.annotation.RequiresApi;

import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.bridge.WritableNativeMap;
import com.facebook.react.uimanager.IllegalViewOperationException;

public class TextSizeCalculator {

    @ReactMethod
    static public WritableMap calculatedTextSize(AssetManager assetManager, String text, ReadableMap styles) {
        try {
            validateStyleValue("width", styles);
            validateStyleValue("height", styles);
            validateStyleValue("fontFamily", styles);
            validateStyleValue("fontSize", styles);
            validateStyleValue("fontWeight", styles);
            validateStyleValue("fontStyle", styles);

            String fontFamily = "fonts/" + styles.getString("fontFamily");
            String fontWeight = styles.getString("fontWeight");
            String fontStyle = styles.getString("fontStyle");
            float fontSize = (float) styles.getInt("fontSize");

            Typeface fontTypeface = Typeface.createFromAsset(assetManager, fontFamily);

            int weight = ((fontWeight == "bold") ? Typeface.BOLD : Typeface.NORMAL);
            boolean isItalic = (fontStyle == "italic");

            Typeface plain = Typeface.create(fontTypeface, weight, isItalic);
            TextPaint paint = new TextPaint();
            paint.setTypeface(plain);
            paint.setTextSize(fontSize);

            StaticLayout newLayout = measure(paint, text, (int) styles.getDouble("width"));
            float width = newLayout.getWidth();
            float height = newLayout.getHeight();

            WritableMap contentSize = new WritableNativeMap();
            contentSize.putDouble("height", (double) height);
            contentSize.putDouble("width", (double) width);

            return contentSize;
        } catch (IllegalViewOperationException e) {
            throw e;
        }
    }

    static private void validateStyleValue( String key, ReadableMap styles ) {
        if (!styles.hasKey(key) || styles.isNull(key)) {
            throw new IllegalViewOperationException("Invalid parameters: " + key + " is invalid");
        }
    }

    static private StaticLayout measure( TextPaint textPaint, String text, Integer wrapWidth ) {
        int boundedWidth = Integer.MAX_VALUE;
        if (wrapWidth != null && wrapWidth > 0 ) {
            boundedWidth = wrapWidth;
        }
        StaticLayout layout = new StaticLayout(
                text,
                textPaint,
                boundedWidth,
                Layout.Alignment.ALIGN_NORMAL,
                1.0f,
                0.0f,
                false );
        return layout;
    }
}
