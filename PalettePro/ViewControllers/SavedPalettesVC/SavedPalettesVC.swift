//
//  SavedPalettesVC.swift
//  PalettePro
//
//  Created by Will Kitay on 5/31/23.
//

import UIKit


class SavedPalettesVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, SavedPaletteCellDelegate {
    
  private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
  private let cellReuseIdentifier = "SavedColorPaletteCell"

  let backgroundImageView = UIImageView()
  
  private var savedPalettes: [Palette] = []
  
  private let padding: CGFloat = 10

  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    title = "Favorite Palettes"
    navigationController?.navigationBar.tintColor = .label
    view.addSubview(backgroundImageView)
    setEmptyBackgroundImage(Images.savedPalettes, backgroundImageView: backgroundImageView)
    configure()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    getSavedPalettes()
  }
  
  private func configure() {
    view.addSubview(collectionView)
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    collectionView.backgroundColor = .clear
    collectionView.dataSource = self
    collectionView.delegate = self
    collectionView.register(SavedPaletteCell.self, forCellWithReuseIdentifier: cellReuseIdentifier)
    
    let layout = UICollectionViewFlowLayout()
    collectionView.collectionViewLayout = layout
    
    NSLayoutConstraint.activate([
      collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: padding),
      collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
      collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
      collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -padding)
    ])
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
    
    if savedPalettes.isEmpty {
      view.addSubview(backgroundImageView)
      setEmptyBackgroundImage(Images.savedPalettes, backgroundImageView: backgroundImageView)
    } else {
      backgroundImageView.removeFromSuperview()
    }
    
    Task { self.collectionView.reloadData() }
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return savedPalettes.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath) as! SavedPaletteCell
    
    let colors = savedPalettes[indexPath.item].colors
    cell.backgroundView = createSavedPalette(with: colors)
    cell.isUserInteractionEnabled = true
    cell.delegate = self
    return cell
  }
  
  private func createSavedPalette(with colors: [String]) -> SavedColorPalette {
    let palette = SavedColorPalette()
    let colors = colors.map { UIColor(hex: $0) ?? .clear }
    
    palette.updateColors(colors)
    palette.widthAnchor.constraint(equalToConstant: collectionView.contentSize.width - padding).isActive = true
    return palette
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let cellWidth: CGFloat = collectionView.bounds.width - padding
    let cellHeight: CGFloat = 40
    return CGSize(width: cellWidth, height: cellHeight)
  }
  
  private func showEmptyBackgroundImage() {
      view.addSubview(backgroundImageView)
      setEmptyBackgroundImage(Images.savedPalettes, backgroundImageView: backgroundImageView)
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
}

