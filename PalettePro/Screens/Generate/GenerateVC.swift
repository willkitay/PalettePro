//
//  ViewController.swift
//  PalettePro
//
//  Created by Will Kitay on 5/8/23.
//

import UIKit

class GenerateVC: UIViewController {
  
  let stackView = UIStackView()
  var colorRows: [ColorRowVC] = []
  
  let generatedRowOne = ColorRowVC()
  let generatedRowTwo = ColorRowVC()
  let generatedRowThree = ColorRowVC()
  let generatedRowFour = ColorRowVC()
  let generatedRowFive = ColorRowVC()
  
  let generateButton = GenerateButton()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    configureStackView()
    configureActionBar()
    layoutUI()
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
  } 
  
  private func configureStackView() {
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.axis = .vertical
    stackView.distribution = .fillEqually
    
    colorRows = [generatedRowOne, generatedRowTwo, generatedRowThree, generatedRowFour, generatedRowFive]
    
    for row in colorRows { stackView.addArrangedSubview(row.view) }
  }
  
  private func layoutUI() {
    view.addSubview(stackView)
    view.addSubview(generateButton)
        
    NSLayoutConstraint.activate([
      stackView.topAnchor.constraint(equalTo: view.topAnchor),
      stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      stackView.bottomAnchor.constraint(equalTo: generateButton.topAnchor),
      
      generateButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
      generateButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      generateButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      generateButton.heightAnchor.constraint(equalToConstant: 40),
    ])
  }

}

