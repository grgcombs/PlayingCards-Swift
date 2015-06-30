//: Playground - noun: a place where people can play

import UIKit

public let HashCharBitSize = (Int(CHAR_BIT) * Int(sizeof(Int)));

public func RotateHashValue(hash: Int, howMuch: Int) -> Int {
    let first = hash << howMuch;
    let second = hash >> (HashCharBitSize - howMuch);
    return first | second;
}

public func ComputeValueHash(hash: Int, hashIndex: Int) -> Int {
    let bitSize = HashCharBitSize;
    let hashValue = (hash == 0) ? 31 : hash;
    let howMuch = bitSize / (hashIndex + 1);
    return RotateHashValue(hashValue,howMuch);
}

public func ComputeHash(hashValues: [Int]) -> Int {
    var current = 31;
    var hashIndex = 1;

    for hash in hashValues {
        current = ComputeValueHash(hash, hashIndex) ^ current;
        hashIndex++;
    }
    return current;
}

public enum SuiteType : UInt8 {
    case Hearts = 0, Diamonds, Clubs, Spades;

    public func color() -> UIColor {
        switch self {
        case .Hearts, .Diamonds:
            return UIColor.redColor();
        case .Clubs, .Spades:
            return UIColor.blackColor();
        }
    }

    public func name() -> String {
        switch self {
        case .Hearts:
            return "Hearts";
        case .Diamonds:
            return "Diamonds";
        case .Clubs:
            return "Clubs";
        case .Spades:
            return "Spades";
        }
    }

    static let allValues = [Hearts,Diamonds,Clubs,Spades];
}

public enum CardType : Int {
    case Ace = 1, Two, Three, Four, Five, Six, Seven, Eight, Nine, Ten, Jack, Queen, King;

    public func name() -> String {
        let strings = ["Ace", "Two", "Three", "Four", "Five", "Six", "Seven", "Eight", "Nine", "Ten", "Jack", "Queen", "King"];
        return strings[self.rawValue - 1];
    }

    private func pointValue() -> Int {
        switch self {
        case .Ace, .Two, .Three, .Four, .Five, .Six, .Seven, .Eight, .Nine, .Ten:
            return rawValue;
        case .Jack, .Queen, .King:
            return 10;
        }
    }

    public func maxPointValue() -> Int {
        if (self == .Ace) {
            return pointValue() + 10;
        }
        return pointValue();
    }

    public func minPointValue() -> Int {
        return pointValue();
    }

    public static let allValues = [Ace,Two,Three,Four,Five,Six,Seven,Eight,Nine,Ten,Jack,Queen,King];
}

public struct Card : Equatable {
    public let suiteType: SuiteType;
    public let cardType: CardType;
    public let name: String;
    public let color: UIColor;
    public let description : String;
    public let maxPointValue: Int;
    public let minPointValue: Int;

    init(suite: SuiteType, type: CardType) {
        suiteType = suite;
        cardType = type;
        name = type.name();
        color = suite.color();
        maxPointValue = type.maxPointValue();
        minPointValue = type.minPointValue();
        description = "\(type.name()) of \(suite.name())";
    }

    func hash() -> Int {
        let hashValues = [suiteType.hashValue, cardType.hashValue];
        return ComputeHash(hashValues);
    }
}

public func ==(x: Card, y: Card) -> Bool {
    return (x.suiteType == y.suiteType &&
            x.cardType == y.cardType);
}

public struct Suite {
    public let suiteType: SuiteType;
    public let name: String;
    public let color: UIColor;
    public let cards: [Card];
    public let cardCount: Int = 13;

    init(type: SuiteType) {
        suiteType = type;
        name = type.name();
        color = type.color();

        var tempCards : [Card] = [];
        for cardType in CardType.allValues {
            let card = Card(suite: type, type: cardType);
            tempCards += [card];
        }
        cards = tempCards;
        assert(cards.count == cardCount, "Unexpected card count for suite \(name)");
    }
}


public class Deck {
    public let suites: [Suite];
    public let cardCount: Int = 52;
    public let suiteCount: Int = 4;
    private var _shuffled: Bool = false;
    private var _cards: [Card];
    private var _currentIndex: Int = 0;

    init() {
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

        assert(suites.count == suiteCount, "Unexpected suite count for deck");
        assert(tempCards.count == cardCount, "Unexpected card count for deck");
    }

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
}

let deck = Deck.init();
let suites = deck.suites;
let unshuffledCards = deck.cards();

println("Deck is shuffled: \(deck.isShuffled())");
println("Number of suites in deck: \(suites.count)");
println("Number of cards in deck: \(deck.cardCount)");

private func testCardHashCollisions(cards:[Card]) {
    var hashes : [Int : Card] = [:];

    for card in cards {
        let hash = card.hash();
        let existingCard : Card? = hashes[hash];
        var foundCollision = false;
        if (existingCard != nil) {
            println("Hash collision for cards: \(card.description) and \(existingCard?.description)");
            foundCollision = true;
        }
        hashes[hash] = card;
        println("\(card.description) and collision?: \(foundCollision)");
    }
}

private func testDeckCardEquality(deckCards1:[Card], deckCards2: [Card]) {
    let theyMatch = deckCards1 == deckCards2;
    println("Deck card arrays are the same: \(theyMatch)");

    var theyAllMatched = true;
    for (var i = 0; (i < deckCards1.count && i < deckCards2.count); i++) {
        let card1 = deckCards1[i];
        let card2 = deckCards2[i];
        if (card1.hash() != card2.hash() ||
            card1 != card2)
        {
            theyAllMatched = false;
            break;
        }
    }
    println("Did they all match? \(theyAllMatched)");
}

testCardHashCollisions(unshuffledCards);

println("Shuffling deck...");
deck.randomShuffle();
let shuffledCards = deck.cards();

println("Deck is shuffled: \(deck.isShuffled())");
println("Number of cards in deck: \(deck.cardCount)");

testDeckCardEquality(shuffledCards, unshuffledCards);

