//
//  ColorRowVC.swift
//  PalettePro
//
//  Created by Will Kitay on 5/21/23.
//

import UIKit

class ColorRowVC: UIViewController {
  
  let hexLabel = ColorRowLabel()
  let lockButton = ColorRowLockButton()
  var isTopColorRow: Bool = false
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.addSubviews(hexLabel, lockButton)
    
    generateRandomColor()
    configureLabel()
    configureLockButton()
  }
  
  convenience init(isFirstRowInArray: Bool?) {
    self.init(nibName: nil, bundle: nil)
    self.isTopColorRow = isFirstRowInArray ?? false
  }  
  
  func configureLabel() {
    hexLabel.textColor = getContrastTextColor(for: view.backgroundColor)
    
    NSLayoutConstraint.activate([
      hexLabel.topAnchor.constraint(equalTo: isTopColorRow ? view.safeAreaLayoutGuide.topAnchor : view.topAnchor),
      hexLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
      hexLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      hexLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    ])
  }
  
  func configureLockButton() {
    NSLayoutConstraint.activate([
      lockButton.centerYAnchor.constraint(equalTo: hexLabel.centerYAnchor),
      lockButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30)
    ])
  }
  
  func updateStack(with hex: String, isLocked: Bool) {
    view.backgroundColor = UIColor(hex: hex)
    updateLabel()
    lockButton.isLocked = isLocked
  }
  
  func generateRandomColor() {
    view.backgroundColor = .generateRandomColor()
    updateLabel()
  }
  
  private func updateLabel() {
    hexLabel.text = view.backgroundColor?.toHex() ?? "N/A"
    hexLabel.textColor = getContrastTextColor(for: view.backgroundColor)
  }
  
}
