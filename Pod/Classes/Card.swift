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
    public let glyph: String;
    public let description : String;
    public let maxPointValue: Int;
    public let minPointValue: Int;
    public let hashValue: Int;

    public init(suite: SuiteType, type: CardType) {
        suiteType = suite;
        cardType = type;
        name = type.name;
        color = suite.color;
        maxPointValue = type.maxPointValue;
        minPointValue = type.minPointValue;
        description = "\(type.name) of \(suite.name)";
        hashValue = HashUtils.compositeHash([suiteType.hashValue, cardType.hashValue]);
        glyph = CardGlyphs.glyphForSuite(suite, cardType: type)!;
    }

    public static func descriptionsForCards(cards: [Card]) -> [String] {
        return cards.map({
            $0.description;
        });
    }

    public static func compositeDescriptionForCards(cards: [Card]) -> NSString {
        let descriptions = descriptionsForCards(cards);
        var string = "(n=\(cards.count)[";
        for (i, v) in enumerate(descriptions) {
            string.extend("  \(i): \(v), ");
        }
        string.extend("]");
        return string;
    }

    public static func hashForCards(cards: [Card]) -> Int {
        let description = compositeDescriptionForCards(cards);
        return description.hashValue;
    }
}

public func ==(lhs: Card, rhs: Card) -> Bool {
    return (lhs.suiteType == rhs.suiteType && lhs.cardType == rhs.cardType);
}

public enum CardType : Int, Printable {
    case Ace = 1, Two, Three, Four, Five, Six, Seven, Eight, Nine, Ten, Jack, Queen, King;

    public var name : String {
        get {
            // our enum starts at 1, not 0
            return CardType.allNames[self.rawValue - 1];
        }
    }

    public var description: String {
        get {
            return self.name;
        }
    }

    private var pointValue : Int {
        get {
            switch self.rawValue {
            case Ten.rawValue...King.rawValue:
                return 10;
            default:
                return rawValue;
            }
        }
    }

    public var maxPointValue : Int {
        get {
            switch self {
            case .Ace:
                return 11;
            default:
                return pointValue;
            }
        }
    }

    public var minPointValue : Int {
        return pointValue;
    }

    public static let allValues = [Ace,Two,Three,Four,Five,Six,Seven,Eight,Nine,Ten,Jack,Queen,King];
    public static let allNames = ["Ace","Two","Three","Four","Five","Six","Seven","Eight","Nine","Ten","Jack","Queen","King"];
}
