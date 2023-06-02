//
//  ColorPersistenceManager.swift
//  PalettePro
//
//  Created by Will Kitay on 5/31/23.
//

import Foundation

enum ColorPersistenceManager {
  
  static private let defaults = UserDefaults.standard
  enum Keys { static let favoriteColors = "favoriteColors" }
  
  static func updateWith(favorite: Color, actionType: PersistenceActionType, completed: @escaping (PersistenceError?) -> Void) {
    retrieveFavorites { result in
      switch result {
      case .success(var favorites):
        switch actionType {
        case .add:
          guard !favorites.contains(favorite) else {
            completed(.alreadyInFavorites)
            return
          }
          favorites.append(favorite)
        case .remove:
          favorites.removeAll { $0.hex == favorite.hex }
        }
        
        completed(save(favorites: favorites))
        
      case .failure(let error):
        completed(error)
      }
    }
  }
  
  static func retrieveFavorites(completed: @escaping (Result<[Color], PersistenceError>) -> Void) {
    guard let favoritesData = defaults.object(forKey: Keys.favoriteColors) as? Data else {
      completed(.success([]))
      return
    }
    
    do {
      let decoder = JSONDecoder()
      let followers = try decoder.decode([Color].self, from: favoritesData)
      completed(.success(followers))
    } catch {
      completed(.failure(.unableToFavorite))
    }
  }
  
  static func save(favorites: [Color]) -> PersistenceError? {
    do {
      let encoder = JSONEncoder()
      let encodedFavorites = try encoder.encode(favorites)
      defaults.set(encodedFavorites, forKey: Keys.favoriteColors)
      return nil
    } catch {
      return .unableToFavorite
    }
  }
}

struct Color: Codable, Hashable {
  let hex: String
}
