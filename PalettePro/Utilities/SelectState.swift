//
//  SelectState.swift
//  PalettePro
//
//  Created by Will Kitay on 6/2/23.
//

enum SelectState: String {
  case select, cancel
  
  var string: String {
    switch self {
    case .select: return "Select    "
    case .cancel: return "Cancel    "
    }
  }
}
