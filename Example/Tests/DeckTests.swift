//
//  DeckTests.swift
//  Example
//
//  Created by Gregory Combs on 7/1/15.
//  Copyright (c) 2015 PlayingCards (Swift). All rights reserved.
//

import UIKit;
import XCTest;
import PlayingCardsSwift;

class DeckTests: XCTestCase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testDeckInstantiates() {
        let deck = Deck();
        XCTAssertNotNil(deck, "Deck should instantiate");

        let suites = deck.suites;
        XCTAssertEqual(suites.count, 4, "Deck should have 4 suites");

        let unshuffledCards = deck.cards();
        XCTAssertEqual(deck.cardCount, 52, "Deck should advertise that it has 52 cards");
        XCTAssertEqual(unshuffledCards.count, 52, "Deck should have 52 cards");

        XCTAssertFalse(deck.isShuffled(), "A fresh deck should not be shuffled");
    }

    func testDeckRandomShuffle() {
        func cardArraysAreEqual(deckCards1:[Card], deckCards2: [Card]) -> Bool {
            let fastEqual = deckCards1 == deckCards2;

            var contentsEqual = true;
            for (var i = 0; (i < deckCards1.count && i < deckCards2.count); i++) {
                let card1 = deckCards1[i];
                let card2 = deckCards2[i];
                if (card1.hashValue != card2.hashValue ||
                    card1 != card2)
                {
                    contentsEqual = false;
                    break;
                }
            }

            XCTAssertTrue(fastEqual == contentsEqual, "The simple '==' comparison should have the same result as a comparison of all the card hashes");

            return contentsEqual;
        }

        let deck = Deck();

        let unshuffledCards = deck.cards();
        XCTAssertFalse(deck.isShuffled(), "A fresh deck should be unshuffled");

        deck.randomShuffle();
        XCTAssertTrue(deck.isShuffled(), "Deck should be shuffled after a randomShuffle()");

        let shuffledCards = deck.cards();
        XCTAssertEqual(shuffledCards.count, 52, "The shuffled deck should still have 52 cards");

        let isEqual = cardArraysAreEqual(shuffledCards, unshuffledCards);
        XCTAssertFalse(cardArraysAreEqual(shuffledCards, unshuffledCards), "Shuffled deck should not be the same as a fresh deck");
    }

    /*
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }
    */
}

