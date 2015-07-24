//
//  DeckTests.swift
//  PlayingCards (Swift)
//
//  Created by Gregory Combs on 7/1/15.
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

        let unshuffledCards = deck.cards;
        XCTAssertEqual(deck.cardCount, 52, "Deck should advertise that it has 52 cards");
        XCTAssertEqual(unshuffledCards.count, 52, "Deck should have 52 cards");

        XCTAssertFalse(deck.isShuffled, "A fresh deck should not be shuffled");
    }

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

    func testDeckRandomShuffle() {
        let deck = Deck();

        let unshuffledCards = deck.cards;
        let unshuffledHash = deck.hashValue;
        XCTAssertFalse(deck.isShuffled, "A fresh deck should be unshuffled");

        deck.randomShuffle();
        XCTAssertTrue(deck.isShuffled, "Deck should be shuffled after a randomShuffle()");

        let shuffledCards = deck.cards;
        let shuffledHash = deck.hashValue;

        XCTAssertEqual(shuffledCards.count, 52, "The shuffled deck should still have 52 cards");

        XCTAssertNotEqual(unshuffledHash, shuffledHash, "Deck is unchanged and after shuffling!");

        let isEqual = cardArraysAreEqual(shuffledCards, deckCards2: unshuffledCards);
        XCTAssertFalse(isEqual, "Shuffled deck should not be the same as a fresh deck");

        XCTAssertTrue(deck.isCompleteAndValidDeck(deck.cards), "Incomplete/invalid deck after shuffle");
    }

    func testDeckHumanShuffleOnce() {
        let deck = Deck();

        let unshuffledCards = deck.cards;
        let unshuffledHash = deck.hashValue;
        XCTAssertFalse(deck.isShuffled, "A fresh deck should be unshuffled");

        deck.humanCutAndShuffle(1, validate: false);
        XCTAssertTrue(deck.isShuffled, "A shuffled deck should be shuffled!");

        let shuffledCards = deck.cards;
        let shuffledHash = deck.hashValue;

        XCTAssertNotEqual(unshuffledHash, shuffledHash, "Deck is unchanged and after shuffling!");

        let isEqual = cardArraysAreEqual(shuffledCards, deckCards2: unshuffledCards);
        XCTAssertFalse(isEqual, "Shuffled deck should not be the same as a fresh deck");

        XCTAssertTrue(deck.isCompleteAndValidDeck(deck.cards), "Incomplete/invalid deck after shuffle");
    }

    func testDeckHumanShuffleMany() {
        let deck = Deck();

        let unshuffledCards = deck.cards;
        let unshuffledHash = deck.hashValue;
        XCTAssertFalse(deck.isShuffled, "A fresh deck should be unshuffled");

        deck.humanCutAndShuffle(10, validate: false);
        XCTAssertTrue(deck.isShuffled, "A shuffled deck should be shuffled!");

        let shuffledCards = deck.cards;
        let shuffledHash = deck.hashValue;

        XCTAssertNotEqual(unshuffledHash, shuffledHash, "Deck is unchanged and after shuffling!");

        let isEqual = cardArraysAreEqual(shuffledCards, deckCards2: unshuffledCards);
        XCTAssertFalse(isEqual, "Shuffled deck should not be the same as a fresh deck");

        XCTAssertTrue(deck.isCompleteAndValidDeck(deck.cards), "Incomplete/invalid deck after shuffle");
    }
}
