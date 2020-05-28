//
//  DependenciesUITests.swift
//  DependenciesUITests
//
//  Created by Xaver Lohmüller on 27.05.20.
//  Copyright © 2020 Xaver Lohmüller. All rights reserved.
//

import XCTest

class DependenciesUITests: XCTestCase {
  
  func testLaunchPerformance() throws {
    measure(metrics: [XCTOSSignpostMetric.applicationLaunch]) {
      XCUIApplication().launch()
    }
  }
}
