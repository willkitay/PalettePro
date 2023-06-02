//
//  GenerateButton.swift
//  PalettePro
//
//  Created by Will Kitay on 5/21/23.
//

import UIKit

class GenerateButton: UIButton {
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    configure()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func configure() {
    backgroundColor = .systemBackground
    setTitle("Generate", for: .normal)
    setTitleColor(.label, for: .normal)
    setTitleColor(.lightGray, for: .highlighted)
    translatesAutoresizingMaskIntoConstraints = false
    clipsToBounds = true
  }
}
