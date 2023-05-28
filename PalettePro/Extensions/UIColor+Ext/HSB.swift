//
//  HSB+Ext.swift
//  PalettePro
//
//  Created by Will Kitay on 5/27/23.
//

import UIKit

extension UIColor {
  func toHSB() -> (h: CGFloat, s: CGFloat, b: CGFloat) {
    var hue: CGFloat = 0
    var saturation: CGFloat = 0
    var brightness: CGFloat = 0
    var alpha: CGFloat = 0
    
    self.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
    
    return (h: hue, s: saturation, b: brightness)
  }
}
