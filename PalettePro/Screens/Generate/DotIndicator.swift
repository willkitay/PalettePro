//
//  DotIndicator.swift
//  PalettePro
//
//  Created by Will Kitay on 5/23/23.
//

import UIKit

class DotIndicator: UIView {
  
  let id = UUID()
    
  override init(frame: CGRect) {
    super.init(frame: frame)
    configure()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func configure() {
//    backgroundColor = .black
    layer.cornerRadius = 5.0
    translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      centerXAnchor.constraint(equalTo: centerXAnchor),
      centerYAnchor.constraint(equalTo: centerYAnchor),
      widthAnchor.constraint(equalToConstant: 10.0),
      heightAnchor.constraint(equalToConstant: 10.0)
    ])
  }
  
}
