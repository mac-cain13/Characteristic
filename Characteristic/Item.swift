//
//  Item.swift
//  Characteristic
//
//  Created by Mathijs Kadijk on 20-11-15.
//  Copyright © 2015 Mathijs Kadijk. All rights reserved.
//

import Foundation

extension Configurator {

  // MARK: - Item group

  public struct ItemGroup {
    public let name: String?
    public let items: [Item]

    public init(name: String?, items: [Item]) {
      self.name = name
      self.items = items
    }
  }

  // MARK: - Item

  public class Item {
    typealias CharacteristicValueTuple = (title: String, value: Any)

    enum Style {
      case Toggle
      case MultipleChoice
    }

    public let name: String
    let style: Style
    let allValues: [CharacteristicValueTuple]

    private let getBackingValueAsTuple: () -> CharacteristicValueTuple
    private let setBackingValueFromTuple: CharacteristicValueTuple -> ()
    let equalValuesInTuples: (CharacteristicValueTuple, CharacteristicValueTuple) -> Bool

    var currentValue: CharacteristicValueTuple
    var hasChanges: Bool {
      return !equalValuesInTuples(getBackingValueAsTuple(), currentValue)
    }

    public init<CharacteristicValueType>(characteristic: Characteristic<CharacteristicValueType>, name: String) {
      self.name = name
      self.style = characteristic.preferredStyle
      self.allValues = CharacteristicValueType.allValues.map { (titleForCharacteristicType($0), $0.rawValue) }

      self.getBackingValueAsTuple = {
        (titleForCharacteristicType(characteristic.currentValue), characteristic.currentValue.rawValue)
      }
      self.setBackingValueFromTuple = { _, newRawValue in
        guard let newRawValue = newRawValue as? CharacteristicValueType.RawValue,
          newValue = CharacteristicValueType(rawValue: newRawValue)
          else {
            print("[Characteristic/Configurator.Item] FATAL ERROR: Typecast in Item setter failed, this is a bug in the library. Please report this to the maintainer.")
            characteristic.currentValue = characteristic.defaultValue
            return
        }

        characteristic.currentValue = newValue
      }
      self.equalValuesInTuples = { rhs, lhs in
        guard let rhsRawValue = rhs.value as? CharacteristicValueType.RawValue,
          lhsRawValue = lhs.value as? CharacteristicValueType.RawValue,
          rhsValue = CharacteristicValueType(rawValue: rhsRawValue),
          lhsValue = CharacteristicValueType(rawValue: lhsRawValue) else {
          print("[Characteristic/Configurator.Item] FATAL ERROR: Typecast in Item equator failed, this is a bug in the library. Please report this to the maintainer.")
          return false
        }
        return rhsValue == lhsValue
      }

      self.currentValue = getBackingValueAsTuple()
    }

    func applyCurrentValueToBackingValue() {
      if hasChanges {
        setBackingValueFromTuple(currentValue)
      }
    }
  }
}

// MARK: - ItemGroup helper

extension SequenceType where Generator.Element == Configurator.Item {
  public func group(name: String? = nil) -> Configurator.ItemGroup {
    return Configurator.ItemGroup(name: name, items: Array(self))
  }
}
