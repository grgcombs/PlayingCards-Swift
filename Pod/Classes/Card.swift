//
//  Card
//  PlayingCards (Swift)
//
//  Created by Gregory Combs on 6/30/15.
//

import UIKit;

public struct Card : Hashable {
    public let suiteType: SuiteType;
    public let cardType: CardType;
    public let name: String;
    public let color: UIColor;
    public let description : String;
    public let maxPointValue: Int;
    public let minPointValue: Int;
    public var hashValue: Int {
        get {
            return HashUtils.compositeHash([suiteType.hashValue, cardType.hashValue]);
        }
    }

    public init(suite: SuiteType, type: CardType) {
        suiteType = suite;
        cardType = type;
        name = type.name();
        color = suite.color();
        maxPointValue = type.maxPointValue();
        minPointValue = type.minPointValue();
        description = "\(type.name()) of \(suite.name())";
    }
}

public func ==(lhs: Card, rhs: Card) -> Bool {
    return (lhs.suiteType == rhs.suiteType && lhs.cardType == rhs.cardType);
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

