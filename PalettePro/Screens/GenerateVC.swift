//
//  ViewController.swift
//  PalettePro
//
//  Created by Will Kitay on 5/8/23.
//

import UIKit

class GenerateVC: UIViewController, OptionsHandlerDelegate, ColorRowVCDelegate {

  var stack = ColorStack()
  var colorRows: [ColorRowVC] = []
  
  let stackView = UIStackView()
  let optionsButton = UIButton()
  let leftStackButton = StackButton(facing: .left)
  let rightStackButton = StackButton(facing: .right)
  let generateButton = GenerateButton()
  let optionsHandler = OptionsManager()

  var currentNumberOfRows: Int = Constants.defaultRowCount
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    navigationController?.setNavigationBarHidden(true, animated: true)
    
    optionsHandler.delegate = self
    configureRows()
    configureStackView()
    configureGenerateButton()
    configureUILayout()
    configureStackButtons()
    configureOptionsButton()
    updateArrowButtonsAppearance()
  }
  
  private func configureRows() {
    colorRows = [ColorRowVC(isTopRow: true), ColorRowVC(), ColorRowVC(), ColorRowVC()]
    for colorRow in colorRows {
      addChild(colorRow)
      colorRow.delegate = self
    }
  }
  
  private func configureGenerateButton() {
    generateButton.addTarget(self, action: #selector(generateButtonTapped), for: .touchUpInside)
  }
  
  func triggerColorShadeChange(previousColor: UIColor?, newColor: UIColor?) {
    didSelectColor(previousColor: previousColor, newColor: newColor)
  }
  
  func didSelectColor(previousColor: UIColor?, newColor: UIColor?) {
    guard let previousColor else { return }
    guard let newColor else { return }
    
    updateStack(to: newColor, from: previousColor)
    updateColorRow(to: newColor, from: previousColor)
  }
  
  private func updateStack(to newColor: UIColor, from previousColor: UIColor ) {
    for (index, row) in stack.currentColors.enumerated() {
      let colorsAreIdentical: Bool = row.0 == previousColor.toHex()
      if colorsAreIdentical { stack.set(hex: newColor.toHex(), at: index) }
    }
  }
  
  private func updateColorRow(to newColor: UIColor, from previousColor: UIColor ) {
    for row in colorRows {
      
      if row.hexLabel.text == previousColor.toHex() {
        row.updateStack(with: newColor.toHex(), isLocked: row.lockButton.isLocked)
        break
      }
    }
  }
  
  @objc private func generateButtonTapped() {
    guard colorRows.contains(where: { $0.lockButton.isLocked == false }) else { return }
        
    for row in colorRows {
      guard !row.lockButton.isLocked else { continue }
      row.generateRandomColor()
    }
    
    stack.push(colorRows.map { ($0.hexLabel.text ?? "", $0.lockButton.isLocked) })
    stack.moveToTop()
    updateArrowButtonsAppearance()
  }
  
  @objc func triggerLeftArrowButton() {
    guard stack.canDecrement else { return }
    updateLockStates()
    stack.decrement()
    updateStackViewColors()
    updateArrowButtonsAppearance()
  }
  
  @objc func triggerRightArrowButton() {
    guard stack.canIncrement else { return }
    updateLockStates()
    stack.increment()
    updateStackViewColors()
    updateArrowButtonsAppearance()
  }
  
  private func updateLockStates() {
    for (index, row) in colorRows.enumerated() {
      stack.set(lockState: row.lockButton.isLocked, at: index)
    }
  }
  
  private func updateStackViewColors() {
    for row in colorRows { row.removeFromParent() }
    colorRows.removeAll()

    for (index, color) in stack.currentColors.enumerated() {
      let colorRow = ColorRowVC(isTopRow: index == 0)
      addChild(colorRow)
      colorRow.delegate = self
      colorRow.updateStack(with: color.0, isLocked: color.1)
      colorRows.append(colorRow)
    }
    
    stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
    colorRows.forEach { stackView.addArrangedSubview($0.view) }
  }
  
  private func updateArrowButtonsAppearance() {
    leftStackButton.setDisabledState(stack.currentIndex == stack.minIndex)
    rightStackButton.setDisabledState(stack.currentIndex == max(0, stack.maxIndex))
  }
  
  @objc func optionsButtonTapped() {
    optionsHandler.showOptions(from: self, sourceView: optionsButton)
  }
  
  func viewPalette(hexColors: [String]) {
    let paletteDetailsVC = PaletteDetailsVC(colors: colorRows.map { $0.hexLabel.text ?? "" })
    paletteDetailsVC.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(closeViewPalette))
    
    let navigationController = UINavigationController(rootViewController: paletteDetailsVC)
    navigationController.modalPresentationStyle = .fullScreen
    
    present(navigationController, animated: true)
  }
  
  @objc func closeViewPalette() { dismiss(animated: true) }
  
  func savePalette() {
    let palette = Palette(colors: colorRows.map { $0.hexLabel.text ?? "" })
        
    PalettePersistenceManager.updateWith(favorite: palette, actionType: .add) { _ in }
  }
  
  func exportPalette() {
    let colorsToExport = colorRows.map { $0.hexLabel.text ?? "" }
    PaletteExporter.exportPalette(colorsToExport: colorsToExport, from: self)
  }
  
  func removeRow(_ uiViewController: ColorRowVC) {
    guard colorRows.count > 2 else { return }
    guard let index = colorRows.firstIndex(where: { $0.view.backgroundColor?.toHex() == uiViewController.view.backgroundColor?.toHex() }) else { return }
    
    UIView.animate(withDuration: 0.3) { self.colorRows[index].view.isHidden = true }
    colorRows.remove(at: index)
    stack.removeColor(at: index)
    currentNumberOfRows -= 1
    uiViewController.removeFromParent()
    
    guard let colorRowVC = colorRows.first else { return }
    colorRowVC.hexLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
  }
  
  func addColor() {
    guard colorRows.count < Constants.maxRowCount else { return }
    guard currentNumberOfRows < Constants.maxRowCount else { return }
    
    let newRow = createNewColorRowVC()
    UIView.animate(withDuration: 0.3) { newRow.view.isHidden = false }
  }
  
  private func createNewColorRowVC() -> ColorRowVC {
    let newRow = ColorRowVC()
    newRow.view.isHidden = true
    newRow.delegate = self
    self.stack.addColor([(newRow.view.backgroundColor?.toHex() ?? "", false)])
    self.colorRows.append(newRow)
    self.stackView.addArrangedSubview(newRow.view)
    currentNumberOfRows += 1
    addChild(newRow)
    return newRow
  }
  
  private func configureStackView() {
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.axis = .vertical
    stackView.distribution = .fillEqually
    stackView.clipsToBounds = true
    
    for row in colorRows { stackView.addArrangedSubview(row.view) }
    stack.push(colorRows.map { ($0.hexLabel.text ?? "", $0.lockButton.isLocked) })
  }
  
  private func configureUILayout() {
    view.addSubviews(stackView, generateButton)
    
    let tabviewHeight: CGFloat = 50
    NSLayoutConstraint.activate([
      stackView.topAnchor.constraint(equalTo: view.topAnchor),
      stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      stackView.bottomAnchor.constraint(equalTo: generateButton.topAnchor),
      
      generateButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
      generateButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      generateButton.heightAnchor.constraint(equalToConstant: tabviewHeight),
    ])
    
  }
  
  private func configureStackButtons() {
    view.addSubviews(leftStackButton, rightStackButton)
    leftStackButton.addTarget(self, action: #selector(triggerLeftArrowButton), for: .touchUpInside)
    rightStackButton.addTarget(self, action: #selector(triggerRightArrowButton), for: .touchUpInside)
        
    let arrowPadding: CGFloat = 15
    let arrowWidth: CGFloat = 35
    NSLayoutConstraint.activate([
      leftStackButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: arrowPadding),
      leftStackButton.centerYAnchor.constraint(equalTo: generateButton.centerYAnchor),
      leftStackButton.widthAnchor.constraint(equalToConstant: arrowWidth),
      
      rightStackButton.leadingAnchor.constraint(equalTo: leftStackButton.trailingAnchor),
      rightStackButton.centerYAnchor.constraint(equalTo: generateButton.centerYAnchor),
      rightStackButton.widthAnchor.constraint(equalToConstant: arrowWidth),
    ])
  }
  
  private func configureOptionsButton() {
    view.addSubview(optionsButton)
    
    optionsButton.addTarget(self, action: #selector(optionsButtonTapped), for: .touchUpInside)
    optionsButton.setImage(Symbols.ellipsis?.withTintColor(.label, renderingMode: .alwaysOriginal), for: .normal)
    optionsButton.setImage(Symbols.ellipsis?.withTintColor(.systemGray, renderingMode: .alwaysOriginal), for: .highlighted)
    optionsButton.translatesAutoresizingMaskIntoConstraints = false
    
    let optionsButtonWidth: CGFloat = 85
    NSLayoutConstraint.activate([
      optionsButton.widthAnchor.constraint(equalToConstant: optionsButtonWidth),
      optionsButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      optionsButton.centerYAnchor.constraint(equalTo: generateButton.centerYAnchor),
    ])
  }
}
