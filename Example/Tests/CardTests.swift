//
//  CardTests
//  PlayingCards (Swift)
//
//  Created by Gregory Combs on 6/30/15.
//

import UIKit
import XCTest
import PlayingCardsSwift;

class CardTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }

    func testCardInstantiates() {
        let card = Card(suite: SuiteType.Spades, type: CardType.Ace);
        XCTAssertEqual(card.name, "Ace", "Card name should be 'Ace'");

        XCTAssertEqual(card.description, "Ace of Spades", "Card should be an Ace of Spades");

        XCTAssertGreaterThan(card.hashValue, 0, "Card should have a non-zero hashValue");
    }

    func testCardHashCollisions() {
        let card1 : Card = Card(suite: SuiteType.Spades, type: CardType.Jack);
        let card2 : Card = Card(suite: SuiteType.Spades, type: CardType.Jack);

        XCTAssertTrue(card1 == card2, "Two instances of the same card are *equal*");
        XCTAssertEqual(card1.hashValue, card2.hashValue, "Two instances of the same card should have the same hashValue");

        var cards : [Int: Card] = [:];
        for cardType in CardType.allValues {
            let card = Card(suite: SuiteType.Spades, type: cardType);

            XCTAssertNotEqual(card.hashValue, 0, "Card \(card.description) should have a hashValue");

            cards[card.hashValue] = card;
        }
        let duplicateCard = Card(suite: SuiteType.Spades, type: CardType.Ace);
        cards[duplicateCard.hashValue] = duplicateCard;

        XCTAssertEqual(cards.count, 13, "Should only have should 13 cards in a suite");

        let existingCard : Card? = cards[card2.hashValue];
        XCTAssertFalse(isOptionalNil(existingCard), "Did not find a matching card in the suite map")

        let remainingSuiteTypes = [SuiteType.Clubs, SuiteType.Diamonds, SuiteType.Hearts];

        for suiteType in remainingSuiteTypes {
            for cardType in CardType.allValues {
                let card = Card(suite: suiteType, type: cardType);

                XCTAssertNotEqual(card.hashValue, 0, "Card \(card.name) should have a hasValue");

                cards[card.hashValue] = card;
            }
        }
        XCTAssertEqual(cards.count, 52, "Should have exactly 52 cards across all 4 suites");
    }

    func testCardsHaveGlyphs() {
        for (sIndex : Int, suite : SuiteType) in enumerate(SuiteType.allValues) {
            for (cIndex : Int, type : CardType) in enumerate(CardType.allValues) {
                let card = Card(suite: suite, type: type);
                let glyph = card.glyph;
                XCTAssertNotEqual(glyph, "", "Should have a non-empty glyph string for card: \(card)");
            }
        }
    }
}
