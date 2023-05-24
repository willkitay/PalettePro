//
//  ColorDetailVC.swift
//  PalettePro
//
//  Created by Will Kitay on 5/23/23.
//

import UIKit

protocol ColorDetailVCDelegate: AnyObject {
  func didSelectColor(oldColor: UIColor?, newColor: UIColor?)
}

class ColorDetailVC: UIViewController {
  
  var currentColorHex: String?
  let stackView = UIStackView()
  var selectedSubview: UIView?
  
  weak var delegate: ColorDetailVCDelegate?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureStackView()
    showBlackDot(on: stackView.arrangedSubviews.first(where: { $0.backgroundColor?.toHex() == currentColorHex }))
  }
  
  convenience init(hex: String?) {
    self.init(nibName: nil, bundle: nil)
    self.currentColorHex = hex
  }
  
  private func createColorRowSubView(with color: UIColor?) -> UIView {
    let subview = UIView()
    subview.backgroundColor = color
    return subview
  }
  
  private func configureStackView() {
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.axis = .vertical
    stackView.distribution = .fillEqually

    let colorPercentChange = 7
    let numberOfRows = 10
    
    for i in (1..<numberOfRows).reversed() {
      let tintedColor = UIColor(hex: currentColorHex ?? "")?.lighter(by: CGFloat(i * colorPercentChange))
      stackView.addArrangedSubview(createColorRowSubView(with: tintedColor))
    }

    stackView.addArrangedSubview(createColorRowSubView(with: UIColor(hex: currentColorHex ?? "")))
    
    for i in (1..<numberOfRows) {
      let shadedColor = UIColor(hex: currentColorHex ?? "")?.darker(by: CGFloat(i * colorPercentChange))
      stackView.addArrangedSubview(createColorRowSubView(with: shadedColor))
    }

    view.addSubview(stackView)
    NSLayoutConstraint.activate([
      stackView.topAnchor.constraint(equalTo: view.topAnchor),
      stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
    ])
    
    for subview in stackView.arrangedSubviews {
      let tapGesture = UITapGestureRecognizer(target: self, action: #selector(subviewTapped(_:)))
      subview.isUserInteractionEnabled = true
      subview.addGestureRecognizer(tapGesture)
    }
  }
  
  @objc private func subviewTapped(_ gesture: UITapGestureRecognizer) {
    guard let tappedView = gesture.view else { return }
    guard let currentColorHex else { return }
    
    showBlackDot(on: tappedView)
    
    guard let cgColor = tappedView.backgroundColor?.cgColor else { return }
    let newColor = UIColor(cgColor: cgColor)
    
    delegate?.didSelectColor(oldColor: UIColor(hex: currentColorHex), newColor: newColor)
    self.currentColorHex = newColor.toHex()
  }
  
  func showBlackDot(on subview: UIView?) {
    guard let subview else { return }
    
    for view in stackView.arrangedSubviews {
      if let dotView = view.subviews.first(where: { $0.backgroundColor == .black }) {
        dotView.removeFromSuperview()
      }
    }
    
    let dotView = createBlackDotView()
    subview.addSubview(dotView)
    
    NSLayoutConstraint.activate([
      dotView.centerXAnchor.constraint(equalTo: subview.centerXAnchor),
      dotView.centerYAnchor.constraint(equalTo: subview.centerYAnchor),
    ])
  }
  
  private func createBlackDotView() -> UIView {
    let dotView = UIView()
    dotView.backgroundColor = .black
    dotView.layer.cornerRadius = 5.0
    dotView.translatesAutoresizingMaskIntoConstraints = false
    dotView.widthAnchor.constraint(equalToConstant: 10.0).isActive = true
    dotView.heightAnchor.constraint(equalToConstant: 10.0).isActive = true
    return dotView
  }

}
