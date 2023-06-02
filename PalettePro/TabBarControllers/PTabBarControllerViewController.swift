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
    
    viewControllers = [createGenerateVC(),
                       createSavedVC(),
                       createSystemColorsVC(),
                       createSystemFontsVC()]
    selectedViewController = viewControllers?[0]
  }
  
  func createGenerateVC() -> UINavigationController {
    let generateVC = GenerateVC()
    generateVC.tabBarItem = UITabBarItem(title: "Create", image: Symbols.swatchpalette, tag: 2)
    return UINavigationController(rootViewController: generateVC)
  }
  
  func createSystemColorsVC() -> UINavigationController {
    let systemVC = SystemColorsVC()
    systemVC.tabBarItem = UITabBarItem(title: "Colors", image: Symbols.eyedropper, tag: 1)
    return UINavigationController(rootViewController: systemVC)
  }
  
  func createSystemFontsVC() -> UINavigationController {
    let systemVC = SystemFontsVC()
    systemVC.tabBarItem = UITabBarItem(title: "Fonts", image: Symbols.textformatSize, tag: 1)
    return UINavigationController(rootViewController: systemVC)
  }
  
  func createSavedVC() -> UINavigationController {
    let savedVC = SavedVC()
    savedVC.tabBarItem = UITabBarItem(title: "Favorites", image: Symbols.heart, tag: 3)
    return UINavigationController(rootViewController: savedVC)
  }
  
  func createAIVC() -> UINavigationController {
    let aiVC = AIVC()
    aiVC.tabBarItem = UITabBarItem(title: "AI", image: Symbols.waveform, tag: 0)
    return UINavigationController(rootViewController: aiVC)
  }
  
}
