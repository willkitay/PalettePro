//
//  UIView+Ext.swift
//  PalettePro
//
//  Created by Will Kitay on 5/21/23.
//

import UIKit

extension UIView {
  
  func addSubviews(_ views: UIView...) {
    for view in views { addSubview(view) }
  }
  
  func pinToEdges(of superview: UIView) {
    translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      topAnchor.constraint(equalTo: superview.topAnchor),
      leadingAnchor.constraint(equalTo: superview.leadingAnchor),
      trailingAnchor.constraint(equalTo: superview.trailingAnchor),
      bottomAnchor.constraint(equalTo: superview.bottomAnchor),
    ])
  }
  
}
