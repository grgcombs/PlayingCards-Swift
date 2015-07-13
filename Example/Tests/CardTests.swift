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

    func testForcedCardHashCollisions() {
        let card1 : Card = Card(suite: SuiteType.Diamonds, type: CardType.Jack);
        let card2 : Card = Card(suite: SuiteType.Diamonds, type: CardType.Jack);

        XCTAssertTrue(card1 == card2, "Two instances of the same card are *equal*");

        XCTAssertEqual(card1.hashValue, card2.hashValue, "Two instances of the same card should have the same hashValue");

        var hashes : [Int : Card] = [:];
        hashes[card1.hashValue] = card1;

        let existingCard : Card? = hashes[card2.hashValue];
        if existingCard == nil {
            XCTFail("Did not find a matching card in the hash map");
        }
        XCTAssertTrue(card1 == existingCard, "The cards should be equal");
    }

    func testCardHashCollisions() {
        let deck = Deck();
        let cards = deck.cards();
        XCTAssertEqual(cards.count, 52, "A deck should have 52 cards");

        var hashes : [Int : Card] = [:];

        for card in cards {
            let hash = card.hashValue;

            if let existingCard = hashes[hash] {
                XCTFail("Found a hash collision between \(card.description) and \(existingCard.description)");
                break;
            }
            hashes[hash] = card;
        }
    }
}
