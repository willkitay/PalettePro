//
//  Functions.swift
//  PalettePro
//
//  Created by Will Kitay on 5/21/23.
//

import UIKit

func getContrastTextColor(for backgroundColor: UIColor?) -> UIColor {
  return backgroundColor?.contrastRatio(with: .white) ?? 0 > 3 ? .white : .black
}
