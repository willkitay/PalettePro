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
  func removeColor()
  func viewPalette()
  func exportPalette()
  func canRemoveColor() -> Bool
}

enum ButtonOption {
  static let viewPalette = String("View Palette")
  static let savePalette = String("Save Palette")
  static let exportPalette = String("Export Palette")
  static let addColor = String("Add Color")
  static let removeColor = String("Remove Color")
}

class OptionsHandler: NSObject {
  
  weak var delegate: OptionsHandlerDelegate?
  
  var buttons: [UIAlertAction] = []
  
  func showOptions(from viewController: UIViewController, sourceView: UIView) {
    buttons.removeAll()
    
    let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
    actionSheet.view.tintColor = .label
    
    viewPaletteButton()
    exportPaletteButton()
    addColorButton()
    removeColorButton()
    
    for button in buttons { actionSheet.addAction(button) }
    
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
    actionSheet.addAction(cancelAction)
    
    viewController.present(actionSheet, animated: true)
  }
  
  private func viewPaletteButton() {
    buttons.append(UIAlertAction(title: ButtonOption.viewPalette, style: .default, handler: { _ in
      self.delegate?.viewPalette()
    }))
  }
  
  private func exportPaletteButton() {
    buttons.append(UIAlertAction(title: ButtonOption.exportPalette, style: .default, handler: { _ in
      self.delegate?.exportPalette()
    }))
  }
  
  private func removeColorButton() {
    if delegate?.currentNumberOfRows ?? 0 > 2 && ((delegate?.canRemoveColor()) == true) {
      buttons.append(UIAlertAction(title: ButtonOption.removeColor, style: .default, handler: { _ in
        self.delegate?.removeColor()
      }))
    }
  }
  
  private func addColorButton() {
    if delegate?.currentNumberOfRows != Constants.maxNumberOfRows {
      buttons.append(UIAlertAction(title: ButtonOption.addColor, style: .default, handler: { _ in
        self.delegate?.addColor()
      }))
    }
  }
}
