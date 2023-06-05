//
//  UIViewController+Ext.swift
//  PalettePro
//
//  Created by Will Kitay on 5/27/23.
//

import UIKit

extension UIViewController {
  
  func presentCopyAlert() {
    let alertVC = CopyAlertVC()
    alertVC.modalPresentationStyle = .overFullScreen
    alertVC.modalTransitionStyle = .crossDissolve
    present(alertVC, animated: true)
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
      alertVC.dismiss(animated: true)
    }
  }
  
  func deleteAlert(deleteAction: UIAlertAction, forTitle title: String) {
    let alertController = UIAlertController(title: "Delete \(title)", message: "Are you sure you want to delete this \(title.lowercased())?", preferredStyle: .actionSheet)
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)

    alertController.addAction(cancelAction)
    alertController.addAction(deleteAction)
    
    present(alertController, animated: true)
  }
  
  func setEmptyBackgroundImage(_ image: UIImage?, backgroundImageView: UIImageView) {
    backgroundImageView.contentMode = .scaleAspectFit
    backgroundImageView.image = image
    self.view.insertSubview(backgroundImageView, at: 0)
    backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
    backgroundImageView.isHidden = false
    
    let padding: CGFloat = 60
    NSLayoutConstraint.activate([
      backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: padding),
      backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding-10),
      backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
      backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -padding)
    ])
  }
  
}
