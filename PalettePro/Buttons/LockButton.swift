//
//  ColorRowButton.swift
//  PalettePro
//
//  Created by Will Kitay on 5/21/23.
//

import UIKit

class LockButton: UIButton {

  var isLocked: Bool = false {
    didSet {
      configure()
    }
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    configure()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
    let extendedBounds = bounds.insetBy(dx: -20, dy: -20)
    return extendedBounds.contains(point)
  }
  
  func configure() {
    addTarget(self, action: #selector(toggleLock), for: .touchUpInside)
    
    let configuration = UIImage.SymbolConfiguration(font: .preferredFont(forTextStyle: .title2))
    let imageName = isLocked ? "lock.fill" : "lock.open.fill"
    let lockColor: UIColor = isLocked ? getContrastTextColor(for: superview?.backgroundColor) : .systemGray4
    
    let lockImage = UIImage(systemName: imageName, withConfiguration: configuration)?.withTintColor(lockColor, renderingMode: .alwaysOriginal)
    setBackgroundImage(lockImage, for: .normal)
    
    translatesAutoresizingMaskIntoConstraints = false
  }
  
  @objc func toggleLock() {
    isLocked.toggle()
  }
  
}
