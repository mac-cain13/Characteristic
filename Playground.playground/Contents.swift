//: Playground - noun: a place where people can play

import UIKit
import Characteristic

enum Environment: String, CharacteristicType {
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

"\(Environment.Production)"

struct AppConfiguration {
  let environment = Characteristic(Environment.Production)
  let postzegelCode = ToggleCharacteristic(.Enabled)
}

struct App {
  static let config = AppConfiguration()

  //  static let apiService
}

let configurator = Configurator.withItems([
  Configurator.Item(characteristic: App.config.environment, name: "Server"),
  Configurator.Item(characteristic: App.config.postzegelCode, name: "Postzegelcode")
])

if (App.config.postzegelCode) {
  print("postzegelCode")
}

switch App.config.environment.currentValue {
case .Production: print("Prd")
case .Acceptation: print("Acc")
case .Testing: print("Tst")
}
