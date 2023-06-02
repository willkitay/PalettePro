//
//  SavedVC.swift
//  PalettePro
//
//  Created by Will Kitay on 5/28/23.
//

import UIKit

class SavedVC: UIViewController, SavedColorPaletteDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  
  var currentDetailPalette = PaletteDetailsVC(colors: [])
  var colors: [Color] = []
  
  let paletteStackView = UIStackView()
  let palettesLabel = SectionLabel(title: "Palettes")
  let colorsLabel = SectionLabel(title: "Colors")
  let seeMorePalettes = SeeMoreButton()
  let seeMoreColors = SeeMoreButton()
  let colorsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
  
  private let padding: CGFloat = 10
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configure()
    configurePalettesLabel()
    configurePaletteStackView()
    configureSeeMorePalettes()
    configureColorsLabel()
    configureColorsCollectionView()
    configureSeeMoreColors()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    getSavedPalettes()
    getSavedColors()
    tabBarController?.tabBar.isHidden = false
  }
  
  func getSavedPalettes() {
    PalettePersistenceManager.retrieveFavorites { [weak self] result in
      guard let self else { return }
      switch result {
      case .success(let palettes): updatePaletteStackView(with: palettes)
      case .failure(let error): print(error.rawValue)
      }
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
  
  private func updatePaletteStackView(with savedPalettes: [Palette]) {
    for subview in paletteStackView.subviews { paletteStackView.removeArrangedSubview(subview) }
    
    DispatchQueue.main.async {
      for savedPalette in savedPalettes.prefix(4) {
        let palette = SavedColorPalette(frame: .zero)
        let colors = savedPalette.colors.map { UIColor(hex: $0) ?? .clear }
        
        palette.updateColors(colors)
        palette.delegate = self
        self.paletteStackView.addArrangedSubview(palette)
      }
    }
  }
  
  func presentPaletteDetailsVC(colors: [String]) {
    guard let selectedColor = UIColor(hex: colors[0]) else { return }
    
    currentDetailPalette.colors = colors
    currentDetailPalette.selectColor(selectedColor)
    currentDetailPalette.tabBar.setTabBarColors(colors)
    present(currentDetailPalette, animated: true)
  }
  
  @objc func presentSeeMorePalettesVC(_ sender: UIButton) {
    let savedPalettesVC = SavedPalettesVC()
    navigationController?.pushViewController(savedPalettesVC, animated: true)
  }
  
  @objc func presentSeeMoreColorsVC(_ sender: UIButton) {
    let savedColorsVC = SavedColorsVC()
    navigationController?.pushViewController(savedColorsVC, animated: true)
  }
  
  @objc func tapColor(_ sender: UIGestureRecognizer) {
    guard let color = sender.view?.backgroundColor?.toHex() else { return }
    let paletteDetailsVC = PaletteDetailsVC(colors: [color])
    present(paletteDetailsVC, animated: true)
  }
  
  func configure() {
    view.backgroundColor = .systemBackground
    navigationController?.navigationBar.prefersLargeTitles = false
    title = "Favorites"
    //    setEmptyBackgroundImage(Images.emptyBox)
  }
  
  func configurePalettesLabel() {
    view.addSubview(palettesLabel)
    palettesLabel.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      palettesLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: padding),
      palettesLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
      palettesLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
    ])
  }
  
  func configurePaletteStackView() {
    view.addSubview(paletteStackView)
    
    paletteStackView.axis = .vertical
    paletteStackView.distribution = .fill
    paletteStackView.spacing = padding
    paletteStackView.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      paletteStackView.topAnchor.constraint(equalTo: palettesLabel.bottomAnchor, constant: padding),
      paletteStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
      paletteStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
    ])
  }
  
  func configureSeeMorePalettes() {
    view.addSubview(seeMorePalettes)
    seeMorePalettes.addTarget(self, action: #selector(presentSeeMorePalettesVC), for: .touchUpInside)
    
    
    NSLayoutConstraint.activate([
      seeMorePalettes.topAnchor.constraint(equalTo: paletteStackView.bottomAnchor, constant: padding),
      seeMorePalettes.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
      seeMorePalettes.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
    ])
  }
  
  func configureColorsLabel() {
    view.addSubview(colorsLabel)
    colorsLabel.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      colorsLabel.topAnchor.constraint(equalTo: seeMorePalettes.bottomAnchor, constant: padding),
      colorsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
      colorsLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
    ])
  }
  
  func configureColorsCollectionView() {
    view.addSubview(colorsCollectionView)
    
    colorsCollectionView.translatesAutoresizingMaskIntoConstraints = false
    colorsCollectionView.dataSource = self
    colorsCollectionView.isScrollEnabled = false
    colorsCollectionView.delegate = self
    colorsCollectionView.backgroundColor = .systemBackground
    colorsCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "ColorCell")
    
    let layout = UICollectionViewFlowLayout()
    layout.minimumInteritemSpacing = padding
    layout.minimumLineSpacing = padding
    layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    layout.scrollDirection = .vertical
    colorsCollectionView.collectionViewLayout = layout
    
    NSLayoutConstraint.activate([
      colorsCollectionView.topAnchor.constraint(equalTo: colorsLabel.bottomAnchor, constant: padding),
      colorsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
      colorsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
      colorsCollectionView.heightAnchor.constraint(equalToConstant: 210)
      
    ])
  }
  
  func configureSeeMoreColors() {
    view.addSubview(seeMoreColors)
    
    seeMoreColors.addTarget(self, action: #selector(presentSeeMoreColorsVC), for: .touchUpInside)
    
    NSLayoutConstraint.activate([
      seeMoreColors.topAnchor.constraint(equalTo: colorsCollectionView.bottomAnchor, constant: padding),
      seeMoreColors.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
      seeMoreColors.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
    ])
  }
}

extension SavedVC {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return min(colors.count, 15)
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
