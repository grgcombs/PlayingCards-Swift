//
//  Suit.swift
//  PlayingCards (Swift)
//
//  Created by Gregory Combs on 6/30/15.
//
//

import UIKit;

public struct Suit : Hashable, Printable {
    public let suiteType: SuitType;
    public let name: String;
    public let color: UIColor;
    public let symbol: String;
    public let cards: [Card];
    public let cardCount: Int = 13;
    public var hashValue : Int {
        return HashUtils.compositeHash([suiteType.hashValue]);
    }

    public init(type: SuitType) {
        suiteType = type;
        name = type.name;
        color = type.color;
        symbol = type.symbol;

        cards = CardType.allValues.map({
            Card(suit: type, type: $0)
        });

        assert(cards.count == cardCount, "Unexpected card count for suit \(name)");
    }

    public var description: String {
        get {
            return "\(self.name) (\(self.symbol))";
        }
    }
}

public func ==(lhs: Suit, rhs: Suit) -> Bool {
    return (lhs.suiteType == rhs.suiteType);
}

public enum SuitType : Int, Printable {
    case Hearts = 0, Diamonds, Clubs, Spades;

    public var color : UIColor {
        get {
            switch self {
            case .Hearts, .Diamonds:
                return UIColor.redColor();
            case .Clubs, .Spades:
                return UIColor.blackColor();
            }
        }
    }

    public var name : String {
        get {
            assert(SuitType.allNames.count > self.rawValue , "Mismatch in SuitType length versus allNames length");
            return SuitType.allNames[self.rawValue];
        }
    }

    public var description : String {
        get {
            return self.name;
        }
    }

    public var symbol : String {
        get {
            assert(SuitType.allSymbols.count > self.rawValue , "Mismatch in SuitType length versus allSymbols length");
            return SuitType.allSymbols[self.rawValue];
        }
    }

    public static let allValues = [Hearts,Diamonds,Clubs,Spades];
    public static let allNames = ["Hearts", "Diamonds", "Clubs", "Spades"];
    public static let allSymbols = ["♥️", "♦️", "♣️", "♠️"];
}
