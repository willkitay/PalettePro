//
//  ViewControllerTwo.swift
//  PalettePro
//
//  Created by Will Kitay on 5/21/23.
//

import UIKit

class SystemColorsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
  init() { super.init(nibName: nil, bundle: nil) }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.title = "System Colors"
    configureTableView()
  }
  
  private func configureTableView() {
    view.addSubview(tableView)
    tableView.frame = view.bounds
    tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
  }
  
  private lazy var tableView: UITableView = {
    let table = UITableView()
    table.dataSource = self
    table.delegate = self
    table.allowsSelection = false
    return table
  }()
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    tableSections[section].name
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    tableSections.count
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    tableSections[section].rows.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    tableSections[indexPath.section].rows[indexPath.row]
  }
    
  private lazy var tableSections: [TableSection] = [
    TableSection(name: "Adaptable Colors",          rows: adaptableColors),
    TableSection(name: "Adaptable Grays",           rows: adaptableGrays),
    TableSection(name: "Label Colors",              rows: labelColors),
    TableSection(name: "Text Colors",               rows: textColors),
    TableSection(name: "Link Color",                rows: linkColor),
    TableSection(name: "Separators",                rows: separators),
    TableSection(name: "Fill Colors",               rows: fillColors),
    TableSection(name: "Background Colors",         rows: backgroundColors),
    TableSection(name: "Grouped Background Colors", rows: groupedBackgroundColors),
    TableSection(name: "Non-Adaptable Colors",      rows: nonadaptableColors)
  ]

  private lazy var adaptableColors: [UITableViewCell] = {
    var cells = [UITableViewCell]()
    
    cells.append(createCell(name: ".systemBlue",   backgroundColor: .systemBlue, textColor: getContrastTextColor(for: .systemBlue)))
    cells.append(createCell(name: ".systemBrown",  backgroundColor: .systemBrown, textColor: getContrastTextColor(for: .systemBrown)))
    cells.append(createCell(name: ".systemCyan",   backgroundColor: .systemCyan, textColor: getContrastTextColor(for: .systemCyan)))
    cells.append(createCell(name: ".systemGreen",  backgroundColor: .systemGreen, textColor: getContrastTextColor(for: .systemGreen)))
    cells.append(createCell(name: ".systemIndigo", backgroundColor: .systemIndigo, textColor: getContrastTextColor(for: .systemIndigo)))
    cells.append(createCell(name: ".systemMint",   backgroundColor: .systemMint, textColor: getContrastTextColor(for: .systemMint)))
    cells.append(createCell(name: ".systemOrange", backgroundColor: .systemOrange, textColor: getContrastTextColor(for: .systemOrange)))
    cells.append(createCell(name: ".systemPink",   backgroundColor: .systemPink, textColor: getContrastTextColor(for: .systemPink)))
    cells.append(createCell(name: ".systemPurple", backgroundColor: .systemPurple, textColor: getContrastTextColor(for: .systemPurple)))
    cells.append(createCell(name: ".systemRed",    backgroundColor: .systemRed, textColor: getContrastTextColor(for: .systemRed)))
    cells.append(createCell(name: ".systemTeal",   backgroundColor: .systemTeal, textColor: getContrastTextColor(for: .systemTeal)))
    cells.append(createCell(name: ".systemYellow", backgroundColor: .systemYellow, textColor: getContrastTextColor(for: .systemYellow)))
    
    return cells
  }()
  
  private lazy var adaptableGrays: [UITableViewCell] = {
    var cells = [UITableViewCell]()
    
    cells.append(createCell(name: ".systemGray",  backgroundColor: .systemGray))
    cells.append(createCell(name: ".systemGray2", backgroundColor: .systemGray2))
    cells.append(createCell(name: ".systemGray3", backgroundColor: .systemGray3))
    cells.append(createCell(name: ".systemGray4", backgroundColor: .systemGray4))
    cells.append(createCell(name: ".systemGray5", backgroundColor: .systemGray5))
    cells.append(createCell(name: ".systemGray6", backgroundColor: .systemGray6))
    
    return cells
  }()
  
  private lazy var labelColors: [UITableViewCell] = {
    var cells = [UITableViewCell]()
    
    cells.append(createCell(name: ".label",           textColor: .label))
    cells.append(createCell(name: ".secondaryLabel",  textColor: .secondaryLabel))
    cells.append(createCell(name: ".tertiaryLabel",   textColor: .tertiaryLabel))
    cells.append(createCell(name: ".quaternaryLabel", textColor: .quaternaryLabel))
    
    return cells
  }()

  private lazy var linkColor: [UITableViewCell] = {
    var cells = [UITableViewCell]()
    
    cells.append(createCell(name: ".link", textColor: .link))
    
    return cells
  }()
  

  private lazy var textColors: [UITableViewCell] = {
    var cells = [UITableViewCell]()
    
    cells.append(createCell(name: ".placeholderText", textColor: .placeholderText))
    
    return cells
  }()
  
  private lazy var separators: [UITableViewCell] = {
    var cells = [UITableViewCell]()
    
    cells.append(createCell(name: ".separator",       backgroundColor: .separator))
    cells.append(createCell(name: ".opaqueSeparator", backgroundColor: .opaqueSeparator))
    
    return cells
  }()
  
  private lazy var fillColors: [UITableViewCell] = {
    var cells = [UITableViewCell]()
    
    cells.append(createCell(name: ".systemFill",           backgroundColor: .systemFill))
    cells.append(createCell(name: ".secondarySystemFill",  backgroundColor: .secondarySystemFill))
    cells.append(createCell(name: ".tertiarySystemFill",   backgroundColor: .tertiarySystemFill))
    cells.append(createCell(name: ".quaternarySystemFill", backgroundColor: .quaternarySystemFill))
    
    return cells
  }()
  
  private lazy var backgroundColors: [UITableViewCell] = {
    var cells = [UITableViewCell]()
    
    cells.append(createCell(name: ".systemBackground",          backgroundColor: .systemBackground))
    cells.append(createCell(name: ".secondarySystemBackground", backgroundColor: .secondarySystemBackground))
    cells.append(createCell(name: ".tertiarySystemBackground",  backgroundColor: .tertiarySystemBackground))
    
    return cells
  }()
  
  private lazy var groupedBackgroundColors: [UITableViewCell] = {
    var cells = [UITableViewCell]()
    
    cells.append(createCell(name: ".systemGroupedBackground",          backgroundColor: .systemGroupedBackground))
    cells.append(createCell(name: ".secondarySystemGroupedBackground", backgroundColor: .secondarySystemGroupedBackground))
    cells.append(createCell(name: ".tertiarySystemGroupedBackground",  backgroundColor: .tertiarySystemGroupedBackground))
    
    return cells
  }()
  
  private lazy var nonadaptableColors: [UITableViewCell] = {
    var cells = [UITableViewCell]()
    
    cells.append(createCell(name: ".lightText", backgroundColor: .black, textColor: .lightText))
    cells.append(createCell(name: ".darkText",  backgroundColor: .white, textColor: .darkText))
    
    return cells
  }()

}

// MARK: - Helpers

fileprivate struct TableSection {
  let name: String
  let rows: [UITableViewCell]
}

fileprivate func createCell(name: String, backgroundColor: UIColor? = nil, textColor: UIColor? = nil) -> UITableViewCell {
  let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
  
  if let backgroundColor = backgroundColor { cell.backgroundColor = backgroundColor }
  if let textColor = textColor {
    cell.textLabel?.textColor = textColor
  }
//  else {
//    cell.textLabel?.textColor = getContrastTextColor(for: backgroundColor)
//  }
  cell.textLabel?.text = name

  return cell
}
