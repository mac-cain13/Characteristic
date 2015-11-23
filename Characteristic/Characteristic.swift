//
//  Characteristic.swift
//  Characteristic
//
//  Created by Mathijs Kadijk on 19-11-15.
//  Copyright © 2015 Mathijs Kadijk. All rights reserved.
//

import Foundation

public class Characteristic<ValueType: CharacteristicType> {
  public let defaultValue: ValueType
  public var currentValue: ValueType {
    didSet {
      // TODO: Notification: CharacteristicDidChange
    }
  }

  internal var preferredStyle: Configurator.Item.Style

  public required init(_ defaultValue: ValueType) {
    self.defaultValue = defaultValue
    self.currentValue = defaultValue

    self.preferredStyle = .MultipleChoice
  }
}

public protocol CharacteristicType: RawRepresentable, Equatable {
  static var allValues: [Self] { get }
}

public protocol CustomCharacteristicTitle {
  var characteristicTitle: String { get }
}

func titleForCharacteristicType<Type: CharacteristicType>(characteristicType: Type) -> String {
  if let characteristicType = characteristicType as? CustomCharacteristicTitle {
    return characteristicType.characteristicTitle
  }

  return "\(characteristicType)"
}
