//
//  SavedColorsVC.swift
//  PalettePro
//
//  Created by Will Kitay on 5/31/23.
//

import UIKit

class SavedColorsVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  
  private let colorsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
  private let containerView = UIView()
  
  private var colors: [Color] = []
  private var selectedColors: [Color] = []
  private var selectState: SelectState = .select
  
  private let padding: CGFloat = 10
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureNavigationBar()
    configureContainerView()
    configureColorsCollectionView()
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    if selectState == .cancel { toggleSelectState() }
    navigationItem.leftBarButtonItem?.isHidden = true
    deselectAllCells()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    getSavedColors()
    navigationItem.rightBarButtonItem?.isHidden = colors.isEmpty
  }
    
  @objc private func toggleSelectState() {
    selectState = selectState == .select ? .cancel : .select
    navigationItem.rightBarButtonItem?.title = selectState.string
    navigationItem.leftBarButtonItem?.isHidden.toggle()
    disableTrashButton()
    deselectAllCells()
  }
  
  private func configureNavigationBar() {
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: selectState.string, style: .plain, target: self, action: #selector(toggleSelectState))
    navigationItem.rightBarButtonItem?.tintColor = .systemCyan
    
    navigationItem.leftBarButtonItem = UIBarButtonItem(image: Symbols.trash, style: .plain, target: self, action: #selector(deleteSelectedColors))
    navigationItem.leftBarButtonItem?.isHidden = true
    disableTrashButton()
    title = "Favorite Colors"
  }
  
  @objc private func deleteSelectedColors() {
    guard !selectedColors.isEmpty else { return }
    unsaveSelectedColors()
    removeSelectedColorsFromColors()
    deselectAllCells()
    removeSelectedColorsFromCollectionView()
    disableTrashButton()
    toggleSelectState()
    navigationItem.rightBarButtonItem?.isHidden = colors.isEmpty
  }
  
  private func disableTrashButton() {
    navigationItem.leftBarButtonItem?.tintColor = .systemGray
  }
  
  private func removeSelectedColorsFromColors() {
    colors.removeAll { color in selectedColors.contains { $0.hex == color.hex } }
  }
  
  private func removeSelectedColorsFromCollectionView() {
    guard let indexPathsToRemove = colorsCollectionView.indexPathsForSelectedItems else { return }
    colorsCollectionView.performBatchUpdates({
      colorsCollectionView.deleteItems(at: indexPathsToRemove)
    })
  }
  
  private func unsaveSelectedColors() {
    for color in selectedColors {
      ColorPersistenceManager.updateWith(favorite: color, actionType: .remove) { _ in }
    }
  }

  private func deselectAllCells() {
    selectedColors.removeAll()
    for indexPath in colorsCollectionView.indexPathsForVisibleItems {
      let cell = colorsCollectionView.cellForItem(at: indexPath)
      cell?.isSelected = false
      removeBadgeFromCell(cell)
    }
  }
  
  private func removeBadgeFromCell(_ cell: UICollectionViewCell?) {
    guard let cell else { return }
    for subview in cell.contentView.subviews {
      subview.removeFromSuperview()
    }
  }
  
  private func getSavedColors() {
    ColorPersistenceManager.retrieveFavorites{ [weak self] result in
      guard let self else { return }
      switch result {
      case .success(let colors): updateColorsCollection(with: colors)
      case .failure(let error): print(error.rawValue)
      }
    }
  }
  
  private func updateColorsCollection(with savedColors: [Color]) {
    colors = savedColors
    colorsCollectionView.reloadData()
  }
  
  @objc private func tapColor(_ sender: UIGestureRecognizer) {
    if selectState == .cancel {
      selectColor(for: sender)
    } else {
      openPaletteDetailsVC(for: sender)
    }
  }
  
  private func selectColor(for sender: UIGestureRecognizer) {
    guard let indexPath = colorsCollectionView.indexPathForItem(at: sender.location(in: colorsCollectionView)) else { return }
    guard let cell = colorsCollectionView.cellForItem(at: indexPath) else { return }
    
    if cell.isSelected {
      deselect(cell, at: indexPath)
    } else {
      select(cell, at: indexPath, for: sender)
    }
  }
  
  private func deselect(_ cell: UICollectionViewCell, at indexPath: IndexPath) {
    guard let index = selectedColors.firstIndex(where: { $0.hex == cell.backgroundColor?.toHex() }) else { return }
    
    selectedColors.remove(at: index)
    colorsCollectionView.deselectItem(at: indexPath, animated: true)
    cell.isSelected = false
    removeBadgeFromCell(cell)
    if selectedColors.isEmpty { disableTrashButton() }
  }
  
  private func select(_ cell: UICollectionViewCell, at indexPath: IndexPath, for sender: UIGestureRecognizer) {
    selectedColors.append(Color(hex: cell.backgroundColor?.toHex() ?? ""))
    colorsCollectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredVertically)
    cell.isSelected = true
    configureSelectedUICollectionViewCell(with: sender, for: cell)
    
    navigationItem.leftBarButtonItem?.tintColor = .systemRed
  }
  
  private func configureSelectedUICollectionViewCell(with sender: UIGestureRecognizer, for cell: UICollectionViewCell?) {
    guard let cell else { return }
    
    let badgeContainerView = UIView()
    badgeContainerView.translatesAutoresizingMaskIntoConstraints = false
    cell.contentView.addSubview(badgeContainerView)
    
    NSLayoutConstraint.activate([
      badgeContainerView.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 5),
      badgeContainerView.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -5),
      badgeContainerView.widthAnchor.constraint(equalToConstant: 20),
      badgeContainerView.heightAnchor.constraint(equalToConstant: 20)
    ])
    
    let badge = createSelectedCellBadge(for: cell)
    badgeContainerView.addSubview(badge)
    badge.pinToEdges(of: badgeContainerView)
  }
  
  private func createSelectedCellBadge(for cell: UICollectionViewCell) -> UIView {
    let badgeImageView = UIImageView(image: Symbols.checkmarked)
    badgeImageView.translatesAutoresizingMaskIntoConstraints = false
    badgeImageView.tintColor = getContrastTextColor(for: cell.backgroundColor)
    return badgeImageView
  }
  
  private func openPaletteDetailsVC(for sender: UIGestureRecognizer) {
    guard let color = sender.view?.backgroundColor?.toHex() else { return }
    let paletteDetailsVC = PaletteDetailsVC(colors: [color])
    RootVCManager.shared?.present(paletteDetailsVC, animated: true)
  }
  
  private func configureContainerView() {
    view.addSubview(containerView)
    containerView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      containerView.topAnchor.constraint(equalTo: view.topAnchor),
      containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    ])
  }
  
  private func configureColorsCollectionView() {
    view.addSubview(colorsCollectionView)
    
    colorsCollectionView.backgroundView = createBackgroundImage()
    colorsCollectionView.collectionViewLayout = createFlowLayout()
    colorsCollectionView.translatesAutoresizingMaskIntoConstraints = false
    colorsCollectionView.dataSource = self
    colorsCollectionView.delegate = self
    colorsCollectionView.backgroundColor = .systemBackground
    colorsCollectionView.allowsMultipleSelection = true
    colorsCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "ColorCell")
    colorsCollectionView.pinToEdges(of: containerView)
  }
  
  private func createFlowLayout() -> UICollectionViewFlowLayout {
    let layout = UICollectionViewFlowLayout()
    layout.minimumInteritemSpacing = padding
    layout.minimumLineSpacing = padding
    layout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
    layout.scrollDirection = .vertical
    return layout
  }
  
  private func createBackgroundImage() -> UIImageView {
    let insets = UIEdgeInsets(top: 30, left: 20, bottom: 30, right: 30)
    let image = Images.savedColors?.imageWithInsets(insets: insets)
    let backgroundImage = UIImageView(image: image)
    backgroundImage.contentMode = .scaleAspectFit
    return backgroundImage
  }
}

extension SavedColorsVC {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    Task {
      UIView.animate(withDuration: 0.2) {
        if self.colors.count > 0 {
          self.colorsCollectionView.backgroundView?.isHidden = true
        } else {
          self.colorsCollectionView.backgroundView?.isHidden = false
        }
      }
    }
    return colors.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ColorCell", for: indexPath)
    cell.backgroundColor = UIColor(hex: colors[indexPath.item].hex)
    cell.layer.cornerRadius = 10
    
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapColor))
    cell.addGestureRecognizer(tapGesture)
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let availableWidth = collectionView.bounds.width - padding * 6
    let itemWidth = availableWidth / 5
    return CGSize(width: itemWidth, height: itemWidth)
  }
}

