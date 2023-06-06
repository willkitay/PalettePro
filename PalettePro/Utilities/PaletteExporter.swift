//
//  PaletteExporter.swift
//  PalettePro
//
//  Created by Will Kitay on 5/25/23.
//

import UIKit

class PaletteExporter {
  
  static func exportPalette(colorsToExport: [String], from viewController: UIViewController) {
    do {
      let paletteDictionary: [String: Any] = ["colors": colorsToExport]
      let jsonData = try JSONSerialization.data(withJSONObject: paletteDictionary, options: [.prettyPrinted])
      let tempDirectoryURL = URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true)
      let fileURL = tempDirectoryURL.appendingPathComponent("PalettePro.json")
      try jsonData.write(to: fileURL)
      let activityViewController = UIActivityViewController(activityItems: [fileURL], applicationActivities: nil)
      
      viewController.present(activityViewController, animated: true)
    } catch {
      print("Failed to export the palette as JSON: \(error)")
    }
  }
  
}
