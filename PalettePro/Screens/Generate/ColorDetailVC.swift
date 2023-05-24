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
    showBlackDot(on: stackView.arrangedSubviews.first(where: { $0.backgroundColor?.toHex() == currentColorHex }))
  }
  
  private func configureStackView() {
    view.addSubview(stackView)
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.axis = .vertical
    stackView.distribution = .fillEqually

    addColors()
//    addTintColorsToStack()
//    addCurrentColorToStack()
//    addShadeColorsToStack()
//
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
    let whiteHex = UIColor.white.toHex()
    var index = 0
    var currentColor = UIColor(hex: currentColorHex)
    var colorSubviews: [UIView] = []
    
    while currentColor?.toHex() != whiteHex {
      index += 1
      currentColor = currentColor?.lighter(by: CGFloat(index * colorPercentChange))
      colorSubviews.append(createColorRowSubView(with: currentColor))
    }
    
    for colorSubview in colorSubviews.reversed() { stackView.addArrangedSubview(colorSubview) }
  }

  private func addShadeColorsToStack() {
    guard let currentColorHex else { return }
    let blackHex = UIColor.black.toHex()
    var index = 0
    var currentColor = UIColor(hex: currentColorHex)
    
    while currentColor?.toHex() != blackHex {
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
      let tapGesture = UITapGestureRecognizer(target: self, action: #selector(subviewTapped(_:)))
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
    
    showBlackDot(on: tappedView)
  }
  
  func showBlackDot(on subview: UIView?) {
    guard let subview = subview else { return }
    removeOldDot()
    
    dotIndicator.backgroundColor = getContrastTextColor(for: subview.backgroundColor)
    subview.addSubview(dotIndicator)
    dotIndicator.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      dotIndicator.centerYAnchor.constraint(equalTo: subview.centerYAnchor),
      dotIndicator.centerXAnchor.constraint(equalTo: subview.centerXAnchor)
    ])
  }
  
  private func removeOldDot() {
    for view in stackView.arrangedSubviews {
      if let dotView = view.subviews.first(where: { $0 is DotIndicator }) {
        dotView.removeFromSuperview()
        break
      }
    }
  }

}
