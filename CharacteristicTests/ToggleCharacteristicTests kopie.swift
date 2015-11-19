//
//  ToggleCharacteristicTests.swift
//  CharacteristicTests
//
//  Created by Mathijs Kadijk on 19-11-15.
//  Copyright © 2015 Mathijs Kadijk. All rights reserved.
//

import XCTest
@testable import Characteristic

class ToggleCharacteristicTests: XCTestCase {

  var characteristic: ToggleCharacteristic!

  override func setUp() {
    super.setUp()

    characteristic = ToggleCharacteristic(ToggleState.Enabled)
  }

  func testInitialization() {
    XCTAssertEqual(ToggleState.Enabled, characteristic.currentValue)
    XCTAssertEqual(ToggleState.Enabled, characteristic.defaultValue)
    XCTAssertEqual(CharacteristicConfigurator.Style.Toggle, characteristic.preferredStyle)

    guard let characteristic = characteristic else {
      XCTFail("characteristic variable is nil")
      return
    }
    
    XCTAssertTrue(characteristic)
  }

  func testMutation() {
    characteristic.currentValue = .Disabled

    XCTAssertEqual(ToggleState.Disabled, characteristic.currentValue)
    XCTAssertEqual(ToggleState.Enabled, characteristic.defaultValue)
  }
}

class ToggleStateTests: XCTestCase {

  func testAllValues() {
    XCTAssertEqual([ToggleState.Enabled, ToggleState.Disabled], ToggleState.allValues)
  }

  func testCharacteristicTitle() {
    XCTAssertEqual(ToggleState.Enabled.characteristicTitle, "Enabled")
    XCTAssertEqual(ToggleState.Disabled.characteristicTitle, "Disabled")
  }

}
