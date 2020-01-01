import XCTest
@testable import BetterLogger

struct Person {
    let name: String
}

final class BetterLoggerTests: XCTestCase {
	
	var log: BetterLogger { BetterLogger.default }
	
    func testSeverities() {
		log.info("Some info here")
		log.warning("This is a warning", context: ["person": Person(name: "Daniel")])
		log.error("Death note")
		log.fatalError("Death note")
    }

    static var allTests = [
        ("testSeverities", testSeverities),
    ]
}
