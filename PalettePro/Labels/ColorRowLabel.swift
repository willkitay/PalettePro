//
//  ColorRowLabel.swift
//  PalettePro
//
//  Created by Will Kitay on 5/21/23.
//

import UIKit

class ColorRowLabel: UILabel {
    
  override init(frame: CGRect) {
    super.init(frame: frame)
    configure()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func configure() {
    font = .preferredFont(forTextStyle: .headline)
    translatesAutoresizingMaskIntoConstraints = false
  }
  
}
