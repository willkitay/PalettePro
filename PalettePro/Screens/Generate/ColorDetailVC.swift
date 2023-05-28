//
//  ColorDetailVC.swift
//  PalettePro
//
//  Created by Will Kitay on 5/23/23.
//

import UIKit

protocol ColorDetailVCDelegate: AnyObject {
  func didSelectColor(previousColor: UIColor?, newColor: UIColor?)
}

class ColorDetailVC: UIViewController {
  
  var currentColorHex: String?
  let stackView = UIStackView()
  let dotIndicator = DotIndicator()
  let colorPercentChange = 2
  
  weak var delegate: ColorDetailVCDelegate?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureStackView()
    showBlackDotOnCurrentColor()
  }
  
  convenience init(hex: String?) {
    self.init(nibName: nil, bundle: nil)
    self.currentColorHex = hex
  }
  
  private func showBlackDotOnCurrentColor() {
    let subview = stackView.arrangedSubviews.first(where: { $0.backgroundColor?.toHex() == currentColorHex })
    dotIndicator.setDotIndicator(on: subview)
  }
  
  private func configureStackView() {
    view.addSubview(stackView)
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.axis = .vertical
    stackView.distribution = .fillEqually

    addColors()

    NSLayoutConstraint.activate([
      stackView.topAnchor.constraint(equalTo: view.topAnchor),
      stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
    ])
    
    addTapGestureToStackColors()
  }
  
  private func addColors() {
    addTintColorsToStack()
    addCurrentColorToStack()
    addShadeColorsToStack()
  }
  
  
  private func addTintColorsToStack() {
    guard let currentColorHex else { return }
    var index = 0
    var currentColor = UIColor(hex: currentColorHex)
    var colorSubviews: [UIView] = []
    
    while currentColor?.toHex() != UIColor.white.toHex() && index < 6 {
      index += 1
      currentColor = currentColor?.lighter(by: CGFloat(index * colorPercentChange))
      colorSubviews.append(createColorRowSubView(with: currentColor))
    }
    
    for colorSubview in colorSubviews.reversed() { stackView.addArrangedSubview(colorSubview) }
  }

  private func addShadeColorsToStack() {
    guard let currentColorHex else { return }
    var index = 0
    var currentColor = UIColor(hex: currentColorHex)
    
    while currentColor?.toHex() != UIColor.black.toHex() && index < 6 {
      index += 1
      currentColor = currentColor?.darker(by: CGFloat(index * colorPercentChange))
      stackView.addArrangedSubview(createColorRowSubView(with: currentColor))
    }
  }
  
  private func addCurrentColorToStack() {
    guard let currentColorHex else { return }
    stackView.addArrangedSubview(createColorRowSubView(with: UIColor(hex: currentColorHex)))
  }
  
  private func addTapGestureToStackColors() {
    for subview in stackView.arrangedSubviews {
      let tapGesture = UITapGestureRecognizer(target: self, action: #selector(subviewTapped))
      subview.isUserInteractionEnabled = true
      subview.addGestureRecognizer(tapGesture)
    }
  }
  
  private func createColorRowSubView(with color: UIColor?) -> UIView {
    let subview = UIView()
    subview.backgroundColor = color
    return subview
  }
  
  @objc private func subviewTapped(_ gesture: UITapGestureRecognizer) {
    guard let currentColorHex else { return }
    guard let tappedView = gesture.view else { return }
    guard let newCGColor = tappedView.backgroundColor?.cgColor else { return }

    let previousColor = UIColor(hex: currentColorHex)
    let newColor = UIColor(cgColor: newCGColor)
    delegate?.didSelectColor(previousColor: previousColor, newColor: newColor)
    self.currentColorHex = newColor.toHex()
    
    dotIndicator.setDotIndicator(on: tappedView)
  }
  
}
