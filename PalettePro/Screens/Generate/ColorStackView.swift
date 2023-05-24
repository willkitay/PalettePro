//
//  ColorStackView.swift
//  PalettePro
//
//  Created by Will Kitay on 5/24/23.
//

import UIKit

class ColorStackView: UIStackView {
  
  var colors: [UIColor]? {
    didSet {
      updateColors()
    }
  }
  
  let colorPercentChange = 2
  
  init(colors: [UIColor]?) {
    self.colors = colors
    super.init(frame: .zero)
    setupStackView()
  }
  
  required init(coder: NSCoder) {
    self.colors = []
    super.init(coder: coder)
    setupStackView()
  }
  
  private func setupStackView() {
    axis = .vertical
    distribution = .fillEqually
    translatesAutoresizingMaskIntoConstraints = false
    
    updateColors()
  }
  
  private func updateColors() {
    guard let colors = colors else { return }
    
    arrangedSubviews.forEach { $0.removeFromSuperview() }
    
    for color in colors {
      let colorSubview = createColorRowSubView(with: color)
      addArrangedSubview(colorSubview)
    }
  }
  
  private func createColorRowSubView(with color: UIColor?) -> UIView {
    let subview = UIView()
    subview.backgroundColor = color ?? .clear
    return subview
  }
  
}
