//
//  RootVCManager.swift
//  PalettePro
//
//  Created by Will Kitay on 6/4/23.
//

import UIKit

enum RootVCManager {
  
  static let shared = UIApplication.shared.connectedScenes.compactMap { ($0 as? UIWindowScene)?.keyWindow }.last?.rootViewController
    
}
