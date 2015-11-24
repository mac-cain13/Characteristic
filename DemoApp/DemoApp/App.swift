//
//  App.swift
//  DemoApp
//
//  Created by Mathijs Kadijk on 23-11-15.
//  Copyright © 2015 Mathijs Kadijk. All rights reserved.
//

import Foundation
import Characteristic

struct App {
  static let config = AppConfiguration()

//  static let gravatarService = GravatarService()
}

struct AppConfiguration {
  let env = Characteristic(Environment.Production)
  let bottomMap = ToggleCharacteristic(.Disabled)

  func createConfigurator() -> UIViewController {
    return Configurator.withItemGroups([
      Configurator.ItemGroup(name: "Feature flags", items: [Configurator.Item(characteristic: bottomMap, name: "Bottom map")]),
      Configurator.ItemGroup(name: "Server shizzle", items: [Configurator.Item(characteristic: env, name: "Environment")])
    ])
  }
}

enum Environment: String, CharacteristicType, CustomCharacteristicTitle {
  case Production = "P"
  case Acceptation = "A"
  case Testing = "T"

  static let allValues: [Environment] = [.Production, .Acceptation, .Testing]

  var characteristicTitle: String {
    switch self {
    case .Production: return "Productie"
    case .Acceptation: return "Acceptatie"
    case .Testing: return "Test"
    }
  }
}
