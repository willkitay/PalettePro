//
//  SeeMoreButton.swift
//  PalettePro
//
//  Created by Will Kitay on 5/29/23.
//

import UIKit

class SeeMoreButton: UIButton {
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    configure()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func configure() {
    
    configuration = .tinted()
    configuration?.title = "See more"

    configuration?.baseBackgroundColor = .systemGray
    configuration?.baseForegroundColor = .label
    
    configuration?.image = UIImage(systemName: "chevron.right")
    configuration?.imagePlacement = .trailing
    configuration?.imagePadding = 5
    configuration?.preferredSymbolConfigurationForImage = .init(font: .preferredFont(forTextStyle: .caption1))
    
    translatesAutoresizingMaskIntoConstraints = false
    let buttonHeight: CGFloat = 40
    NSLayoutConstraint.activate([
      heightAnchor.constraint(equalToConstant: buttonHeight)
    ])
  }
}
