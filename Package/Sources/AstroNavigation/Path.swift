//
//  Path.swift
//  AstroNavigation
//
//  Created by Porter McGary on 12/7/24.
//

import SwiftUI

public struct Path<Tab: TabEntity> {
    var root: Root<Tab>
    var value: NavigationPath
    
    public init(root: Root<Tab>) {
        self.root = root
        self.value = NavigationPath()
    }
}
