//
//  NavigatorEnvironmentKey.swift
//  AstroNavigation
//
//  Created by Porter McGary on 12/7/24.
//

import SwiftUI

// TODO: There has to be some way to make this work ... so that we don't have to pass the navigator Metadata Type to the navigation sheet objects
struct NavigatorKey: EnvironmentKey {
    nonisolated(unsafe) static var defaultValue: (any Navigator)? = nil
}

extension EnvironmentValues {
    public var navigator: (any Navigator)? {
        get { self[NavigatorKey.self] }
        set { self[NavigatorKey.self] = newValue }
    }
}
