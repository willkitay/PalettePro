//
//  PTabBarControllerViewController.swift
//  PalettePro
//
//  Created by Will Kitay on 5/21/23.
//

import UIKit

class PTabBarController: UITabBarController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    UITabBar.appearance().tintColor = .systemGreen
    viewControllers = [createVCOneNC()]
  }
  
  func createVCOneNC() -> UINavigationController {
    let vcOne = GenerateVC()
    vcOne.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 0)
    return UINavigationController(rootViewController: vcOne)
  }
  
//  func createVCTwoNC() -> UINavigationController {
//    let vcTwo = ViewControllerTwo()
//
//    vcTwo.title = "Two"
//    vcTwo.tabBarItem = UITabBarItem(tabBarSystemItem: .history, tag: 0)
//
//    return UINavigationController(rootViewController: vcTwo)
//  }
}
