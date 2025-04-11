/// Copyright (c) 2019 Razeware LLC
/// 
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
/// 
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
/// 
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
/// 
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import XCTest

class StarWarsInfoUITests: XCTestCase {
  func testCharacterList() {
    let app = XCUIApplication()
    app.launchArguments = LaunchArguments.launchLocalArguments
    app.launch()
    
    let table = app.tables[AccessibilityIdentifiers.characterListTable]
    waitForElementToAppear(table, file: #file, line: #line, elementName: "Character List Table", timeout: 5.0)
    
    let identifiers = generateIdentifierList()
    identifiers.forEach { identifier in
      let cell = table.cells[identifier]
      XCTAssertGreaterThan(table.cells.count, 0, "Expected table to have at least 1 cell")

      XCTAssertTrue(cell.exists, "\(identifier) cell should be present")
    }
  }
  
  func testCellDetail() {
    continueAfterFailure = false
    let app = XCUIApplication()
    app.launchArguments = LaunchArguments.launchLocalArguments
    app.launch()
    
    let table = app.tables[AccessibilityIdentifiers.characterListTable]
    waitForElementToAppear(table, file: #file, line: #line, elementName: "Character List Table")

    let identifier = "\(AccessibilityIdentifiers.characterCellPrefix) Luke Skywalker"
    let cell = table.cells[identifier]
    //XCTAssertGreaterThan(table.cells.count, 0, "Expected table to have at least 1 cell")

    XCTAssertTrue(cell.exists, "\(identifier) cell should be present")
      
    cell.tap()
    
    let nameLabel = app.staticTexts[AccessibilityIdentifiers.characterDetailNameLabel]
    XCTAssertEqual(nameLabel.label, "Luke Skywalker", "Name label should match character")
    
    let hairColorLabel = app.staticTexts[AccessibilityIdentifiers.characterDetailHairColorLabel]
    XCTAssertEqual(hairColorLabel.label, "blond", "Hair Color label should match character")
    
    let eyeColorLabel = app.staticTexts[AccessibilityIdentifiers.characterDetailEyeColorLabel]
    XCTAssertEqual(eyeColorLabel.label, "blue", "Eye Color label should match character")
    
    let birthYearLabel = app.staticTexts[AccessibilityIdentifiers.characterDetailBirthYearLabel]
    XCTAssertEqual(birthYearLabel.label, "19BBY", "Name label should match character")
    
    let backButton = app.buttons[AccessibilityLabels.characterDetailBackButton]
    XCTAssertTrue(backButton.exists, "Back button should be present")
    backButton.tap()
    
    waitForElementToAppear(table, file: #file, line: #line, elementName: "Character List Table")
  }

  func generateIdentifierList() -> [String] {
    let names = [
      "Luke Skywalker",
      "C-3PO",
      "R2-D2"
    ]
    
    let identifiers = names.map { name in
      return "\(AccessibilityIdentifiers.characterCellPrefix) \(name)"
    }
    
    return identifiers
  }
  
  func testEmptyCharacterList() {
    let app = XCUIApplication()
    app.launchArguments = LaunchArguments.launchEmptyArguments
    app.launch()

    let label = app.staticTexts["emptyStateLabel"]
    XCTAssertTrue(label.waitForExistence(timeout: 5), "Empty state label should be visible")
  }
  
  func testServerErrorShowAlert() {
    let app = XCUIApplication()
    app.launchArguments = LaunchArguments.launchErrorArguments
    app.launch()

    let alert = app.alerts["Error"]
    let alertExists = alert.waitForExistence(timeout: 5)
    XCTAssertTrue(alertExists, "Error alert should appear within 5 seconds")
    XCTAssertTrue(alert.staticTexts["Failed to load characters."].exists)
  }

  
  func testSlowNetworkShowsLoadingSpinner() {
    let app = XCUIApplication()
    app.launchArguments = LaunchArguments.launchDelayArguments
    app.launch()

    let spinner = app.activityIndicators["In progress"]
    XCTAssertTrue(spinner.exists)
  }

}
