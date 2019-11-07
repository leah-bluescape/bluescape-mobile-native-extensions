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
    
    guard let styles = styles as? [String: Any],
          let fontSize = styles["fontSize"] as? Int,
          let fontName = styles["fontFamily"] as? String,
          let width = styles["width"] as? Float
    else {
      reject("Styles Missing", "styles missing", nil)
      return
    }

    let sizeNumber: CGFloat = CGFloat(fontSize)
    guard sizeNumber > 0,
          let font = fontName.isEmpty ? UIFont(name: "Dosis", size: sizeNumber) : UIFont(name: fontName, size: sizeNumber)
    else {
      reject("Item Font Size", "Item font size cannot be negative", nil)
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
