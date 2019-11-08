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
                               resolver resolve: @escaping RCTPromiseResolveBlock,
                               rejecter reject: @escaping RCTPromiseRejectBlock ) -> Void {
    
    guard let styles = styles as? [String: Any] else {
      reject("Invalid parameters", "Style object is invalid", nil)
      return
    }
    
    guard let fontSize = styles["fontSize"] as? Int else {
      reject("Invalid parameters", "Font Size is invalid", nil)
      return
    }
    
    let sizeNumber: CGFloat = CGFloat(fontSize)
    guard sizeNumber > 0 else {
      reject("Invalid parameters", "Font Size cannot be negative", nil)
      return
    }
    
    guard let fontName = styles["fontFamily"] as? String,
          let font = fontName.isEmpty ? UIFont(name: "Dosis", size: sizeNumber) : UIFont(name: fontName, size: sizeNumber)
    else {
      reject("Invalid parameters", "Font Name is invalid", nil)
      return
    }
    
    guard let width = styles["width"] as? NSNumber else {
      reject("Invalid parameters", "Item width is invalid", nil)
      return
    }

    let contentSize = getContentHeightWithSetWidth(for: text, width: CGFloat(truncating: width), font: font)

    resolve([contentSize.width, contentSize.height])
  }
  
  func getContentHeightWithSetWidth(for text: String, width: CGFloat, font: UIFont) -> CGSize {
    let contentRect = NSString(string: text).boundingRect(with: CGSize(width: width, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin), attributes: [NSAttributedString.Key.font : font], context: nil)
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
