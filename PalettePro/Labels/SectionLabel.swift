//
//  SectionLabel.swift
//  PalettePro
//
//  Created by Will Kitay on 5/29/23.
//

import UIKit

class SectionLabel: UILabel {
    
  override init(frame: CGRect) {
    super.init(frame: frame)
    configure()
  }
  
  convenience init(title: String) {
    self.init(frame: .zero)
    text = title
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func configure() {
    textColor = .systemGray
    font = .preferredFont(forTextStyle: .footnote)
  }

}
