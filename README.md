# bluescape-mobile-native-extensions

## Getting started

`$ npm install @leahxia/bluescape-mobile-native-extensions --save`
`$ npm react-native link @leahxia/bluescape-mobile-native-extensions`

## Usage
```javascript
import NativeModules from '@leahxia/bluescape-mobile-native-extensions';

NativeModules.TextContentSize.calculateTextSize(text, item.fontFamily, item.fontSize): Promise<number[]>;
```
