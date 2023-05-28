//
//  OptionsHandler.swift
//  PalettePro
//
//  Created by Will Kitay on 5/24/23.
//

import UIKit

protocol OptionsHandlerDelegate: AnyObject {
  func viewPalette()
  func savePalette()
  func exportPalette()
  func addColor()
  func removeColor()
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
  let maxNumberOfRows = Constants.maxNumberOfRows
  
  func showOptions(from viewController: UIViewController, sourceView: UIView) {
    let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
    actionSheet.view.tintColor = .label
    
    let buttons = [
      UIAlertAction(title: ButtonOption.viewPalette, style: .default, handler: { _ in
        self.delegate?.viewPalette()
      }),
//      UIAlertAction(title: ButtonOption.savePalette, style: .default, handler: { _ in
//        self.delegate?.savePalette()
//      }),
      UIAlertAction(title: ButtonOption.exportPalette, style: .default, handler: { _ in
        self.delegate?.exportPalette()
      }),
      UIAlertAction(title: ButtonOption.addColor, style: .default, handler: { _ in
        self.delegate?.addColor()
      }),
      UIAlertAction(title: ButtonOption.removeColor, style: .default, handler: { _ in
        self.delegate?.removeColor()
      })
    ]
    
    for button in buttons {
      actionSheet.addAction(button)
    }
    
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
    actionSheet.addAction(cancelAction)
    
    viewController.present(actionSheet, animated: true)
  }
}

