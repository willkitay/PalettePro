//
//  FullPaletteViewerVC.swift
//  PalettePro
//
//  Created by Will Kitay on 5/25/23.
//

import UIKit

class PaletteDetailsVC: UIViewController, PaletteTabBarDelegate, ColorComboDelegate {
  
  var colors: [String] = []
  
  private let containerView = UIView()
  private let scrollView = UIScrollView()
  private let stackView = UIStackView()
  private let bottomBar = UIView()
  
  let tabBar = PaletteTabBar()
  
  private let complementaryCombo = ColorCombo(title: "complementary colors")
  private let analogousCombo = ColorCombo(title: "analogous colors")
  private let triadicCombo = ColorCombo(title: "triadic colors")
  private let tetradicCombo = ColorCombo(title: "tetradic colors")
  
  private var hexCodeRow = ColorCode(title: "hex")
  private var rgbCodeRow = ColorCode(title: "rgb")
  private var hsbaCodeRow = ColorCode(title: "hsb")
  private var cmykCodeRow = ColorCode(title: "cmyk")
  private var hslCodeRow = ColorCode(title: "hsl")
  
  private var colorCodes: [ColorCode] = []
  private var colorCombos: [ColorCombo] = []
  
  private var currentColor: UIColor = .white
  
  init(colors: [String]) {
    super.init(nibName: nil, bundle: nil)
    self.colors = colors
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    guard let defaultColor = UIColor(hex: colors.first ?? "") else { return }
    view.backgroundColor = defaultColor
    navigationController?.navigationBar.prefersLargeTitles = false
    title = colors.count > 1 ? "Palette Details" : "Color Details"
    
    configureColorCodeRows()
    configureColorCombos()
    configureContainerView()
    configureBottomBar()
    configureScrollView()
    configureStackView()
    configureTabBar()
    
    selectColor(defaultColor)
  }
  
  func selectColor(_ color: UIColor?) {
    guard let color else { return }
    
    currentColor = color
    containerView.backgroundColor = color
    updateColorCodeRows()
    updateColorComboDetails()
  }
  
  private func configureColorCombos() {
    colorCombos = [complementaryCombo, analogousCombo, triadicCombo, tetradicCombo]
    
    for combo in colorCombos { combo.delegate = self }
  }
  
  private func configureColorCodeRows() {
    colorCodes = [hexCodeRow, rgbCodeRow, hsbaCodeRow, cmykCodeRow, hslCodeRow]
    
    for row in colorCodes {
      row.addTarget(self, action: #selector(copyColorCode), for: .touchUpInside)
    }
  }
  
  func copyColorComboCode() {
    presentCopyAlert()
  }
  
  @objc private func copyColorCode(_ sender: UIButton) {
    guard let colorCode = sender.subtitleLabel?.text else { return }
    UIPasteboard.general.string = colorCode
    presentCopyAlert()
  }
  
  private func updateColorCodeRows() {
    for row in colorCodes { row.updateColor(currentColor) }
    
    updateHEXCode()
    updateRGBCode()
    updateHSBCode()
    updateCMYKCode()
    updateHSLCode()
  }
  
  private func updateHEXCode() {
    let hexBody = currentColor.toHex().replacingOccurrences(of: "#", with: "")
    hexCodeRow.body = hexBody
  }
  
  private func updateRGBCode() {
    let multiplier: CGFloat = 255
    let rgbBody = "\(Int(currentColor.redValue * multiplier)), \(Int(currentColor.greenValue * multiplier)), \(Int(currentColor.blueValue * multiplier))"
    rgbCodeRow.body = rgbBody
  }
  
  private func updateHSBCode() {
    let multiplier: CGFloat = 100
    let hsba = currentColor.toHSB()
    let hsbaBody = "\(Int(hsba.h * 360)), \(Int(hsba.s * multiplier)), \(Int(hsba.b * multiplier))"
    hsbaCodeRow.body = hsbaBody
  }
  
  private func updateCMYKCode() {
    let cmyk = hexToCMYK(hexCode: currentColor.toHex())
    let cmykBody = "\(Int(cmyk?.c ?? 0)), \(Int(cmyk?.m ?? 0)), \(Int(cmyk?.y ?? 0)), \(Int(cmyk?.k ?? 0))"
    cmykCodeRow.body = cmykBody
  }
  
  private func updateHSLCode() {
    let hsl = colorToHSL(currentColor)
    let hslBody = "\(hsl.h), \(hsl.s), \(hsl.l)"
    hslCodeRow.body = hslBody
  }
  
  private func updateColorComboDetails() {
    for combo in colorCombos { combo.background = currentColor }
    
    updateComplementaryCombo()
    updateAnalogousCombo()
    updateTriadicCombo()
    updateTetradicCombo()
  }
  
  private func updateComplementaryCombo() {
    let complementaryColors = [currentColor.splitComplement0, currentColor.splitComplement1]
    complementaryCombo.set(colors: complementaryColors)
  }
  
  private func updateAnalogousCombo() {
    let analogousColors = [currentColor.darker(by: -20) ?? .clear, currentColor.lighter(by: 20) ?? .clear]
    analogousCombo.set(colors: analogousColors)
  }
  
  private func updateTriadicCombo() {
    triadicCombo.set(colors: [currentColor.triadic0, currentColor.triadic1])
  }
  
  private func updateTetradicCombo() {
    tetradicCombo.set(colors: [currentColor.triadic0, currentColor.tetradic1, currentColor.tetradic2])
  }
  
  private func configureContainerView() {
    view.addSubview(containerView)
    containerView.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      containerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    ])
  }
  
  func configureBottomBar() {
    containerView.addSubview(bottomBar)
    bottomBar.backgroundColor = .systemBackground
    bottomBar.translatesAutoresizingMaskIntoConstraints = false

    let bottomBarHeight: CGFloat = colors.count > 1 ? 90 : 0
    NSLayoutConstraint.activate([
      bottomBar.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
      bottomBar.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
      bottomBar.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
      bottomBar.heightAnchor.constraint(equalToConstant: bottomBarHeight),
    ])
  }
  
  private func configureScrollView() {
    containerView.addSubview(scrollView)
    scrollView.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      scrollView.topAnchor.constraint(equalTo: containerView.topAnchor),
      scrollView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
      scrollView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
      scrollView.bottomAnchor.constraint(equalTo: bottomBar.topAnchor),
    ])
  }
  
  func configureTabBar() {
    guard colors.count > 1 else { return }
    containerView.addSubview(tabBar)
    tabBar.delegate = self
    tabBar.setTabBarColors(colors)

    NSLayoutConstraint.activate([
      tabBar.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
      tabBar.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
      tabBar.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -35),
      tabBar.heightAnchor.constraint(equalToConstant: 45)
    ])
  }
  
  private func configureStackView() {
    scrollView.addSubview(stackView)
    stackView.axis = .vertical
    stackView.translatesAutoresizingMaskIntoConstraints = false
    
    for row in colorCodes { stackView.addArrangedSubview(row) }
    for combo in colorCombos { stackView.addArrangedSubview(combo) }
    
    NSLayoutConstraint.activate([
      stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 10),
      stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 10),
      stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -10),
      stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -20),
      stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -20)
    ])
  }
}

