//
//  PersistenceManager.swift
//  PalettePro
//
//  Created by Will Kitay on 5/30/23.
//

import Foundation

enum PersistenceActionType {
  case add, remove
}

enum PalettePersistenceManager {
  
  static private let defaults = UserDefaults.standard
  enum Keys { static let favoritePalettes = "favoritePalettes" }
  
  static func updateWith(favorite: Palette, actionType: PersistenceActionType, completed: @escaping (PersistenceError?) -> Void) {
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
          favorites.removeAll { $0.colors == favorite.colors }
        }
        
        completed(save(favorites: favorites))
        
      case .failure(let error):
        completed(error)
      }
    }
  }
  
  static func retrieveFavorites(completed: @escaping (Result<[Palette], PersistenceError>) -> Void) {
    guard let favoritesData = defaults.object(forKey: Keys.favoritePalettes) as? Data else {
      completed(.success([]))
      return
    }
    
    do {
      let decoder = JSONDecoder()
      let followers = try decoder.decode([Palette].self, from: favoritesData)
      completed(.success(followers))
    } catch {
      completed(.failure(.unableToFavorite))
    }
  }
  
  static func save(favorites: [Palette]) -> PersistenceError? {
    do {
      let encoder = JSONEncoder()
      let encodedFavorites = try encoder.encode(favorites)
      defaults.set(encodedFavorites, forKey: Keys.favoritePalettes)
      return nil
    } catch {
      return .unableToFavorite
    }
  }
}

struct Palette: Codable, Hashable {
  let colors: [String]
}

enum PersistenceError: String, Error {
  case unableToFavorite   = "There was an error favoriting this user. Please try again."
  case alreadyInFavorites = "You've already favorited this user. You must really like them!"
}
