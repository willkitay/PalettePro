//
//  SavedPaletteCell.swift
//  PalettePro
//
//  Created by Will Kitay on 6/5/23.
//

import UIKit

protocol SavedPaletteCellDelegate: AnyObject {
  func delete(_ palette: Palette)
}

class SavedPaletteCell: UICollectionViewCell {
  
  weak var delegate: SavedPaletteCellDelegate?
  private var currentDetailPalette = PaletteDetailsVC(colors: [])
    
  override init(frame: CGRect) {
    super.init(frame: frame)
    configureGestures()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func configureGestures() {
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
    contentView.addGestureRecognizer(tapGesture)
    
    let longTapGesture = UILongPressGestureRecognizer(target: self, action: #selector(longTap))
    contentView.addGestureRecognizer(longTapGesture)
  }
  
  @objc private func handleTap(_ sender: UITapGestureRecognizer) {
    guard let palette = backgroundView as? SavedColorPalette else { return }
    let colors = palette.colors.map { $0.toHex() }
    presentPaletteDetailsVC(colors: colors)
  }
  
  @objc private func longTap(_ sender: UILongPressGestureRecognizer) {
    guard let palette = backgroundView as? SavedColorPalette else { return }
    let colors = palette.colors.map { $0.toHex() }
    
    let deleteAction = UIAlertAction(title: "Delete Palette?", style: .destructive) { _ in
      self.delegate?.delete(Palette(colors: colors))
    }
    
    RootVCManager.shared?.deleteAlert(deleteAction: deleteAction, forTitle: "Palette")
  }
    
  func presentPaletteDetailsVC(colors: [String]) {
    guard let selectedColor = UIColor(hex: colors[0]) else { return }
    
    currentDetailPalette.colors = colors
    currentDetailPalette.selectColor(selectedColor)
    currentDetailPalette.tabBar.setTabBarColors(colors)
    
    RootVCManager.shared?.present(currentDetailPalette, animated: true)
  }

}
