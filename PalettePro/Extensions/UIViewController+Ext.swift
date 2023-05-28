//
//  UIViewController+Ext.swift
//  PalettePro
//
//  Created by Will Kitay on 5/27/23.
//

import UIKit

extension UIViewController {
  
  func presentCopyAlert() {
    let alertVC = CopyAlert()
    alertVC.modalPresentationStyle = .overFullScreen
    alertVC.modalTransitionStyle = .crossDissolve
    present(alertVC, animated: true)
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
      alertVC.dismiss(animated: true)
    }
  }
  
}
