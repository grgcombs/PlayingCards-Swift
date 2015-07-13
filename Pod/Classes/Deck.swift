//
//  Deck.swift
//  Pods
//
//  Created by Gregory Combs on 6/30/15.
//

import Foundation

public class Deck {
    public let suites: [Suite];
    public let cardCount: Int = 52;
    public let suiteCount: Int = 4;

    public func isShuffled() -> Bool {
        return _shuffled;
    }

    public func cards() -> [Card] {
        return _cards;
    }

    public func randomShuffle() {
        _currentIndex = 0;
        var cards = _cards;
        let lastIndex = (cards.count - 1)
        for firstIndex in stride(from: lastIndex, through:1, by:-1)
        {
            let upperBoundary: UInt32 = UInt32(firstIndex + 1);
            let secondIndex = Int(arc4random_uniform(upperBoundary));

            let tempCard = cards[firstIndex];
            cards[firstIndex] = cards[secondIndex];
            cards[secondIndex] = tempCard;
        }
        _cards = cards;
        _shuffled = true;
    }

    /*! PRIVATE !*/

    private var _shuffled: Bool = false;
    private var _cards: [Card];
    private var _currentIndex: Int = 0;

    public init() {
        var tempSuites : [Suite] = [];
        var tempCards : [Card] = [];
        tempCards.reserveCapacity(cardCount);

        for suiteType in SuiteType.allValues {
            let suite = Suite(type: suiteType);
            tempSuites += [suite];
            tempCards.extend(suite.cards);
        }
        suites = tempSuites;
        _cards = tempCards;

        assert(tempSuites.count == suiteCount, "Unexpected suite count for deck");
        assert(tempCards.count == cardCount, "Unexpected card count for deck");
    }
}
