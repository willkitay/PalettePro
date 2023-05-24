//
//  UIColor+Ext.swift
//  PalettePro
//
//  Created by Will Kitay on 5/21/23.
//

import UIKit

extension UIColor {
  
  func lighter(by percentage: CGFloat = 30.0) -> UIColor? {
    return self.adjust(by: abs(percentage) )
  }
  
  func darker(by percentage: CGFloat = 30.0) -> UIColor? {
    return self.adjust(by: -1 * abs(percentage) )
  }
  
  func adjust(by percentage: CGFloat = 30.0) -> UIColor? {
    guard let components = cgColor.components, components.count >= 3 else {
      return nil
    }
    
    var r = components[0]
    var g = components[1]
    var b = components[2]
    let a = components[3]
        
    // Calculate the adjusted color components
    r = min(max(r + (percentage / 100.0), 0.0), 1.0)
    g = min(max(g + (percentage / 100.0), 0.0), 1.0)
    b = min(max(b + (percentage / 100.0), 0.0), 1.0)
    
    return UIColor(red: r, green: g, blue: b, alpha: a)
  }
  
  static func generateRandomColor() -> UIColor {
    return UIColor(
      red: CGFloat.random(in: 0...1),
      green: CGFloat.random(in: 0...1),
      blue: CGFloat.random(in: 0...1),
      alpha: 1.0)
  }
  
  convenience init?(hex: String) {
    var hexString = hex
    if hexString.hasPrefix("#") { // Remove the '#' prefix if added.
      let start = hexString.index(hexString.startIndex, offsetBy: 1)
      hexString = String(hexString[start...])
    }
    if hexString.lowercased().hasPrefix("0x") { // Remove the '0x' prefix if added.
      let start = hexString.index(hexString.startIndex, offsetBy: 2)
      hexString = String(hexString[start...])
    }
    
    let r, g, b, a: CGFloat
    let scanner = Scanner(string: hexString)
    var hexNumber: UInt64 = 0
    guard scanner.scanHexInt64(&hexNumber) else { return nil } // Make sure the string is a hex code.
    switch hexString.count {
    case 3, 4: // Color is in short hex format
      var updatedHexString = ""
      hexString.forEach { updatedHexString.append(String(repeating: String($0), count: 2)) }
      hexString = updatedHexString
      self.init(hex: hexString)
      
    case 6: // Color is in hex format without alpha.
      r = CGFloat((hexNumber & 0xFF0000) >> 16) / 255.0
      g = CGFloat((hexNumber & 0x00FF00) >> 8) / 255.0
      b = CGFloat(hexNumber & 0x0000FF) / 255.0
      a = 1.0
      self.init(red: r, green: g, blue: b, alpha: a)
      
    case 8: // Color is in hex format with alpha.
      r = CGFloat((hexNumber & 0xFF000000) >> 24) / 255.0
      g = CGFloat((hexNumber & 0x00FF0000) >> 16) / 255.0
      b = CGFloat((hexNumber & 0x0000FF00) >> 8) / 255.0
      a = CGFloat(hexNumber & 0x000000FF) / 255.0
      self.init(red: r, green: g, blue: b, alpha: a)
      
    default: // Invalid format.
      return nil
    }
  }
  
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
