//
//  UIColor+Ext.swift
//  PalettePro
//
//  Created by Will Kitay on 5/21/23.
//

import UIKit

extension UIColor {
  
  static func generateRandomColor() -> UIColor {
    return UIColor(
      red: CGFloat.random(in: 0...1),
      green: CGFloat.random(in: 0...1),
      blue: CGFloat.random(in: 0...1),
      alpha: 1.0)
  }
  
  func toHex() -> String? {
    guard let components = self.cgColor.components, components.count >= 3 else {
      return nil
    }
    let r = Float(components[0])
    let g = Float(components[1])
    let b = Float(components[2])
    var a = Float(1.0)
    
    if components.count >= 4 {
      a = Float(components[3])
    }
    
    if a != Float(1.0) {
      return String(format: "%02lX%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255), lroundf(a * 255))
    } else {
      return String(format: "%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255))
    }
  }
  
  private static func contrastRatio(between color1: UIColor, and color2: UIColor) -> CGFloat {
    // https://www.w3.org/TR/WCAG20-TECHS/G18.html#G18-tests
    
    let luminance1 = color1.luminance()
    let luminance2 = color2.luminance()
    
    let luminanceDarker = min(luminance1, luminance2)
    let luminanceLighter = max(luminance1, luminance2)
    
    return (luminanceLighter + 0.05) / (luminanceDarker + 0.05)
  }
  
  func contrastRatio(with color: UIColor) -> CGFloat {
    return UIColor.contrastRatio(between: self, and: color)
  }
  
  private func luminance() -> CGFloat {
    // https://www.w3.org/TR/WCAG20-TECHS/G18.html#G18-tests
    
    let ciColor = CIColor(color: self)
    
    func adjust(colorComponent: CGFloat) -> CGFloat {
      return (colorComponent < 0.04045) ? (colorComponent / 12.92) : pow((colorComponent + 0.055) / 1.055, 2.4)
    }
    
    return 0.2126 * adjust(colorComponent: ciColor.red) + 0.7152 * adjust(colorComponent: ciColor.green) + 0.0722 * adjust(colorComponent: ciColor.blue)
  }
}
