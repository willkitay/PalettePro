//
//  ViewController.swift
//  PalettePro
//
//  Created by Will Kitay on 5/8/23.
//

import UIKit

class GenerateVC: UIViewController, ColorDetailVCDelegate, OptionsHandlerDelegate {
  
  var stack = Stack()
  var colorRows: [ColorRowVC] = []
  let stackView = UIStackView()
  let leftStackButton = StackButton(facing: .left)
  let rightStackButton = StackButton(facing: .right)
  let generateButton = GenerateButton()
  let optionsButton = UIButton()
  let optionsHandler = OptionsHandler()
  
  let maxNumberOfRows = Constants.maxNumberOfRows
  var currentNumberOfRows: Int = Constants.defaultNumberOfRows
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    colorRows = [ColorRowVC(isFirstRowInArray: true), ColorRowVC(), ColorRowVC(), ColorRowVC(), ColorRowVC()]
    optionsHandler.delegate = self
    configureStackView()
    configureActionBar()
    configureUILayout()
    configureStackButtons()
    configureOptionsButton()
    updateArrowButtonsAppearance()
  }
  
  private func configureActionBar() {
    generateButton.addTarget(self, action: #selector(generateButtonTapped), for: .touchUpInside)
  }
  
  func didSelectColor(previousColor: UIColor?, newColor: UIColor?) {
    for (index, color) in stack.array[stack.currentIndex].enumerated() {
      if color.0 == previousColor?.toHex() {
        stack.array[stack.currentIndex][index].0 = newColor?.toHex() ?? ""
      }
    }
    
    guard let newColor else { return }
    for row in colorRows {
      if row.hexLabel.text == previousColor?.toHex() {
        row.updateStackData(with: newColor.toHex(), isLocked: row.lockButton.isLocked)
        break
      }
    }
    
    updateColorRowTapGestureDetails()
  }
  
  @objc func generateButtonTapped() {
    guard colorRows.contains(where: { $0.lockButton.isLocked == false }) else { return }
    
    for row in colorRows {
      if !row.lockButton.isLocked {
        row.generateRandomColor()
      }
    }
    stack.push(colorRows.map { ($0.hexLabel.text ?? "", $0.lockButton.isLocked) })
    stack.increment()
    updateArrowButtonsAppearance()
    updateColorRowTapGestureDetails()
  }
  
  private func configureStackView() {
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.axis = .vertical
    stackView.distribution = .fillEqually
    
    for row in colorRows { stackView.addArrangedSubview(row.view) }
    
    updateColorRowTapGestureDetails()
    stack.push(colorRows.map { ($0.hexLabel.text ?? "", $0.lockButton.isLocked) })
  }
  
  private func updateColorRowTapGestureDetails() {
    for row in colorRows {
      let tapGesture = ColorRowTapGestureRecognizer(target: self, action: #selector(colorRowTapped(sender:)))
      tapGesture.hex = row.hexLabel.text
      row.view.addGestureRecognizer(tapGesture)
    }
  }
  
  @objc func colorRowTapped(sender: ColorRowTapGestureRecognizer) {
    let colorDetailVC = ColorDetailVC(hex: sender.hex)
    colorDetailVC.delegate = self
    
    present(colorDetailVC, animated: true)
  }
  
  @objc func triggerLeftArrowButton() {
    guard stack.currentIndex > 0 else { return }
    updateCurrentStackIndexLockStates()
    stack.decrement()
    updateStackViewColors()
    updateArrowButtonsAppearance()
    updateColorRowTapGestureDetails()
  }
  
  @objc func triggerRightArrowButton() {
    if stack.currentIndex < stack.array.count {
      updateCurrentStackIndexLockStates()
      stack.increment()
      updateStackViewColors()
      updateArrowButtonsAppearance()
      updateColorRowTapGestureDetails()
    }
  }
  
  private func updateCurrentStackIndexLockStates() {
    for (index, row) in colorRows.enumerated() {
      stack.array[stack.currentIndex][index].1 = row.lockButton.isLocked
    }
  }
  
  private func updateStackViewColors() {
    colorRows.removeAll()
    
    for (colorIndex, color) in stack.currentColors().enumerated() {
      let colorRow = ColorRowVC(isFirstRowInArray: colorIndex == 0)
      colorRow.updateStackData(with: color.0, isLocked: color.1)
      colorRows.append(colorRow)
    }
    
    stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
    colorRows.forEach { stackView.addArrangedSubview($0.view) }
    
    updateColorRowTapGestureDetails()
  }
  
  private func updateArrowButtonsAppearance() {
    leftStackButton.setDisabledState(stack.currentIndex == 0)
    rightStackButton.setDisabledState(stack.currentIndex == max(0, stack.array.count - 1))
  }
  
  private func configureStackButtons() {
    view.addSubviews(leftStackButton, rightStackButton)
    leftStackButton.addTarget(self, action: #selector(triggerLeftArrowButton), for: .touchUpInside)
    rightStackButton.addTarget(self, action: #selector(triggerRightArrowButton), for: .touchUpInside)
        
    let arrowWidth: CGFloat = 35
    let arrowPadding: CGFloat = 15
    NSLayoutConstraint.activate([
      leftStackButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: arrowPadding),
      leftStackButton.centerYAnchor.constraint(equalTo: generateButton.centerYAnchor),
      leftStackButton.widthAnchor.constraint(equalToConstant: arrowWidth),
      
      rightStackButton.leadingAnchor.constraint(equalTo: leftStackButton.trailingAnchor),
      rightStackButton.centerYAnchor.constraint(equalTo: generateButton.centerYAnchor),
      rightStackButton.widthAnchor.constraint(equalToConstant: arrowWidth),
    ])
  }
  
  private func configureUILayout() {
    view.addSubviews(stackView, generateButton)
    
    let tabviewHeight: CGFloat = 40
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
  
  private func configureOptionsButton() {
    view.addSubview(optionsButton)
    
    let optionButtonSFImage = "ellipsis"
    optionsButton.translatesAutoresizingMaskIntoConstraints = false
    optionsButton.addTarget(self, action: #selector(optionsButtonTapped), for: .touchUpInside)
    optionsButton.setImage(UIImage(systemName: optionButtonSFImage)?.withTintColor(.label, renderingMode: .alwaysOriginal), for: .normal)
    optionsButton.setImage(UIImage(systemName: optionButtonSFImage)?.withTintColor(.systemGray, renderingMode: .alwaysOriginal), for: .highlighted)
    
    let optionsButtonWidth: CGFloat = 85
    NSLayoutConstraint.activate([
      optionsButton.widthAnchor.constraint(equalToConstant: optionsButtonWidth),
      optionsButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      optionsButton.centerYAnchor.constraint(equalTo: generateButton.centerYAnchor),
    ])
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
    guard currentNumberOfRows < Constants.maxNumberOfRows else {
    // TODO present an alert that the user cannot add any more rows
      return
    }

    UIView.animate(withDuration: 0.3) {
      let newRow = ColorRowVC()
      newRow.view.isHidden = true
      self.stack.updateColorCount([(newRow.view.backgroundColor?.toHex() ?? "", false)])
      self.colorRows.append(newRow)
      self.stackView.addArrangedSubview(newRow.view)
      newRow.view.isHidden = false
    }
    
    updateColorRowTapGestureDetails()
    currentNumberOfRows += 1
    
    stackView.clipsToBounds = true
  }
  
  func removeColor() {
    guard colorRows.count > 2 else { return }
    // TODO present alert that user has locked all remaining colors
    // TODO present alert that user has reached minimum number of colors
    
    for (index, row) in colorRows.enumerated().reversed() {
      if !row.lockButton.isLocked {
        UIView.animate(withDuration: 0.3) {
          self.colorRows[index].view.isHidden = true
        }
        colorRows.remove(at: index)
        stack.array[stack.currentIndex].remove(at: index)
        currentNumberOfRows -= 1
        return
      }
    }
  }
}

class ColorRowTapGestureRecognizer: UITapGestureRecognizer {
  var hex: String?
}
