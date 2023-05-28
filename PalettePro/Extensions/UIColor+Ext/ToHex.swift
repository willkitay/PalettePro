//
//  ToHex.swift
//  PalettePro
//
//  Created by Will Kitay on 5/27/23.
//

import UIKit

extension UIColor {
  func toHex() -> String {
    let colorSpaceRGB = CGColorSpaceCreateDeviceRGB() // Use RGB color space explicitly
    guard let color = self.cgColor.converted(to: colorSpaceRGB, intent: .defaultIntent, options: nil),
          let components = color.components,
          components.count >= 3 else {
      return ""
    }
    
    let r = components[0]
    let g = components[1]
    let b = components[2]
    
    let hexString = String(format: "#%02lX%02lX%02lX", lroundf(Float(r * 255)), lroundf(Float(g * 255)), lroundf(Float(b * 255)))
    return hexString
  }
}
