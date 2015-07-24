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

    public func humanCutAndShuffle(iterations: Int, validate: Bool = true) {
        assert(iterations > 0, "Must have at least 1 interation to cut and shuffle the cards");
        if iterations <= 0 {
            return;
        }

        var cards = self.cards;
        let startHash = validate ? Card.hashForCards(cards) : 0;

        for i in 0..<iterations {

            // Could extend this by externalizing the cut location to other player's choice instead of random
            let cutPercent = Double(Int.random(40...60)) / 100.0;

            let cut : (first: [Card], second: [Card]) = cutCards(cards, cutAt: cutPercent);

            cards = interleaveCards(cut.first, second: cut.second);

            if (cards.count != cardCount)
            {
                return;
            }
        }

        if validate {
            assert(isCompleteAndValidDeck(cards), "The shuffled array of cards is invalid");

            let endHash = Card.hashForCards(cards);

            assert(startHash != endHash, "The deck of cards was not shuffled!");
            if startHash == endHash {
                return;
            }
        }

        commitShuffleWithCards(cards);
    }

    public func isCompleteAndValidDeck(cards : [Card]) -> Bool {
        if cards.count != cardCount {
            return false;
        }

        var suiteMap : [SuiteType: Set<Card>] = suites.reduce([:], combine: {
            var map : [SuiteType: Set<Card>] = $0;
            let suite = $1;
            map[suite.suiteType] = Set(suite.cards);
            return map;
        });

        for card in cards {
            if let suiteCards = suiteMap[card.suiteType] {
                if suiteCards.contains(card) {
                    var mutableCards = suiteCards;
                    mutableCards.remove(card);
                    suiteMap[card.suiteType] = mutableCards;
                    continue;
                }
            }
            return false;
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

        _cards = suites.reduce([], combine: {
            var collection : [Card] = $0;
            collection.extend($1.cards);
            return collection;
        });

        hashValue = Deck.getHashWithShuffled(false, cards: _cards, index: 0);

        assert(_cards.count == cardCount, "Unexpected card count for deck");
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

    private func cutCards(cards: [Card], cutAt: Double = 0.5) -> (first: [Card], second: [Card]) {
        assert(cutAt > 0.0 && cutAt < 1.0, "Invalid splitPercent (\(cutAt)), must be greater than 0.0 and less than 1.0");
        var splitPercent = cutAt;
        if (splitPercent <= 0.0 || splitPercent >= 1.0) {
            splitPercent = 0.5;
        }
        let splitIndex = Int(floor(splitPercent * Double(cards.count)))
        assert(cards.count > splitIndex, "Something went wrong with the card split: index=\(splitIndex); count=\(cards.count);");

        let splitCard = cards[splitIndex];
        var separated = split(cards, maxSplit:1, allowEmptySlices: false, isSeparator: {$0==splitCard});
        // put the splitCard back into the cut since split() removed it...
        separated[1].insert(splitCard, atIndex: 0)

        let first : [Card] = Array(separated[0]);
        let second : [Card] = Array(separated[1]);
        return (first, second);
    }

    private func interleaveCards(first: [Card], second: [Card]) -> [Card] {
        let firstCount = first.count;
        let secondCount = second.count;
        let totalCount = firstCount + secondCount;

        assert(totalCount == cardCount, "Unexpected number of cards after cardCut, got: \(totalCount); wanted:\(cardCount)");
        if (totalCount != cardCount)
        {
            return [];
        }

        let largerCut = (firstCount > secondCount) ? first : second;
        let largerCutCount = largerCut.count;

        let smallerCut = (firstCount > secondCount) ? second : first;
        let smallerCutCount = smallerCut.count;

        var rejoin : [Card] = Array();
        for i in 0..<smallerCutCount {
            let firstCard = first[i];
            let secondCard = second[i];
            rejoin.extend([firstCard,secondCard]);
        }

        // If the cuts were unevenly divided (likely), our rejoin is incomplete
        let remainingCount = cardCount - rejoin.count;
        if (remainingCount > 0)
        {
            let offset = largerCutCount - remainingCount;
            let remaining = largerCut[offset..<largerCutCount];
            rejoin.extend(remaining)
        }
       return rejoin;
    }

}

public func ==(lhs: Deck, rhs: Deck) -> Bool {
    return (lhs.hashValue == rhs.hashValue);
}
