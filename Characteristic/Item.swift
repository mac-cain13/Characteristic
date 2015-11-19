//
//  Item.swift
//  Characteristic
//
//  Created by Mathijs Kadijk on 20-11-15.
//  Copyright © 2015 Mathijs Kadijk. All rights reserved.
//

import Foundation

extension Configurator {
  public struct ItemGroup {
    public let name: String?
    public let items: [Item]
  }

  public class Item {
    typealias CharacteristicValueTuple = (title: String, value: Any)

    enum Style {
      case Toggle
      case MultipleChoice
    }

    public let name: String
    let style: Style
    let allValues: [CharacteristicValueTuple]

    private let getter: () -> CharacteristicValueTuple
    private let setter: CharacteristicValueTuple -> ()
    let equator: (CharacteristicValueTuple, CharacteristicValueTuple) -> Bool

    var value: CharacteristicValueTuple {
      didSet {
        hasChanged = true
      }
    }
    var hasChanged: Bool = false

    public init<CharacteristicValueType>(characteristic: Characteristic<CharacteristicValueType>, name: String) {
      self.name = name
      self.style = characteristic.preferredStyle
      self.allValues = CharacteristicValueType.allValues.map { (titleForCharacteristicType($0), $0.rawValue) }

      self.getter = {
        (titleForCharacteristicType(characteristic.currentValue), characteristic.currentValue.rawValue)
      }
      self.setter = { _, newRawValue in
        guard let newRawValue = newRawValue as? CharacteristicValueType.RawValue,
          newValue = CharacteristicValueType(rawValue: newRawValue)
          else {
            print("[Characteristic/Configurator.Item] FATAL ERROR: Typecast in Item setter failed, this is a bug in the library. Please report this to the maintainer.")
            characteristic.currentValue = characteristic.defaultValue
            return
        }

        characteristic.currentValue = newValue
      }
      self.equator = { rhs, lhs in
        guard let rhsRawValue = rhs.value as? CharacteristicValueType.RawValue,
          lhsRawValue = lhs.value as? CharacteristicValueType.RawValue,
          rhsValue = CharacteristicValueType(rawValue: rhsRawValue),
          lhsValue = CharacteristicValueType(rawValue: lhsRawValue) else {
          print("[Characteristic/Configurator.Item] FATAL ERROR: Typecast in Item equator failed, this is a bug in the library. Please report this to the maintainer.")
          return false
        }
        return rhsValue == lhsValue
      }

      self.value = getter()
    }

    func resetValue() {
      value = getter()
    }

    func applyValue() {
      if hasChanged {
        setter(value)
        hasChanged = false
      }
    }
  }
}
