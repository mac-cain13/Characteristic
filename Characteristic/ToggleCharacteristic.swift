//
//  ToggleCharacteristic.swift
//  Characteristic
//
//  Created by Mathijs Kadijk on 20-11-15.
//  Copyright © 2015 Mathijs Kadijk. All rights reserved.
//

import Foundation

public class ToggleCharacteristic: Characteristic<ToggleState>, BooleanType {
  public var boolValue: Bool {
    return .Enabled == currentValue
  }

  public required init(_ defaultValue: ToggleState) {
    super.init(defaultValue)

    self.preferredStyle = .Toggle
  }
}

public enum ToggleState: Int, CharacteristicType {
  case Enabled = 1
  case Disabled = 0

  public static let allValues: [ToggleState] = [.Enabled, .Disabled]
}
