//
//  ViewController.swift
//  PalettePro
//
//  Created by Will Kitay on 5/8/23.
//

import UIKit

class GenerateVC: UIViewController {

  var stack = Stack()
  var colorRows: [ColorRowVC] = []
  let stackView = UIStackView()
  let leftStackButton = StackButton(facing: .left)
  let rightStackButton = StackButton(facing: .right)
  let generateButton = GenerateButton()

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    configureStackView()
    configureActionBar()
    configureUILayout()
    configureStackButtonLayout()
    updateArrowButtonsAppearance()
  }

  override func viewWillAppear(_ animated: Bool) {
    navigationController?.setNavigationBarHidden(true, animated: true)
  }

  private func configureActionBar() {
    generateButton.addTarget(self, action: #selector(generateButtonTapped), for: .touchUpInside)
  }

  @objc func generateButtonTapped() {
    for row in colorRows {
      if !row.lockButton.isLocked {
        row.generateRandomColor()
      }
    }
    stack.push(colorRows.map { ($0.hexLabel.text ?? "", $0.lockButton.isLocked) })
    stack.increment()
    updateArrowButtonsAppearance()
  }

  private func configureStackView() {
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.axis = .vertical
    stackView.distribution = .fillEqually
    
    colorRows = [ColorRowVC(isFirstRowInArray: true), ColorRowVC(), ColorRowVC(), ColorRowVC(), ColorRowVC()]
    
    for row in colorRows { stackView.addArrangedSubview(row.view) }
    stack.push(colorRows.map { ($0.hexLabel.text ?? "", $0.lockButton.isLocked) })
  }
  
  @objc func triggerLeftArrowButton() {
    if stack.currentIndex > 0 {
      stack.decrement()
      updateStackViewColors()
      updateArrowButtonsAppearance()
    }
  }
  
  @objc func triggerRightArrowButton() {
    if stack.currentIndex < stack.array.count - 1 {
      stack.increment()
      updateStackViewColors()
      updateArrowButtonsAppearance()
    }
  }
  
  private func updateStackViewColors() {
    for (index, row) in colorRows.enumerated() {
      let stackData = stack.currentColors()[index]
      let hexColors = stackData.0, lockState = stackData.1
      row.updateStackData(with: hexColors, isLocked: lockState)
    }
  }

  private func updateArrowButtonsAppearance() {
    leftStackButton.setDisabledState(stack.currentIndex == 0)
    rightStackButton.setDisabledState(stack.currentIndex == max(0, stack.array.count - 1))
  }
  
  private func configureStackButtonLayout() {
    view.addSubviews(leftStackButton, rightStackButton)
    leftStackButton.addTarget(self, action: #selector(triggerLeftArrowButton), for: .touchUpInside)
    rightStackButton.addTarget(self, action: #selector(triggerRightArrowButton), for: .touchUpInside)

    let arrowHeight: CGFloat = 25
    let arrowWidth: CGFloat = 20
    let padding: CGFloat = 25
    NSLayoutConstraint.activate([
      leftStackButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
      leftStackButton.centerYAnchor.constraint(equalTo: generateButton.centerYAnchor),
      leftStackButton.trailingAnchor.constraint(equalTo: rightStackButton.leadingAnchor),
      leftStackButton.widthAnchor.constraint(equalToConstant: arrowHeight),
      leftStackButton.heightAnchor.constraint(equalToConstant: arrowWidth),
      
      rightStackButton.leadingAnchor.constraint(equalTo: leftStackButton.trailingAnchor),
      rightStackButton.centerYAnchor.constraint(equalTo: generateButton.centerYAnchor),
      rightStackButton.trailingAnchor.constraint(equalTo: generateButton.leadingAnchor),
      rightStackButton.widthAnchor.constraint(equalToConstant: arrowHeight),
      rightStackButton.heightAnchor.constraint(equalToConstant: arrowWidth)
    ])
  }

  private func configureUILayout() {
    view.addSubviews(stackView, generateButton)

    NSLayoutConstraint.activate([
      stackView.topAnchor.constraint(equalTo: view.topAnchor),
      stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      stackView.bottomAnchor.constraint(equalTo: generateButton.topAnchor),

      generateButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
      generateButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      generateButton.heightAnchor.constraint(equalToConstant: 40),
    ])
  }
}
