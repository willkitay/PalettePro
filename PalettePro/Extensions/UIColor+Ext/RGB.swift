//
//  RGB.swift
//  PalettePro
//
//  Created by Will Kitay on 5/21/23.
//

import UIKit

extension UIColor {

  var redValue: CGFloat{ return CIColor(color: self).red }
  
  var greenValue: CGFloat{ return CIColor(color: self).green }
  
  var blueValue: CGFloat{ return CIColor(color: self).blue }
  
  var alphaValue: CGFloat{ return CIColor(color: self).alpha }

}
