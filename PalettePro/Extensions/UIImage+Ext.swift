//
//  UIImage+Ext.swift
//  PalettePro
//
//  Created by Will Kitay on 6/4/23.
//

import UIKit

extension UIImage {
  func imageWithInsets(insets: UIEdgeInsets) -> UIImage? {
    UIGraphicsBeginImageContextWithOptions(
      CGSize(width: self.size.width + insets.left + insets.right,
             height: self.size.height + insets.top + insets.bottom), false, self.scale)
    let _ = UIGraphicsGetCurrentContext()
    let origin = CGPoint(x: insets.left, y: insets.top)
    self.draw(at: origin)
    let imageWithInsets = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return imageWithInsets
  }
}
