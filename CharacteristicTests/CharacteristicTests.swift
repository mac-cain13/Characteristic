//
//  CharacteristicTests.swift
//  CharacteristicTests
//
//  Created by Mathijs Kadijk on 19-11-15.
//  Copyright © 2015 Mathijs Kadijk. All rights reserved.
//

import XCTest
@testable import Characteristic

class CharacteristicTests: XCTestCase {

  var characteristic: Characteristic<ToggleState>!

  override func setUp() {
    super.setUp()

    characteristic = Characteristic(.Enabled)
  }

  func testInitialization() {
    XCTAssertEqual(ToggleState.Enabled, characteristic.currentValue)
    XCTAssertEqual(ToggleState.Enabled, characteristic.defaultValue)
    XCTAssertEqual(Configurator.Item.Style.MultipleChoice, characteristic.preferredStyle)
  }

  func testMutation() {
    characteristic.currentValue = .Disabled

    XCTAssertEqual(ToggleState.Disabled, characteristic.currentValue)
    XCTAssertEqual(ToggleState.Enabled, characteristic.defaultValue)
  }
}
