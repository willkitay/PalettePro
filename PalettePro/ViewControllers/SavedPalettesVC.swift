//
//  SavedPalettesVC.swift
//  PalettePro
//
//  Created by Will Kitay on 5/31/23.
//

import UIKit

class SavedPalettesVC: UIViewController, SavedColorPaletteDelegate {
  
  var currentDetailPalette = PaletteDetailsVC(colors: [])
  
  let scrollView = UIScrollView()
  let stackview = UIStackView()
  
  let padding: CGFloat = 10
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    title = "Palettes"
    navigationController?.navigationBar.tintColor = .label
    configure()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    getSavedPalettes()
  }
  
  func getSavedPalettes() {
    PalettePersistenceManager.retrieveFavorites { [weak self] result in
      guard let self else { return }
      switch result {
      case .success(let favorites): updateUI(with: favorites)
      case .failure(let error): print(error.rawValue)
      }
    }
  }
  
  private func updateUI(with savedPalettes: [Palette]) {
    for subview in stackview.subviews { stackview.removeArrangedSubview(subview) }
    
    DispatchQueue.main.async {
      for savedPalette in savedPalettes {
        let palette = SavedColorPalette(frame: .zero)
        let colors = savedPalette.colors.map { UIColor(hex: $0) ?? .clear }
        
        palette.updateColors(colors)
        palette.delegate = self
        self.stackview.addArrangedSubview(palette)
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
  
  private func configure() {
    view.addSubview(scrollView)
    scrollView.translatesAutoresizingMaskIntoConstraints = false
    scrollView.pinToEdges(of: view)
    
    scrollView.addSubview(stackview)
    stackview.axis = .vertical
    stackview.distribution = .fill
    stackview.spacing = padding
    stackview.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      stackview.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: padding),
      stackview.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: padding),
      stackview.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -padding),
      stackview.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: padding * (-2)),
      stackview.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -padding)
    ])
  }
  
}
