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
    UITabBar.appearance().tintColor = .label
    
    viewControllers = [createGenerateVC(), createSystem(), createFavoritesVC(), createAIVC()]
    selectedViewController = viewControllers?[0]
  }
  
  func createAIVC() -> UINavigationController {
    let aiVC = SystemVC()
    aiVC.tabBarItem = UITabBarItem(title: "AI", image: UIImage(systemName: "waveform"), tag: 0)
    
    return UINavigationController(rootViewController: aiVC)
  }
  
  func createGenerateVC() -> UINavigationController {
    let generateVC = GenerateVC()
    generateVC.tabBarItem = UITabBarItem(title: "Create", image: UIImage(systemName: "swatchpalette"), tag: 2)
    
    return UINavigationController(rootViewController: generateVC)
  }
  
  func createSystem() -> UINavigationController {
    let systemVC = SystemVC()
    systemVC.tabBarItem = UITabBarItem(title: "System", image: UIImage(systemName: "iphone"), tag: 1)
    
    return UINavigationController(rootViewController: systemVC)
  }
  
  func createFavoritesVC() -> UINavigationController {
    let favoritesVC = SystemVC()
    favoritesVC.tabBarItem = UITabBarItem(title: "Saved", image: UIImage(systemName: "star"), tag: 3)
    
    return UINavigationController(rootViewController: favoritesVC)
  }
}
