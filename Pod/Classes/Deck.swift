//
//  Deck.swift
//  PlayingCards (Swift)
//
//  Created by Gregory Combs on 6/30/15.
//

import Foundation

public class Deck : Hashable {
    public let suites: [Suite];
    public let cardCount: Int = 52;
    public let suiteCount: Int = 4;
    public var hashValue: Int;

    public var description : NSString {
        get {
            let shuffled = (isShuffled) ? "Yes" : "No";
            let remaining = cardCount - _currentIndex
            return "Cards=\(remaining)/\(cardCount); Shuffled=\(shuffled); Hash=\(hashValue)";
        }
    }

    public var isShuffled : Bool {
        get {
            return _shuffled;
        }
    }

    public var cards : [Card] {
        get {
            return _cards;
        }
    }

    public func randomShuffle(validate: Bool = true) {
        var cards = _cards;
        let startHash = validate ? Card.hashForCards(cards) : 0;

        let lastIndex = (cards.count - 1)
        for firstIndex in stride(from: lastIndex, through:1, by:-1)
        {
            let upperBoundary: UInt32 = UInt32(firstIndex + 1);
            let secondIndex = Int(arc4random_uniform(upperBoundary));

            let tempCard = cards[firstIndex];
            cards[firstIndex] = cards[secondIndex];
            cards[secondIndex] = tempCard;
        }

        if validate {
            let endHash = Card.hashForCards(cards);

            assert(startHash != endHash, "The deck of cards was not shuffled!");
            if (startHash == endHash)
            {
                return;
            }

        }
        commitShuffleWithCards(cards);
    }

    public func isCompleteAndValidDeck(cards : [Card]) -> Bool {
        if cards.count != cardCount {
            return false;
        }

        var suiteMap : [SuiteType: Set<Card>] = Dictionary(minimumCapacity: suiteCount);
        for suite in suites {
            suiteMap[suite.suiteType] = Set(suite.cards);
        }

        for card in cards {
            if let suiteCards = suiteMap[card.suiteType] {
                if suiteCards.contains(card) {
                    var mutableCards = suiteCards;
                    mutableCards.remove(card);
                    suiteMap[card.suiteType] = mutableCards;
                }
                else
                {
                    return false;
                }
            }
            else {
                return false;
            }
        }
        return true;
    }

    public func dealCard() -> Card? {
        let cards = self.cards;
        var index = _currentIndex;
        index++;
        if (cards.count <= index) {
            return nil;
        }
        _currentIndex = index;
        hashValue = Deck.getHashWithShuffled(self.isShuffled, cards: cards, index: index);
        return cards[index];
    }

    /*! PRIVATE !*/

    private var _shuffled: Bool = false;
    private var _cards: [Card];
    private var _currentIndex: Int = 0;

    public init() {
        suites = SuiteType.allValues.map({
            Suite(type: $0)
        });

        //var tempSuites : [Suite] = [];
        var tempCards : [Card] = [];
        tempCards.reserveCapacity(cardCount);

        for suite in suites {
            tempCards.extend(suite.cards);
        }
        _cards = tempCards;
        hashValue = Deck.getHashWithShuffled(false, cards: tempCards, index: 0);

        assert(tempCards.count == cardCount, "Unexpected card count for deck");
        assert(suites.count == suiteCount, "Unexpected suite count for deck");
    }

    internal func commitShuffleWithCards(cards: [Card]) {
        let shuffled = true;
        let index = 0;
        _cards = cards;
        _currentIndex = index;
        _shuffled = shuffled;
        hashValue = Deck.getHashWithShuffled(shuffled, cards: cards, index: index);
    }

    internal static func getHashWithShuffled(isShuffled: Bool, cards: [Card], index: Int) -> Int {
        let cardsHash = Card.hashForCards(cards);
        return HashUtils.compositeHash([isShuffled.hashValue, cardsHash, index.hashValue]);
    }
}

public func ==(lhs: Deck, rhs: Deck) -> Bool {
    return (lhs.hashValue == rhs.hashValue);
}
