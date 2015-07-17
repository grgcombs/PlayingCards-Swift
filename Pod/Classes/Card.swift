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
        glyph = SharedCardGlyphsInstance.glyphForSuite(suite, cardType: type)!;
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
            switch self {
            case .Ace, .Two, .Three, .Four, .Five, .Six, .Seven, .Eight, .Nine, .Ten:
                return rawValue;
            case .Jack, .Queen, .King:
                return 10;
            }
        }
    }

    public var maxPointValue : Int {
        get {
            if (self == .Ace) {
                return pointValue + 10;
            }
            return pointValue;
        }
    }

    public var minPointValue : Int {
        return pointValue;
    }

    public static let allValues = [Ace,Two,Three,Four,Five,Six,Seven,Eight,Nine,Ten,Jack,Queen,King];
    public static let allNames = ["Ace","Two","Three","Four","Five","Six","Seven","Eight","Nine","Ten","Jack","Queen","King"];
}

private struct CardGlyphs {
    let cardGlyphs : [SuiteType : [CardType : String]];

    init() {
        let glyphTuples : [(suiteType: SuiteType, cardGlyphs: [CardType : String])];
        glyphTuples = SuiteType.allValues.map({
            ($0, CardGlyphs.cardGlyphsForSuite($0))
        });

        // not very FRP -- need to figure out how to clean it up or do it all in one pass above
        var glyphs : [SuiteType : [CardType : String]] = [:];
        for tuple in glyphTuples {
            glyphs[tuple.suiteType] = tuple.cardGlyphs;
        }
        cardGlyphs = glyphs;
    }

    func glyphForSuite(suiteType:SuiteType, cardType:CardType) -> String? {
        if let suiteGlyphs = cardGlyphs[suiteType] {
            if let glyph = suiteGlyphs[cardType] {
                return glyph;
            }
        }
        return nil;
    }

    static func cardGlyphRangesForSuite(suite:SuiteType) -> (range: Range<Int>, exclude: Int) {
        switch suite {
        case .Spades:
            return (0x1F0A1...0x1F0AE, 0x1F0AC);
        case .Hearts:
            return (0x1F0B1...0x1F0BE, 0x1F0BC);
        case .Diamonds:
            return (0x1F0C1...0x1F0CE, 0x1F0CC);
        case .Clubs:
            return (0x1F0D1...0x1F0DE, 0x1F0DC);
        }
    }

    static func cardGlyphsForSuite(suite: SuiteType) -> [CardType: String] {
        var glyphs : [CardType: String] = [:];
        var cardTypes = EnumerateGenerator(CardType.allValues.generate())
        let range = cardGlyphRangesForSuite(suite);

        for code in range.range {
            if code == range.exclude {
                continue;
            }

            let scalar = UnicodeScalar(code);
            let char = Character(scalar);

            if let cardIteration : (index: Int, element: CardType) = cardTypes.next() {
                let cardType = cardIteration.element;
                glyphs[cardType] = "\(char)";
            }
            else {
                break;
            }
        }
        return glyphs;
    }
}

private let SharedCardGlyphsInstance : CardGlyphs = CardGlyphs();
