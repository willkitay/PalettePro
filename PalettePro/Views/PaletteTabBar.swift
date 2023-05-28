//
//  PaletteTabBar.swift
//  PalettePro
//
//  Created by Will Kitay on 5/25/23.
//

import UIKit

class PaletteTabBar: UIView {
  
  weak var delegate: PaletteTabBarDelegate?
  private var colorButtons: [UIButton] = []
  var stackView = UIStackView()
  let dotIndicator = DotIndicator()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    layer.cornerRadius = 10
    layer.borderWidth = 0.75
    layer.borderColor = UIColor.systemGray5.cgColor
    layer.masksToBounds = true
    translatesAutoresizingMaskIntoConstraints = false
    configureStackView()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func configureStackView() {
    stackView.axis = .horizontal
    stackView.distribution = .fillEqually
    stackView.translatesAutoresizingMaskIntoConstraints = false
    addSubview(stackView)
    
    NSLayoutConstraint.activate([
      stackView.topAnchor.constraint(equalTo: topAnchor),
      stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
      stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
      stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
    ])
  }
  
  func setTabBarColors(_ colors: [String]) {
    colorButtons.forEach { $0.removeFromSuperview() }
    colorButtons.removeAll()

    for color in colors {
      let button = UIButton(type: .system)
      button.backgroundColor = UIColor(hex: color)
      button.addTarget(self, action: #selector(colorButtonTapped), for: .touchUpInside)
      stackView.addArrangedSubview(button)
      colorButtons.append(button)
    }

    dotIndicator.setDotIndicator(on: colorButtons.first)
  }
  
  @objc private func colorButtonTapped(_ sender: UIButton) {
    guard let color = sender.backgroundColor else { return }
    delegate?.selectColor(color)
    dotIndicator.setDotIndicator(on: sender)
  }
}



