//
//  AppNavigator.swift
//  SampleApp
//
//  Created by Porter McGary on 12/7/24.
//

import AstroNavigation
import SwiftUI

@Observable class AppNavigator: Navigator {
    var modalDestination: Destination?
    var fullscreenDestination: Destination?
    var tabSelection: Tab = .first
    var root: CoreRoot = .tab(.first)
    var paths: Paths = {
        Tab.allCases.map { Path(root: .tab($0)) } + Modal.allCases.map { Path(root: .modal($0)) }
    }()
}

extension AppNavigator {
    enum Destination: DestinationEntity {
        case helloWorld
        case goodbyeWorld
        
        var id: Self { self }
    }
}

extension AppNavigator {
    enum Tab: Int, Identifiable, TabEntity {
        case first = 1
        case second
        case third
        
        var id: Self { self }
        
        var name: String {
            String(describing: self).capitalized
        }
        
        var systemImage: String {
            "\(rawValue).circle.fill"
        }
    }
}
