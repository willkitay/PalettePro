//
//  OptionsHandler.swift
//  PalettePro
//
//  Created by Will Kitay on 5/24/23.
//

import UIKit

protocol OptionsHandlerDelegate: AnyObject {
  var currentNumberOfRows: Int { get }
  
  func addColor()
  func viewPalette(hexColors: [String])
  func exportPalette()
  func savePalette()
}

enum ButtonOption {
  static let viewPalette = String("View Palette")
  static let savePalette = String("Save Palette")
  static let exportPalette = String("Export Palette")
  static let addColor = String("Add Color")
}

class OptionsManager: NSObject {
  
  weak var delegate: OptionsHandlerDelegate?
  
  var buttons: [UIAlertAction] = []
  
  func showOptions(from viewController: UIViewController, sourceView: UIView) {
    buttons.removeAll()
    
    let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
    actionSheet.view.tintColor = .label
    
    viewPaletteButton()
    savePalette()
    exportPaletteButton()
    addColorButton()
    
    for button in buttons { actionSheet.addAction(button) }
    
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
    actionSheet.addAction(cancelAction)
    
    viewController.present(actionSheet, animated: true)
  }
  
  private func savePalette() {
    buttons.append(UIAlertAction(title: ButtonOption.savePalette, style: .default, handler: { _ in
      self.delegate?.savePalette()
    }))
  }
  
  private func viewPaletteButton() {
    buttons.append(UIAlertAction(title: ButtonOption.viewPalette, style: .default, handler: { _ in
      self.delegate?.viewPalette(hexColors: [])
    }))
  }
  
  private func exportPaletteButton() {
    buttons.append(UIAlertAction(title: ButtonOption.exportPalette, style: .default, handler: { _ in
      self.delegate?.exportPalette()
    }))
  }
  
  private func addColorButton() {
    if delegate?.currentNumberOfRows != Constants.maxNumberOfRows {
      buttons.append(UIAlertAction(title: ButtonOption.addColor, style: .default, handler: { _ in
        self.delegate?.addColor()
      }))
    }
  }
}
