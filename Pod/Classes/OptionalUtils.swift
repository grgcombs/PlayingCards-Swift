//
//  OptionalUtils.swift
//  PlayingCards (Swift)
//
//  Created by Gregory Combs on 7/14/15.
//

import Foundation;

public func isOptionalNotNil<T>(value: T?) -> Bool {
    switch (value) {
    case .Some(_):
        return true;
    case .None:
        return false;
    }
}

public func isOptionalNil<T>(value: T?) -> Bool {
    switch (value) {
    case .Some(_):
        return false;
    case .None:
        return true;
    }
}
