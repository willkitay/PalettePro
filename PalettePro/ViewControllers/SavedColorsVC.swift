//
//  SavedColorsVC.swift
//  PalettePro
//
//  Created by Will Kitay on 5/31/23.
//

import UIKit

enum SelectState: String {
  case select, cancel
  
  var string: String {
    switch self {
    case .select: return "Select"
    case .cancel: return "Cancel"
    }
  }
}

class SavedColorsVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  
  let colorsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
  let bottomBar = UIView()
  let containerView = UIView()
  
  var colors: [Color] = []
  var selectedColors: [Color] = []
  var editButtonState: SelectState = .select
  
  let padding: CGFloat = 10
  
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: editButtonState.string, style: .plain, target: self, action: #selector(selectColors))
    
    configureContainerView()
    configure()
    configureColorsCollectionView()
    configureBottomBar()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    getSavedColors()
  }
  
  
  
  @objc func selectColors() {
    if editButtonState == .select {
      tapSelectButton()
    } else {
      tapCancelButton()
    }
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
    bottomBar.isHidden = false
    
    let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.systemThickMaterial)
    let blurEffectView = UIVisualEffectView(effect: blurEffect)
    blurEffectView.frame = bottomBar.bounds
    blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
      
    let tabBarHeight: CGFloat = tabBarController?.tabBar.frame.size.height ?? 80
    NSLayoutConstraint.activate([
      bottomBar.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
      bottomBar.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
      bottomBar.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
      bottomBar.heightAnchor.constraint(equalToConstant: tabBarHeight)
    ])
    
    bottomBar.addSubview(blurEffectView)

    let titleLabel = UILabel()
    bottomBar.addSubview(titleLabel)
    titleLabel.text = "Select Items"
    titleLabel.textColor = .label
    titleLabel.font = .preferredFont(forTextStyle: .headline)
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    titleLabel.textAlignment = .center
    
    NSLayoutConstraint.activate([
      titleLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
      titleLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10),
      titleLabel.heightAnchor.constraint(equalToConstant: tabBarHeight),
      titleLabel.widthAnchor.constraint(equalToConstant: 150),
    ])
    
    let trashButton = UIButton()
    bottomBar.addSubview(trashButton)
    trashButton.setImage(UIImage(systemName: "trash"), for: .normal)
    trashButton.setPreferredSymbolConfiguration(.init(textStyle: .headline), forImageIn: .normal)
    trashButton.translatesAutoresizingMaskIntoConstraints = false
    trashButton.addTarget(self, action: #selector(deleteSelectedColors), for: .touchUpInside)
    
    
    NSLayoutConstraint.activate([
      trashButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
      trashButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10),
      trashButton.widthAnchor.constraint(equalToConstant: 50),
      trashButton.heightAnchor.constraint(equalToConstant: tabBarHeight),
    ])
    
  }
  
  @objc func deleteSelectedColors() {
    for color in selectedColors {
      ColorPersistenceManager.updateWith(favorite: color, actionType: .remove) { _ in }
    }
    
    let indexPathsToRemove = colorsCollectionView.indexPathsForSelectedItems ?? []
    colors.removeAll { color in
      selectedColors.contains { $0.hex == color.hex }
    }
    
    deselectAllCells()
    
    colorsCollectionView.performBatchUpdates({
      colorsCollectionView.deleteItems(at: indexPathsToRemove)
    })
  }
  
  private func tapSelectButton() {
    bottomBar.isHidden = false
    colorsCollectionView.bringSubviewToFront(bottomBar)
    editButtonState = .cancel
    navigationItem.rightBarButtonItem?.title = SelectState.cancel.string
    tabBarController?.tabBar.isHidden = true
  }
  
  private func deselectAllCells() {
    for indexPath in colorsCollectionView.indexPathsForVisibleItems {
      if let cell = colorsCollectionView.cellForItem(at: indexPath) {
        removeBadgeFromCell(cell)
        cell.isSelected = false
      }
    }
  }
  
  private func tapCancelButton() {
    bottomBar.isHidden = true
    tabBarController?.tabBar.isHidden = false
    editButtonState = .select
    navigationItem.rightBarButtonItem?.title = SelectState.select.string
    selectedColors.removeAll()
    
    deselectAllCells()
    getSavedColors()
    colorsCollectionView.reloadData()
  }
  
  private func removeBadgeFromCell(_ cell: UICollectionViewCell) {
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
  
  @objc func tapColor(_ sender: UIGestureRecognizer) {
    if editButtonState == .cancel {
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
      for (index, color) in selectedColors.enumerated() {
        if cell.backgroundColor?.toHex() == color.hex {
          selectedColors.remove(at: index)
          return
        }
      }
    } else {
      selectedColors.append(Color(hex: cell.backgroundColor?.toHex() ?? ""))
      colorsCollectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredVertically)
      cell.isSelected = true
      configureSelectedUICollectionViewCell(with: sender, for: cell)
    }
  }
  
  private func deselect(_ cell: UICollectionViewCell, at indexPath: IndexPath) {
    cell.isSelected = false
    removeBadgeFromCell(cell)
  }
  
  private func configureSelectedUICollectionViewCell(with sender: UIGestureRecognizer, for cell: UICollectionViewCell?) {
    
    let badgeContainerView = UIView()
    badgeContainerView.translatesAutoresizingMaskIntoConstraints = false
    cell?.contentView.addSubview(badgeContainerView)
    
    NSLayoutConstraint.activate([
      badgeContainerView.topAnchor.constraint(equalTo: cell!.contentView.topAnchor, constant: 5),
      badgeContainerView.trailingAnchor.constraint(equalTo: cell!.contentView.trailingAnchor, constant: -5),
      badgeContainerView.widthAnchor.constraint(equalToConstant: 20),
      badgeContainerView.heightAnchor.constraint(equalToConstant: 20)
    ])
    
    let badgeImageView = UIImageView(image: UIImage(systemName: "checkmark.circle.fill"))
    badgeImageView.translatesAutoresizingMaskIntoConstraints = false
    badgeImageView.tintColor = .systemGray4
    badgeContainerView.addSubview(badgeImageView)
    badgeImageView.pinToEdges(of: badgeContainerView)
  }
  
  private func openPaletteDetailsVC(for sender: UIGestureRecognizer) {
    guard let color = sender.view?.backgroundColor?.toHex() else { return }
    let paletteDetailsVC = PaletteDetailsVC(colors: [color])
    present(paletteDetailsVC, animated: true)
  }
  
  private func configure() {
    view.backgroundColor = .systemBackground
    title = "Colors"
    navigationController?.navigationBar.tintColor = .label
  }
  
  func configureColorsCollectionView() {
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
  
  func collectionView(_ collectionView: UICollectionView, didBeginMultipleSelectionInteractionAt indexPath: IndexPath) {
    selectedColors.append(colors[indexPath.row])
    collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredVertically)
    let cell = collectionView.cellForItem(at: indexPath)
    cell?.backgroundColor = .black
    collectionView.reloadItems(at: [indexPath])
    print("test")
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
