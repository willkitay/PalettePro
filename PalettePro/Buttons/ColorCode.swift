//
//  ColorCode.swift
//  PalettePro
//
//  Created by Will Kitay on 5/25/23.
//

import UIKit

class ColorCode: UIButton {
  
  var color: UIColor = .clear
  
  var body: String! {
    didSet {
      configuration?.subtitle = body
    }
  }
  
  init(title: String) {
    super.init(frame: .zero)
    configure(title: title)
  }
  
  override var intrinsicContentSize: CGSize {
    let contentSize = super.intrinsicContentSize
    let height = min(contentSize.height, 60)
    return CGSize(width: contentSize.width, height: height)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func updateColor(_ color: UIColor) {
    self.color = color
    self.backgroundColor = color
    setTitleAttributes(color)
    setSubtitleAttributes(color)
  }
  
  private func configure(title: String) {
    contentHorizontalAlignment = .left
    layer.cornerRadius = 10
    frame.size.height = 50
    backgroundColor = color
    tintColor = getContrastTextColor(for: color)
    
    var configuration = UIButton.Configuration.plain()
    configuration.baseBackgroundColor = color
    configuration.buttonSize = .large
    configuration.showsActivityIndicator = false
    configuration.title = title.uppercased()
    configuration.contentInsets.leading = 10
    configuration.titleAlignment = .leading
    configuration.titlePadding = 5
    self.configuration = configuration
    
    setTitleAttributes(color)
    setSubtitleAttributes(color)
  }
  
  override func updateConfiguration() {
    if self.state == .highlighted {
      configureBackgroundColor()
    } else {
      backgroundColor = color
    }
  }
  
  private func configureBackgroundColor() {
    let isBrightBackground = getContrastTextColor(for: color) == .white
    
    if isBrightBackground {
      backgroundColor = backgroundColor?.lighter(by: 10)
    } else {
      backgroundColor = backgroundColor?.darker(by: 10)
    }
  }
    
  private func setSubtitleAttributes(_ color: UIColor) {
    configuration?.subtitleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
      var outgoing = incoming
      outgoing.foregroundColor = getContrastTextColor(for: color)
      outgoing.font = .preferredFont(forTextStyle: .body)
      return outgoing
    }
  }
  
  private func setTitleAttributes(_ color: UIColor) {
    configuration?.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
      var outgoing = incoming
      outgoing.font = .boldSystemFont(ofSize: 12)
      outgoing.foregroundColor = getContrastTextColor(for: color).withAlphaComponent(0.5)
      return outgoing
    }
  }
  
}

