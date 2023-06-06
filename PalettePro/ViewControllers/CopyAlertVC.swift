//
//  CopyAlert.swift
//  PalettePro
//
//  Created by Will Kitay on 5/27/23.
//

import UIKit

import UIKit

class CopyAlertVC: UIViewController {
  
  private let backgroundView = UIView()
  private let actionButton = UIButton()
  
  private let buttonWidth: CGFloat = 150
  private let buttonHeight: CGFloat = 60
  
  init() {
    super.init(nibName: nil, bundle: nil)
    modalPresentationStyle = .overCurrentContext
    modalTransitionStyle = .crossDissolve
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupBackgroundView()
    setupActionButton()
  }
  
  private func setupBackgroundView() {
    backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
    backgroundView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(backgroundView)
    
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissVC))
    backgroundView.addGestureRecognizer(tapGesture)
    
    NSLayoutConstraint.activate([
      backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
      backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    ])
  }
  
  private func setupActionButton() {
    actionButton.setImage(.init(systemName: "doc.on.doc"), for: .normal)
    actionButton.tintColor = .black
    actionButton.setTitle("  Copied!", for: .normal)
    actionButton.backgroundColor = .white
    actionButton.setTitleColor(.black, for: .normal)
    actionButton.titleLabel?.font = .preferredFont(forTextStyle: .subheadline)
    actionButton.layer.cornerRadius = 10
    actionButton.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(actionButton)
    
    actionButton.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
    
    NSLayoutConstraint.activate([
      actionButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      actionButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
      actionButton.widthAnchor.constraint(equalToConstant: buttonWidth),
      actionButton.heightAnchor.constraint(equalToConstant: buttonHeight)
    ])
  }
  
  @objc private func dismissVC() {
    dismiss(animated: true)
  }
}
