//
//  ColorCombo.swift
//  PalettePro
//
//  Created by Will Kitay on 5/27/23.
//

import UIKit

protocol ColorComboDelegate: AnyObject {
  func copyColorComboCode()
}

class ColorCombo: UIStackView {
  
  weak var delegate: ColorComboDelegate?
  var background: UIColor!
  
  private var colors: [UIColor] = []
  private let containerView = UIView()
  private let horizontalStack = UIStackView()
  private let titleLabel = UILabel()
  
  var title: String? {
    get { return titleLabel.text }
    set { titleLabel.text = newValue?.uppercased() }
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    configureContainerView()
    configureTitleLabel()
    configureStackView()
  }
  
  required init(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  convenience init(title: String) {
    self.init(frame: .zero)
    self.title = title
  }
  
  func set(colors: [UIColor]) {
    self.colors = colors
    titleLabel.textColor = getContrastTextColor(for: background).withAlphaComponent(0.5)
    
    horizontalStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
    for color in colors {
      horizontalStack.addArrangedSubview(createColorButton(with: color))
    }
  }
  
  private func createColorButton(with color: UIColor) -> UIButton {
    let button = UIButton()
    button.setTitle(color.toHex(), for: .normal)
    button.setTitleColor(getContrastTextColor(for: color), for: .normal)
    button.backgroundColor = color
    button.clipsToBounds = true
    button.heightAnchor.constraint(equalToConstant: 80).isActive = true
    button.addTarget(self, action: #selector(copyColorCode), for: .touchUpInside)
    return button
  }
  
  @objc private func copyColorCode(_ sender: UIButton) {
    guard let colorCode = sender.titleLabel?.text else { return }
    UIPasteboard.general.string = colorCode
    delegate?.copyColorComboCode()
  }
  
  private func configureContainerView() {
    addArrangedSubview(containerView)
    
    NSLayoutConstraint.activate([
      containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
      containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
    ])
  }
  
  private func configureTitleLabel() {
    containerView.addSubview(titleLabel)
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    titleLabel.font = .boldSystemFont(ofSize: 12)
    titleLabel.textAlignment = .left
    
    NSLayoutConstraint.activate([
      titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
      titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
      titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 15),
    ])
  }
  
  private func configureStackView() {
    containerView.addSubview(horizontalStack)

    horizontalStack.translatesAutoresizingMaskIntoConstraints = false
    horizontalStack.axis = .horizontal
    horizontalStack.distribution = .fillEqually
    horizontalStack.alignment = .center
    horizontalStack.layer.cornerRadius = 10
    horizontalStack.layer.masksToBounds = true
    
    NSLayoutConstraint.activate([
      horizontalStack.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 5),
      horizontalStack.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -5),
      horizontalStack.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
      horizontalStack.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
    ])
  }
}
