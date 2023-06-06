//
//  PaletteTabBar.swift
//  PalettePro
//
//  Created by Will Kitay on 5/25/23.
//

import UIKit

protocol PaletteTabBarDelegate: AnyObject {
  func selectColor(_ color: UIColor?)
}

class PaletteTabBar: UIView {
  
  weak var delegate: PaletteTabBarDelegate?
  private var colorButtons: [UIButton] = []
  var stackView = UIStackView()
  let dotIndicator = DotIndicator()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    configureView()
    configureStackView()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func configureView() {
    layer.cornerRadius = 10
    layer.borderWidth = 0.75
    layer.borderColor = UIColor.systemGray5.cgColor
    layer.masksToBounds = true
    translatesAutoresizingMaskIntoConstraints = false
  }
  
  func configureStackView() {
    addSubview(stackView)
    stackView.axis = .horizontal
    stackView.distribution = .fillEqually
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.pinToEdges(of: self)
  }
  
  func setTabBarColors(_ colors: [String]) {
    colorButtons.removeAll()
    colorButtons.forEach { $0.removeFromSuperview() }

    for color in colors {
      let button = createButton(with: UIColor(hex: color))
      stackView.addArrangedSubview(button)
      colorButtons.append(button)
    }

    dotIndicator.setDotIndicator(on: colorButtons.first)
  }
  
  private func createButton(with color: UIColor?) -> UIButton {
    let button = UIButton(type: .system)
    button.backgroundColor = color
    button.addTarget(self, action: #selector(colorButtonTapped), for: .touchUpInside)
    return button
  }
  
  @objc private func colorButtonTapped(_ sender: UIButton) {
    guard let color = sender.backgroundColor else { return }
    delegate?.selectColor(color)
    dotIndicator.setDotIndicator(on: sender)
  }
}
