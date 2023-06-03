//
//  SavedColorPalette.swift
//  PalettePro
//
//  Created by Will Kitay on 5/29/23.
//

import UIKit

protocol SavedColorPaletteDelegate: AnyObject {
  func presentPaletteDetailsVC(colors: [String])
}

class SavedColorPalette: UIStackView {
  
  weak var delegate: SavedColorPaletteDelegate?
  
  private var colorButtons: [UIButton] = []
  private(set) var colors: [UIColor] = []
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    configureStackView()
  }
  
  required init(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func configureStackView() {
    axis = .horizontal
    distribution = .fillEqually
    alignment = .center
    translatesAutoresizingMaskIntoConstraints = false
    layer.cornerRadius = 10
    layer.masksToBounds = true
  }
  
  func updateColors(_ colors: [UIColor]) {
    self.colors = colors
    removeAllArrangedSubviews()
    colorButtons = colors.map { createColorButton(with: $0) }
    colorButtons.forEach { addArrangedSubview($0) }
  }
  
  private func createColorButton(with color: UIColor) -> UIButton {
    let button = UIButton()
    button.backgroundColor = color
    button.heightAnchor.constraint(equalToConstant: 40).isActive = true
    button.addTarget(self, action: #selector(paletteRowTapped), for: .touchUpInside)
    return button
  }
  
  @objc func paletteRowTapped(_ sender: UITapGestureRecognizer) {
    delegate?.presentPaletteDetailsVC(colors: colors.map { $0.toHex() })
  }
  
  private func removeAllArrangedSubviews() {
    arrangedSubviews.forEach { $0.removeFromSuperview() }
  }
}
