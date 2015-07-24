//
//  SuitTests.swift
//  PlayingCards (Swift)
//
//  Created by Gregory Combs on 7/16/15.
//

import UIKit;
import XCTest;
import PlayingCardsSwift;

class SuitTests: XCTestCase {

    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }

    func testSuitInstantiates() {
        let suit = Suit(type: SuitType.Diamonds);
        XCTAssertEqual(suit.name, "Diamonds", "Suit name should be 'Diamonds'");

        XCTAssertEqual(suit.color, UIColor.redColor(), "Suit of diamonds should be red");

        XCTAssertGreaterThan(suit.hashValue, 0, "Suit should have a non-zero hashValue");

        XCTAssertEqual(suit.cards.count, 13, "A suit should always have 13 careds");
    }

    func testSuitHashCollisions() {
        let suite1 : Suit = Suit(type: SuitType.Diamonds);
        let suite2 : Suit = Suit(type: SuitType.Diamonds);

        XCTAssertTrue(suite1 == suite2, "Two instances of the same suit are *equal*");
        XCTAssertEqual(suite1.hashValue, suite2.hashValue, "Two instances of the same suit should have the same hashValue");

        var suites : [Int: Suit] = [:];
        for suiteType in SuitType.allValues {
            let suit = Suit(type: suiteType);

            XCTAssertNotEqual(suit.hashValue, 0, "Suit \(suit.name) should have a hasValue");

            suites[suit.hashValue] = suit;
        }
        var duplicateSuit = Suit(type: SuitType.Spades);
        suites[duplicateSuit.hashValue] = duplicateSuit;

        XCTAssertEqual(suites.count, 4, "Should only have should 4 suites");

        let existingSuit : Suit? = suites[suite2.hashValue];
        XCTAssertFalse(isOptionalNil(existingSuit), "Did not find a matching suit in the suit map")
    }

    func testSymbols() {
        let suites : [Suit] = SuitType.allValues.map({
            Suit(type: $0);
        });

        var previousSymbol : String?;

        for (i,v) in enumerate(suites) {
            let symbol = v.symbol;
            XCTAssertNotEqual(symbol, "", "Suit symbol should not be empty");

            if previousSymbol != nil {
                XCTAssertFalse(previousSymbol == symbol, "Found a duplicate suit symbol");
            }
            previousSymbol = symbol;
        }
    }
}
