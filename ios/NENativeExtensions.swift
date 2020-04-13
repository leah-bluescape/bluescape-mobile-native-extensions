//
//  NENativeExtensions.swift
//  bluescape_mobile
//
//  Created by Leah Xia on 2019-11-04.
//  Copyright © 2019 Facebook. All rights reserved.
//

import Foundation

@objc(NENativeExtensions)
class NENativeExtensions: NSObject {
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
    
    guard let fontName = styles["fontFamily"] as? String else {
      reject("Invalid parameters", "Font Name is invalid", nil)
      return
    }

    guard let fontWeight = styles["fontWeight"] as? String else {
      reject("Invalid parameters", "Font Weight is invalid", nil)
      return
    }
    
    guard let fontStyle = styles["fontStyle"] as? String else {
      reject("Invalid parameters", "Font Style is invalid", nil)
      return
    }
    
    guard let width = styles["width"] as? NSNumber else {
      reject("Invalid parameters", "Item width is invalid", nil)
      return
    }

    var font = UIFont(name: "Dosis", size: sizeNumber)
    if fontWeight == "bold" || fontStyle == "italic" {
      let descriptor = UIFontDescriptor(name: fontName, size: CGFloat(fontSize))
      if fontWeight == "bold" {
        descriptor.withSymbolicTraits(.traitBold)
      }
      if fontStyle == "italic" {
        descriptor.withSymbolicTraits(.traitItalic)
      }
      font = UIFont(descriptor: descriptor, size: CGFloat(fontSize))
    } else {
      font = UIFont(name: fontName, size: sizeNumber)
    }

    guard let customFont = font else {
      reject("Invalid parameters", "Font Name is invalid", nil)
      return
    }

    let widthNumber = CGFloat(truncating: width)
    let contentSize = getContentHeightWithSetWidth(for: text, width: widthNumber, font: customFont)
    resolve(["width": contentSize.width, "height": contentSize.height])
  }
  
  func getContentHeightWithSetWidth(for text: String, width: CGFloat, font: UIFont) -> CGSize {
    let boundSize = CGSize(width: width, height: .greatestFiniteMagnitude)
    let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
    let attributes = [NSAttributedString.Key.font : font]
    let contentRect = NSString(string: text).boundingRect(with: boundSize, options: options, attributes: attributes, context: nil)
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
