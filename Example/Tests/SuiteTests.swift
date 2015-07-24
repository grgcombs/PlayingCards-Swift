//
//  SuiteTests.swift
//  PlayingCards (Swift)
//
//  Created by Gregory Combs on 7/16/15.
//

import UIKit;
import XCTest;
import PlayingCardsSwift;

class SuiteTests: XCTestCase {

    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }

    func testSuiteInstantiates() {
        let suite = Suite(type: SuiteType.Diamonds);
        XCTAssertEqual(suite.name, "Diamonds", "Suite name should be 'Diamonds'");

        XCTAssertEqual(suite.color, UIColor.redColor(), "Suite of diamonds should be red");

        XCTAssertGreaterThan(suite.hashValue, 0, "Suite should have a non-zero hashValue");

        XCTAssertEqual(suite.cards.count, 13, "A suite should always have 13 careds");
    }

    func testSuiteHashCollisions() {
        let suite1 : Suite = Suite(type: SuiteType.Diamonds);
        let suite2 : Suite = Suite(type: SuiteType.Diamonds);

        XCTAssertTrue(suite1 == suite2, "Two instances of the same suite are *equal*");
        XCTAssertEqual(suite1.hashValue, suite2.hashValue, "Two instances of the same suite should have the same hashValue");

        var suites : [Int: Suite] = [:];
        for suiteType in SuiteType.allValues {
            let suite = Suite(type: suiteType);

            XCTAssertNotEqual(suite.hashValue, 0, "Suite \(suite.name) should have a hasValue");

            suites[suite.hashValue] = suite;
        }
        var duplicateSuite = Suite(type: SuiteType.Spades);
        suites[duplicateSuite.hashValue] = duplicateSuite;

        XCTAssertEqual(suites.count, 4, "Should only have should 4 suites");

        let existingSuite : Suite? = suites[suite2.hashValue];
        XCTAssertFalse(isOptionalNil(existingSuite), "Did not find a matching suite in the suite map")
    }

    func testSymbols() {
        let suites : [Suite] = SuiteType.allValues.map({
            Suite(type: $0);
        });

        var previousSymbol : String?;

        for (i,v) in enumerate(suites) {
            let symbol = v.symbol;
            XCTAssertNotEqual(symbol, "", "Suite symbol should not be empty");

            if previousSymbol != nil {
                XCTAssertFalse(previousSymbol == symbol, "Found a duplicate suite symbol");
            }
            previousSymbol = symbol;
        }
    }
}
