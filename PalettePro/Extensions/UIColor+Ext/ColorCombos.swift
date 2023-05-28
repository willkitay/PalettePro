//
//  ColorCombos.swift
//  PalettePro
//
//  Created by Will Kitay on 5/27/23.
//

import UIKit

extension UIColor {
  
  var complement: UIColor {
    return self.withHueOffset(0.5)
  }
  
  var splitComplement0: UIColor {
    return self.withHueOffset(150 / 360)
  }
  
  var splitComplement1: UIColor {
    return self.withHueOffset(210 / 360)
  }
  
  var triadic0: UIColor {
    return self.withHueOffset(120 / 360)
  }
  
  var triadic1: UIColor {
    return self.withHueOffset(240 / 360)
  }
  
  var tetradic0: UIColor {
    return self.withHueOffset(0.25)
  }
  
  var tetradic1: UIColor {
    return self.complement
  }
  
  var tetradic2: UIColor {
    return self.withHueOffset(0.75)
  }
  
  var analagous0: UIColor {
    return self.withHueOffset(-1 / 12)
  }
  
  var analagous1: UIColor {
    return self.withHueOffset(1 / 12)
  }
  
  func withHueOffset(_ offset: CGFloat) -> UIColor {
    var h: CGFloat = 0
    var s: CGFloat = 0
    var b: CGFloat = 0
    var a: CGFloat = 0
    self.getHue(&h, saturation: &s, brightness: &b, alpha: &a)
    return UIColor(hue: fmod(h + offset, 1), saturation: s, brightness: b, alpha: a)
  }
}
