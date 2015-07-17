//
//  Suite.swift
//  PlayingCards (Swift)
//
//  Created by Gregory Combs on 6/30/15.
//
//

import UIKit;

public struct Suite : Hashable, Printable {
    public let suiteType: SuiteType;
    public let name: String;
    public let color: UIColor;
    public let symbol: String;
    public let cards: [Card];
    public let cardCount: Int = 13;
    public var hashValue : Int {
        return HashUtils.compositeHash([suiteType.hashValue]);
    }

    public init(type: SuiteType) {
        suiteType = type;
        name = type.name;
        color = type.color;
        symbol = type.symbol;

        cards = CardType.allValues.map({
            Card(suite: type, type: $0)
        });

        assert(cards.count == cardCount, "Unexpected card count for suite \(name)");
    }

    public var description: String {
        get {
            return "\(self.name) (\(self.symbol))";
        }
    }
}

public func ==(lhs: Suite, rhs: Suite) -> Bool {
    return (lhs.suiteType == rhs.suiteType);
}

public enum SuiteType : Int, Printable {
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
            assert(SuiteType.allNames.count > self.rawValue , "Mismatch in SuiteType length versus allNames length");
            return SuiteType.allNames[self.rawValue];
        }
    }

    public var description : String {
        get {
            return self.name;
        }
    }

    public var symbol : String {
        get {
            assert(SuiteType.allSymbols.count > self.rawValue , "Mismatch in SuiteType length versus allSymbols length");
            return SuiteType.allSymbols[self.rawValue];
        }
    }

    public static let allValues = [Hearts,Diamonds,Clubs,Spades];
    public static let allNames = ["Hearts", "Diamonds", "Clubs", "Spades"];
    public static let allSymbols = ["♥️", "♦️", "♣️", "♠️"];
}
