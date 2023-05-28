//
//  ViewController.swift
//  PalettePro
//
//  Created by Will Kitay on 5/8/23.
//

import UIKit

class GenerateVC: UIViewController, ColorDetailVCDelegate, OptionsHandlerDelegate {
  
  var stack = ColorStack()
  var colorRows: [ColorRowVC] = []
  
  let stackView = UIStackView()
  let optionsButton = UIButton()
  let leftStackButton = StackButton(facing: .left)
  let rightStackButton = StackButton(facing: .right)
  let generateButton = GenerateButton()
  let optionsHandler = OptionsHandler()

  var currentNumberOfRows: Int = Constants.defaultNumberOfRows
  
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
    updateFirstRowLabelConstraint()
  }
  
  private func configureRows() {
    colorRows = [ColorRowVC(isFirstRowInArray: true), ColorRowVC(), ColorRowVC(), ColorRowVC(), ColorRowVC()]
  }
  
  private func configureGenerateButton() {
    generateButton.addTarget(self, action: #selector(generateButtonTapped), for: .touchUpInside)
  }
  
  func didSelectColor(previousColor: UIColor?, newColor: UIColor?) {
    guard let previousColor else { return }
    guard let newColor else { return }
    
    updateStack(to: newColor, from: previousColor)
    updateColorRow(to: newColor, from: previousColor)
    
    updateColorRowTapGesture()
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
    updateColorRowTapGesture()
  }
  
  private func updateColorRowTapGesture() {
    for row in colorRows {
      let tapGesture = ColorRowTapGestureRecognizer(target: self, action: #selector(colorRowTapped))
      tapGesture.hex = row.hexLabel.text
      row.view.addGestureRecognizer(tapGesture)
    }
  }
  
  @objc func colorRowTapped(_ sender: ColorRowTapGestureRecognizer) {
    let colorDetailVC = ColorDetailVC(hex: sender.hex)
    colorDetailVC.delegate = self
    present(colorDetailVC, animated: true)
  }
  
  @objc func triggerLeftArrowButton() {
    guard stack.canDecrement else { return }
    updateLockStates()
    
    stack.decrement()
    updateStackViewColors()
    updateArrowButtonsAppearance()
    updateColorRowTapGesture()
  }
  
  @objc func triggerRightArrowButton() {
    guard stack.canIncrement else { return }
    updateLockStates()
    
    stack.increment()
    updateStackViewColors()
    updateArrowButtonsAppearance()
    updateColorRowTapGesture()
  }
  
  private func updateLockStates() {
    for (index, row) in colorRows.enumerated() {
      stack.set(lockState: row.lockButton.isLocked, at: index)
    }
  }
  
  private func updateStackViewColors() {
    colorRows.removeAll()
    
    for (colorIndex, color) in stack.currentColors.enumerated() {
      let colorRow = ColorRowVC(isFirstRowInArray: colorIndex == 0)
      colorRow.updateStack(with: color.0, isLocked: color.1)
      colorRows.append(colorRow)
    }
    
    stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
    colorRows.forEach { stackView.addArrangedSubview($0.view) }
    
    updateColorRowTapGesture()
  }
  
  private func updateArrowButtonsAppearance() {
    leftStackButton.setDisabledState(stack.currentIndex == stack.minIndex)
    rightStackButton.setDisabledState(stack.currentIndex == max(0, stack.maxIndex))
  }
  
  @objc func optionsButtonTapped() {
    optionsHandler.showOptions(from: self, sourceView: optionsButton)
  }
  
  func viewPalette() {
    let paletteDetailsVC = PaletteDetailsVC(colors: colorRows.map { $0.hexLabel.text ?? "" })
    paletteDetailsVC.navigationItem.title = "Palette Details"
    paletteDetailsVC.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(closeViewPalette))
    
    let navigationController = UINavigationController(rootViewController: paletteDetailsVC)
    navigationController.modalPresentationStyle = .fullScreen
    
    present(navigationController, animated: true)
  }
  
  @objc func closeViewPalette() { dismiss(animated: true) }
  
  func savePalette() { print("savePalette") }
  
  func exportPalette() {
    let colorsToExport = colorRows.map { $0.hexLabel.text ?? "" }
    PaletteExporter.exportPalette(colorsToExport: colorsToExport, from: self)
  }
  
  func addColor() {
    guard colorRows.count < Constants.maxNumberOfRows else { return }
    guard currentNumberOfRows < Constants.maxNumberOfRows else { return }
    
    let newRow = createNewColorRowVC()
    
    if stack.currentIndex == 0 { newRow.isTopColorRow = true }

    UIView.animate(withDuration: 0.3) {
      newRow.view.isHidden = false
      self.updateFirstRowLabelConstraint()
    }
  }
  
  private func updateFirstRowLabelConstraint() {
    if let row = self.colorRows.first {
      NSLayoutConstraint.activate([
        row.hexLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor)
      ])
    }
  }
  
  func canRemoveColor() -> Bool {
    for row in colorRows { if !row.lockButton.isLocked { return true } }
    return false
  }
  
  private func createNewColorRowVC() -> ColorRowVC {
    let newRow = ColorRowVC()
    newRow.view.isHidden = true
    self.stack.addColor([(newRow.view.backgroundColor?.toHex() ?? "", false)])
    self.colorRows.append(newRow)
    self.stackView.addArrangedSubview(newRow.view)
    updateColorRowTapGesture()
    currentNumberOfRows += 1
    return newRow
  }
  
  func removeColor() {
    guard colorRows.count > 2 else { return }
    
    for (index, row) in colorRows.enumerated().reversed() {
      if !row.lockButton.isLocked {
        UIView.animate(withDuration: 0.3) { self.colorRows[index].view.isHidden = true }
        colorRows.remove(at: index)
        stack.removeColor(at: index)
        currentNumberOfRows -= 1
        return
      }
    }
  }
  
  private func configureStackView() {
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.axis = .vertical
    stackView.distribution = .fillEqually
    stackView.clipsToBounds = true
    
    for row in colorRows { stackView.addArrangedSubview(row.view) }
    
    updateColorRowTapGesture()
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

class ColorRowTapGestureRecognizer: UITapGestureRecognizer {
  var hex: String?
}
