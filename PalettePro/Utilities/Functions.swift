//
//  Functions.swift
//  PalettePro
//
//  Created by Will Kitay on 5/21/23.
//

import UIKit

func getComplementaryColors(from color: UIColor) -> [UIColor] {
  let hsb = color.toHSB()
  let complementaryHue = (hsb.h + 0.5).truncatingRemainder(dividingBy: 1.0)
  let complementaryColor = UIColor(hue: complementaryHue, saturation: hsb.s, brightness: hsb.b, alpha: 1.0)
  return [complementaryColor, color]
}

func getContrastTextColor(for backgroundColor: UIColor?) -> UIColor {
  return backgroundColor?.contrastRatio(with: .white) ?? 0 > 3 ? .white : .black
}

func hexToCMYK(hexCode: String) -> (c: Int, m: Int, y: Int, k: Int)? {
  var hex = hexCode
  if hex.hasPrefix("#") {
    hex = String(hex.dropFirst())
  }
  
  // Convert hexadecimal to RGB values
  guard let rgb = Int(hex, radix: 16) else {
    return nil
  }
  let r = CGFloat((rgb >> 16) & 0xFF) / 255.0
  let g = CGFloat((rgb >> 8) & 0xFF) / 255.0
  let b = CGFloat(rgb & 0xFF) / 255.0
  
  // Convert RGB to CMYK
  let k = 1.0 - max(r, g, b)
  if k == 1.0 {  // Handle black color separately
    return (0, 0, 0, 100)
  }
  
  let c = (1.0 - r - k) / (1.0 - k)
  let m = (1.0 - g - k) / (1.0 - k)
  let y = (1.0 - b - k) / (1.0 - k)
  
  // Convert CMYK values to percentages
  let cPercentage = Int(round(c * 100))
  let mPercentage = Int(round(m * 100))
  let yPercentage = Int(round(y * 100))
  let kPercentage = Int(round(k * 100))
  
  return (cPercentage, mPercentage, yPercentage, kPercentage)
}

func colorToHSL(_ color: UIColor) -> (h: Int, s: Int, l: Int) {
  var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
  if color.getRed(&r, green: &g, blue: &b, alpha: &a) {
    let rgb = (r, g, b)
    let hsl = rgbToHSL(rgb)
    let h = Int(hsl.h * 360)
    let s = Int(hsl.s * 100)
    let l = Int(hsl.l * 100)
    return (h, s, l)
  }
  return (h: 0, s: 0, l: 0)
}

func rgbToHSL(_ rgb: (r: CGFloat, g: CGFloat, b: CGFloat)) -> (h: CGFloat, s: CGFloat, l: CGFloat) {
  let r = rgb.r
  let g = rgb.g
  let b = rgb.b
  
  let maxVal = max(r, g, b)
  let minVal = min(r, g, b)
  var h: CGFloat = 0
  var s: CGFloat = 0
  let l = (maxVal + minVal) / 2
  
  if maxVal == minVal {
    h = 0
    s = 0
  } else {
    let d = maxVal - minVal
    s = l > 0.5 ? d / (2 - maxVal - minVal) : d / (maxVal + minVal)
    
    switch maxVal {
    case r:
      h = (g - b) / d + (g < b ? 6 : 0)
    case g:
      h = (b - r) / d + 2
    case b:
      h = (r - g) / d + 4
    default:
      break
    }
    
    h /= 6
  }
  
  return (h, s, l)
}

