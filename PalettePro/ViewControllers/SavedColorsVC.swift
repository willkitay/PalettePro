//
//  SavedColorsVC.swift
//  PalettePro
//
//  Created by Will Kitay on 5/31/23.
//

import UIKit

class SavedColorsVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  
  private let colorsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
  private let bottomBar = UIView()
  private let containerView = UIView()
  private let trashButton = UIButton()
  
  private var colors: [Color] = []
  private var selectedColors: [Color] = []
  private var selectState: SelectState = .select
  
  private let padding: CGFloat = 10
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureNavigationBar()
    configureContainerView()
    configureColorsCollectionView()
    configureBottomBar()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    getSavedColors()
  }
  
  @objc private func toggleSelectState() {
    selectState = selectState == .select ? .cancel : .select
    navigationItem.rightBarButtonItem?.title = selectState.string
    toggleTabBar()
    deselectAllCells()
  }
  
  private func toggleTabBar() {
    tabBarController?.tabBar.isHidden.toggle()
    bottomBar.isHidden.toggle()
  }
  
  private func configureNavigationBar() {
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: selectState.string, style: .plain, target: self, action: #selector(toggleSelectState))
    title = "Colors"
    navigationController?.navigationBar.tintColor = .systemGreen
  }
  
  @objc private func deleteSelectedColors() {
    guard !selectedColors.isEmpty else { return }
    unsaveSelectedColors()
    removeSelectedColorsFromColors()
    deselectAllCells()
    removeSelectedColorsFromCollectionView()
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
    trashButton.tintColor = .systemGray
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
    if selectedColors.isEmpty { trashButton.tintColor = .systemGray }
  }
  
  private func select(_ cell: UICollectionViewCell, at indexPath: IndexPath, for sender: UIGestureRecognizer) {
    selectedColors.append(Color(hex: cell.backgroundColor?.toHex() ?? ""))
    colorsCollectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredVertically)
    cell.isSelected = true
    configureSelectedUICollectionViewCell(with: sender, for: cell)
    trashButton.tintColor = .systemGreen
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
    let badgeImageView = UIImageView(image: UIImage(systemName: "checkmark.circle.fill"))
    badgeImageView.translatesAutoresizingMaskIntoConstraints = false
    badgeImageView.tintColor = getContrastTextColor(for: cell.backgroundColor)
    return badgeImageView
  }
  
  private func openPaletteDetailsVC(for sender: UIGestureRecognizer) {
    guard let color = sender.view?.backgroundColor?.toHex() else { return }
    let paletteDetailsVC = PaletteDetailsVC(colors: [color])
    present(paletteDetailsVC, animated: true)
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
  
  private func configureBottomBar() {
    colorsCollectionView.addSubview(bottomBar)
    bottomBar.translatesAutoresizingMaskIntoConstraints = false
    bottomBar.isHidden = true
 
    let tabBarHeight: CGFloat = tabBarController?.tabBar.frame.size.height ?? 80
    NSLayoutConstraint.activate([
      bottomBar.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
      bottomBar.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
      bottomBar.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
      bottomBar.heightAnchor.constraint(equalToConstant: tabBarHeight)
    ])
    
    configureBottomBarBackground()
    configureBottomBarTitle()
    configureTrashButton()
  }
  
  private func configureBottomBarTitle() {
    let titleLabel = UILabel()
    bottomBar.addSubview(titleLabel)
    titleLabel.text = "Select Items"
    titleLabel.textColor = .label
    titleLabel.font = .preferredFont(forTextStyle: .headline)
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    titleLabel.textAlignment = .center
    
    let tabBarHeight: CGFloat = tabBarController?.tabBar.frame.size.height ?? 80
    NSLayoutConstraint.activate([
      titleLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
      titleLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10),
      titleLabel.heightAnchor.constraint(equalToConstant: tabBarHeight),
      titleLabel.widthAnchor.constraint(equalToConstant: 150),
    ])
  }
  
  private func configureBottomBarBackground() {
    let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.systemThickMaterial)
    let blurEffectView = UIVisualEffectView(effect: blurEffect)
    blurEffectView.frame = bottomBar.bounds
    blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    bottomBar.addSubview(blurEffectView)
  }
  
  private func configureTrashButton() {
    
    bottomBar.addSubview(trashButton)
    trashButton.setImage(UIImage(systemName: "trash"), for: .normal)
    trashButton.setPreferredSymbolConfiguration(.init(textStyle: .headline), forImageIn: .normal)
    trashButton.tintColor = .systemGray
    trashButton.translatesAutoresizingMaskIntoConstraints = false
    trashButton.addTarget(self, action: #selector(deleteSelectedColors), for: .touchUpInside)
    
    let tabBarHeight: CGFloat = tabBarController?.tabBar.frame.size.height ?? 80
    NSLayoutConstraint.activate([
      trashButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
      trashButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10),
      trashButton.widthAnchor.constraint(equalToConstant: 50),
      trashButton.heightAnchor.constraint(equalToConstant: tabBarHeight),
    ])
  }
  
  private func configureColorsCollectionView() {
    view.addSubview(colorsCollectionView)
    
    colorsCollectionView.translatesAutoresizingMaskIntoConstraints = false
    colorsCollectionView.dataSource = self
    colorsCollectionView.delegate = self
    colorsCollectionView.backgroundColor = .systemBackground
    colorsCollectionView.allowsMultipleSelection = true
    colorsCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "ColorCell")
    
    let layout = UICollectionViewFlowLayout()
    layout.minimumInteritemSpacing = padding
    layout.minimumLineSpacing = padding
    layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    layout.scrollDirection = .vertical
    colorsCollectionView.collectionViewLayout = layout
    
    NSLayoutConstraint.activate([
      colorsCollectionView.topAnchor.constraint(equalTo: containerView.topAnchor),
      colorsCollectionView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
      colorsCollectionView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
      colorsCollectionView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
    ])
  }
}

extension SavedColorsVC {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
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
