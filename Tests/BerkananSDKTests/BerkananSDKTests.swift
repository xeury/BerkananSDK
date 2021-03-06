//
// Copyright © 2019-2020 IZE Ltd. and the project authors
// Licensed under MIT License
//
// See LICENSE.md for license information.
//

import XCTest
import CoreBluetooth
@testable import BerkananSDK

final class BerkananSDKTests: XCTestCase {
  
  func testCoreBluetoothInit() {
    let service = BluetoothService.peripheralService
    XCTAssertEqual(CBUUID(string: BluetoothService.UUIDPeripheralServiceString), service.uuid)
    XCTAssertEqual(true, service.isPrimary)
    let messageCharacteristic = BluetoothService.messageCharacteristic
    XCTAssertEqual(CBUUID(string: BluetoothService.UUIDMessageCharacteristicString), messageCharacteristic.uuid)
    XCTAssertEqual([.write], messageCharacteristic.properties)
    XCTAssertEqual(nil, messageCharacteristic.value)
    XCTAssertEqual([.writeable], messageCharacteristic.permissions)
    let value = "Hello, World".data(using: .utf8)!
    let configurationCharacteristic = BluetoothService.configurationCharacteristic(value: value)
    XCTAssertEqual(CBUUID(string: BluetoothService.UUIDConfigurationCharacteristicString), configurationCharacteristic.uuid)
    XCTAssertEqual([.read], configurationCharacteristic.properties)
    XCTAssertEqual(value, configurationCharacteristic.value)
    XCTAssertEqual([.readable], configurationCharacteristic.permissions)
  }
  
  func testMessagePDU() {
    _testMessagePDU(
      with: "Hello, World!",
      expectedData: Data(base64Encoded: "4xLiEtha4zXlTrdH5P63p1R2bOf6JMCvBRSdpnvD7GGN55S91zyNvhx0SjTi9UjNycnXUQjPL8pJUQQA")!
    )
    _testMessagePDU(
      with: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
      expectedData: Data(base64Encoded: "NZA9ThxADIULum1AnOAVVIhsQcEBEJEA0aagdGa8i6X5Y8ZGFNyAFnGTKGlQlDYHiChoOABNlAPgySbdeGw/v/ctdhc7X+7OH17uTy+/v/3c+/Z18Xtne99/Hz88H73enT08/To7/PPjmA6fti5q5wxpwzJiTbVjiIIy6wFCLYODsloHRWkygpQ1OIk3B0dfAIuNXCOUc/NlKUGiRCsKUyT67PJg3UgzMq0LgZJcGy3xScFFsmsjy3zceEn5ANcmA6UO7RbBt9yDKKnUAkuJcqgb5TkkQ+alv5LSfBhMbjy7p7oJ4Kd0iZMpSaYM6eZONlmloHPrfMUlcvfg/nFTkzU/x27Hk4LHYARJ6T8hD2RY2VpIUaYhNOpeWF/i423gpmwTozOoIRAHnwvWJJLODU/RepXIZVKcpPxosNRo5kZdrSQIIfLgPru5pmmDJiBxHOMfV8vLdw==")!
    )
  }
  
  private func _testMessagePDU(with text: String, expectedData: Data) {
    do {
      var message = Message(
        payloadType: UUID(uuidString: "962DD836-E17C-4994-BDD6-4932F4C14261")!
          .protobufValue(),
        payload: text.data(using: .utf8),
        timeToLive: 15
      )
      message.identifier =
        UUID(uuidString: "B57C4A94-DC8B-4859-BFED-CA24B8B70AF2")!
          .protobufValue()
      let data = try message.pdu()
      XCTAssertEqual(data, expectedData)
    } catch {
      XCTFail(error.localizedDescription)
    }
  }
  
  static var allTests = [
    ("testMessagePDU", testMessagePDU),
  ]
}
