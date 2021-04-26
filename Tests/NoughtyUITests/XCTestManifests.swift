import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(noughty_ui_lib_swiftTests.allTests),
    ]
}
#endif
