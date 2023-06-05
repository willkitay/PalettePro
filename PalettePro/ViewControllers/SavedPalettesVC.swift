//
//  SavedPalettesVC.swift
//  PalettePro
//
//  Created by Will Kitay on 5/31/23.
//

import UIKit


class SavedPalettesVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, SavedColorPaletteCellDelegate {
    
  private var currentDetailPalette = PaletteDetailsVC(colors: [])

  private let scrollView = UIScrollView()
  private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
  let backgroundImageView = UIImageView()
  
  private let cellReuseIdentifier = "SavedColorPaletteCell"
  private let padding: CGFloat = 10
  private var savedPalettes: [Palette] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    title = "Favorite Palettes"
    navigationController?.navigationBar.tintColor = .label
    view.addSubview(backgroundImageView)
    setEmptyBackgroundImage(Images.emptyBox, backgroundImageView: backgroundImageView)
    configure()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    getSavedPalettes()
  }
  
  private func configure() {
    view.addSubview(collectionView)
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    collectionView.backgroundColor = .clear
    collectionView.delegate = self
    
    NSLayoutConstraint.activate([
      collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: padding),
      collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
      collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
      collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -padding)
    ])
    
    collectionView.dataSource = self
    collectionView.delegate = self
    collectionView.register(SavedColorPaletteCell.self, forCellWithReuseIdentifier: cellReuseIdentifier)
    
    let layout = UICollectionViewFlowLayout()
    collectionView.collectionViewLayout = layout
  }
  
  private func getSavedPalettes() {
    PalettePersistenceManager.retrieveFavorites { [weak self] result in
      guard let self = self else { return }
      switch result {
      case .success(let favorites): self.updateUI(with: favorites)
      case .failure(let error): print(error.rawValue)
      }
    }
  }
  
  private func updateUI(with savedPalettes: [Palette]) {
    self.savedPalettes = savedPalettes
    
    let hasSavedPalettes = !savedPalettes.isEmpty
    if hasSavedPalettes {
      backgroundImageView.removeFromSuperview()
    } else {
      view.addSubview(backgroundImageView)
      setEmptyBackgroundImage(Images.emptyBox, backgroundImageView: backgroundImageView)
    }
    
    DispatchQueue.main.async {
      self.collectionView.reloadData()
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return savedPalettes.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath) as! SavedColorPaletteCell
    
    let savedPalette = savedPalettes[indexPath.item]
    let colors = savedPalette.colors.map { UIColor(hex: $0) ?? .clear }

    let palette = SavedColorPalette()
    palette.updateColors(colors)
    palette.widthAnchor.constraint(equalToConstant: collectionView.contentSize.width - 10).isActive = true
    cell.backgroundView = palette
    cell.isUserInteractionEnabled = true
    cell.delegate = self
    return cell
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let cellWidth = collectionView.bounds.width - padding
    return CGSize(width: cellWidth, height: 40)
  }
  
  private func showEmptyBackgroundImage() {
      view.addSubview(backgroundImageView)
      setEmptyBackgroundImage(Images.emptyBox, backgroundImageView: backgroundImageView)
  }
  
  func delete(_ palette: Palette) {
    PalettePersistenceManager.updateWith(favorite: palette, actionType: .remove) { _ in }
    guard let index = savedPalettes.firstIndex(where: { $0.colors == palette.colors }) else { return }
    savedPalettes.remove(at: index)
    collectionView.performBatchUpdates({
      collectionView.deleteItems(at: [IndexPath(item: index, section: 0)])
    }, completion: { _ in
      if self.savedPalettes.isEmpty {
        self.showEmptyBackgroundImage()
      }
    })
  }
  
  func presentPaletteDetailsVC(colors: [String]) {
    print("shouldnt be here")
  }
}

protocol SavedColorPaletteCellDelegate: AnyObject {
    func delete(_ palette: Palette)
}

class SavedColorPaletteCell: UICollectionViewCell {
  
  let paletteView = SavedColorPalette(frame: .zero)
  
  weak var delegate: SavedColorPaletteCellDelegate?
  
  private var currentDetailPalette = PaletteDetailsVC(colors: [])
    
  override init(frame: CGRect) {
    super.init(frame: frame)
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
    contentView.addGestureRecognizer(tapGesture)
    
    let longTapGesture = UILongPressGestureRecognizer(target: self, action: #selector(longTap))
    contentView.addGestureRecognizer(longTapGesture)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  @objc private func handleTap(_ sender: UITapGestureRecognizer) {
    guard let palette = backgroundView as? SavedColorPalette else { return }
    let colors = palette.colors.map { $0.toHex() }
    presentPaletteDetailsVC(colors: colors)
  }
  
  @objc private func longTap(_ sender: UILongPressGestureRecognizer) {
    guard let palette = backgroundView as? SavedColorPalette else { return }
    let colors = palette.colors.map { $0.toHex() }
    print(colors)
    
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
