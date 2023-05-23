//
//  StackButtons.swift
//  PalettePro
//
//  Created by Will Kitay on 5/22/23.
//

import UIKit

class StackButton: UIButton {
  
  var direction: Direction?
  var isDisabled = true
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    configure()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
    let extendedBounds = bounds.insetBy(dx: 0, dy: -10)
    return extendedBounds.contains(point)
  }
  
  enum Direction {
    case left, right
  }
  
  convenience init(facing direction: Direction) {
    self.init(frame: .zero)
    self.direction = direction
    configure()
  }
  
  func configure() {
    
    let imageName = direction == .left ? "arrow.left" : "arrow.right"
    setImage(UIImage(systemName: imageName)?.withTintColor(.label, renderingMode: .alwaysOriginal), for: .normal)
    setImage(UIImage(systemName: imageName)?.withTintColor(.systemGray, renderingMode: .alwaysOriginal), for: .highlighted)
    
    contentVerticalAlignment = .bottom
    translatesAutoresizingMaskIntoConstraints = false
  }
  
  func setDisabledState(_ isDisabled: Bool) {
    let imageName = direction == .left ? "arrow.left" : "arrow.right"
    if isDisabled {
      let grayImage = UIImage(systemName: imageName)?.withTintColor(.systemGray, renderingMode: .alwaysOriginal)
      setImage(grayImage, for: .normal)
      setImage(grayImage, for: .highlighted)
    } else {
      let defaultImage = UIImage(systemName: imageName)?.withTintColor(.label, renderingMode: .alwaysOriginal)
      setImage(defaultImage, for: .normal)
      setImage(defaultImage, for: .highlighted)
    }
  }
}
