//
//  ColorRowVC.swift
//  PalettePro
//
//  Created by Will Kitay on 5/21/23.
//

import UIKit

protocol ColorRowVCDelegate: AnyObject {
  func triggerColorShadeChange(previousColor: UIColor?, newColor: UIColor?)
  func removeRow(_ uiViewController: ColorRowVC)
}

class ColorRowVC: UIViewController, ColorDetailVCDelegate {

  let hexLabel = ColorRowLabel()
  let lockButton = LockButton()
  let menuButton = UIButton()
  private var isTopRow: Bool = false
  
  weak var delegate: ColorRowVCDelegate?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.addSubviews(hexLabel, lockButton, menuButton)
    
    generateRandomColor()
    configureLabel()
    configureButtons()
  }
  
  convenience init(isTopRow: Bool) {
    self.init()
    self.isTopRow = isTopRow
  }
  
  func didSelectColor(previousColor: UIColor?, newColor: UIColor?) {
    delegate?.triggerColorShadeChange(previousColor: previousColor, newColor: newColor)
  }
  
  private func configureMenu() {
    let viewColor = UIAction(title: "View Color", image: Symbols.eye) { _ in
      self.viewPalette(hexColors: [self.view.backgroundColor?.toHex() ?? ""])
    }
    let saveColor = UIAction(title: "Save", image: Symbols.heart) { _ in
      let color = Color(hex: self.view.backgroundColor?.toHex() ?? "")
      ColorPersistenceManager.updateWith(favorite: color, actionType: .add, completed: { _ in })
    }
    let editShades = UIAction(title: "Edit", image: Symbols.grid3x3) { _ in
      let colorPickerVC = ColorPickerVC(hex: self.view.backgroundColor?.toHex())
      colorPickerVC.delegate = self
      self.present(colorPickerVC, animated: true)
    }
    
    let removeColor = UIAction(title: "Remove", image: Symbols.trash) { _ in
      self.delegate?.removeRow(self)
    }
    
    let menu = UIMenu(children: [viewColor, saveColor, editShades, removeColor])
    menuButton.menu = menu
    menuButton.showsMenuAsPrimaryAction = true
  }
  
  private func viewPalette(hexColors: [String]) {
    let paletteDetailsVC = PaletteDetailsVC(colors: hexColors)
    paletteDetailsVC.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(closeViewPalette))
    
    let navigationController = UINavigationController(rootViewController: paletteDetailsVC)
    navigationController.modalPresentationStyle = .fullScreen
    
    present(navigationController, animated: true)
  }
  
  @objc private func closeViewPalette() { dismiss(animated: true) }
  
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
  
  func configureLabel() {
    hexLabel.textColor = getContrastTextColor(for: view.backgroundColor)
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGesture))
    hexLabel.addGestureRecognizer(tapGesture)
    hexLabel.isUserInteractionEnabled = true
    
    NSLayoutConstraint.activate([
      hexLabel.topAnchor.constraint(equalTo: isTopRow ? view.safeAreaLayoutGuide.topAnchor : view.topAnchor, constant: isTopRow ? 0 : 30),
      hexLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
      hexLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: isTopRow ? -10 : -30),
      hexLabel.widthAnchor.constraint(equalToConstant: 100)
    ])
  }
  
  @objc func tapGesture() {
    presentCopyAlert()
  }
  
  func configureButtons() {
    menuButton.setImage(UIImage(systemName: "ellipsis"), for: .normal)
    menuButton.setPreferredSymbolConfiguration(.init(textStyle: .title2), forImageIn: .normal)
    menuButton.tintColor = .systemGray4
    menuButton.translatesAutoresizingMaskIntoConstraints = false
    menuButton.configuration?.imagePadding = 10
    configureMenu()
    
    NSLayoutConstraint.activate([
      lockButton.centerYAnchor.constraint(equalTo: hexLabel.centerYAnchor),
      lockButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
      lockButton.widthAnchor.constraint(equalToConstant: 30),
      
      menuButton.centerYAnchor.constraint(equalTo: hexLabel.centerYAnchor),
      menuButton.trailingAnchor.constraint(equalTo: lockButton.leadingAnchor, constant: -20),
    ])
  }
  
}
