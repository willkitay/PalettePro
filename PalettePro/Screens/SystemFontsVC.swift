//
//  FontsViewController.swift
//  PalettePro
//
//  Created by Will Kitay on 5/28/23.
//

import UIKit

class SystemFontsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.addSubview(tableView)
    tableView.frame = view.bounds
    tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
  }
  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nil, bundle: nil)
    title = "System Fonts"
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  lazy var rows: [UITableViewCell] = [
    createCell(name: ".largeTitle",  font: .preferredFont(forTextStyle: .largeTitle)),
    createCell(name: ".title1",      font: .preferredFont(forTextStyle: .title1)),
    createCell(name: ".title2",      font: .preferredFont(forTextStyle: .title2)),
    createCell(name: ".title3",      font: .preferredFont(forTextStyle: .title3)),
    createCell(name: ".headline",    font: .preferredFont(forTextStyle: .headline)),
    createCell(name: ".body",        font: .preferredFont(forTextStyle: .body)),
    createCell(name: ".callout",     font: .preferredFont(forTextStyle: .callout)),
    createCell(name: ".subheadline", font: .preferredFont(forTextStyle: .subheadline)),
    createCell(name: ".footnote",    font: .preferredFont(forTextStyle: .footnote)),
    createCell(name: ".caption1",    font: .preferredFont(forTextStyle: .caption1)),
    createCell(name: ".caption2",    font: .preferredFont(forTextStyle: .caption2)),
  ]
    
  private lazy var tableView: UITableView = {
    let table = UITableView()
    table.dataSource = self
    table.delegate = self
    table.allowsSelection = false
    return table
  }()
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    rows.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    rows[indexPath.row]
  }
}

fileprivate func createCell(name: String, font: UIFont) -> UITableViewCell {
  let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
  
  cell.textLabel?.font = font
  cell.textLabel?.text = name
  cell.detailTextLabel?.text = "system size \(Int(font.pointSize))"
  
  return cell
}
