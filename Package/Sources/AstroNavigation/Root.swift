//
//  Root.swift
//  AstroNavigation
//
//  Created by Porter McGary on 12/6/24.
//

import Foundation

public enum Root<Tab: TabEntity>: Equatable, Sendable {
    case tab(Tab)
    case modal(Modal)
}

extension Root: CustomStringConvertible {
    public var description: String {
        switch self {
        case .tab(let tab):
            "TAB: \(tab)"
        case .modal(let modal):
            "MODAL: \(modal)"
        }
    }
}
