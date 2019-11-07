//
//  NativeExtensions.swift
//  bluescape_mobile
//
//  Created by Leah Xia on 2019-11-04.
//  Copyright © 2019 Facebook. All rights reserved.
//

import Foundation

@objc(NativeExtensions)
class NativeExtensions: NSObject {
  @objc func calculateTextSize(_ text: String, styles: NSDictionary,
                               resolver resolve: RCTPromiseResolveBlock,
                               rejecter reject: RCTPromiseRejectBlock ) -> Void {
    
    guard let styles = styles as? [String: Any] else {
      reject("Style object is invalid")
      return
    }
    
    guard let fontSize = styles["fontSize"] as? Int else {
      reject("Font Size is invalid")
      return
    }
    
    guard let sizeNumber: CGFloat = CGFloat(fontSize), sizeNumber > 0 else {
      reject("Font Size cannot be negative")
      return
    }
    
    guard let fontName = styles["fontFamily"] as? String,
          let font = fontName.isEmpty ? UIFont(name: "Dosis", size: sizeNumber) : UIFont(name: fontName, size: sizeNumber)
    else {
      reject("Font Name is invalid")
      return
    }
    
    guard let width = styles["width"] as? Float else {
      reject("Item width is invalid")
      return
    }

    let contentSize = getContentHeightWithSetWidth(for: text, width: CGFloat(width), font: font)

    resolve([contentSize.width, contentSize.height])
  }
  
  func getContentHeightWithSetWidth(for text: String, width: CGFloat, font: UIFont) -> CGSize {
    let contentRect = NSString(string: text).boundingRect(with: CGSize(width: width, height: 10000), options: NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin), attributes: [NSAttributedString.Key.font : font], context: nil)
    return contentRect.size
  }
  
  func getContentWithSetHeight(for text: String, with font: UIFont) -> CGSize {
    let attributes: [NSAttributedString.Key : Any] = [NSAttributedString.Key.font: font]
    let contentSize = text.size(withAttributes: attributes)
    return contentSize
  }
  
  @objc static func requiresMainQueueSetup() -> Bool {
    return true
  }
}
