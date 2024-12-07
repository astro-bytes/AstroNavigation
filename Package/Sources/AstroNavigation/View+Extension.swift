//
//  View+Extension.swift
//  AstroNavigation
//
//  Created by Porter McGary on 12/7/24.
//

import SwiftUI

public extension View {
    func syncTabs<N: Navigator>(for navigator: N) -> some View {
        self.onChange(of: navigator.tabSelection, navigator.onTabChange)
    }
    
    func navigationSheet<N: Navigator, V: View>(_ navigator: Binding<N>, onDismiss: (() -> Void)? = nil, @ViewBuilder content: @escaping (N.Destination) -> V) -> some View  {
        self.modifier(
            NavigationSheetModifier(
                N.self,
                destination: navigator.modalDestination,
                onDismiss: onDismiss,
                content: content
            )
        )
    }
    
    func navigationFullScreenCover<N: Navigator, V: View>(_ navigator: Binding<N>, onDismiss: (() -> Void)? = nil, @ViewBuilder content: @escaping (N.Destination) -> V) -> some View {
        self.modifier(
            NavigationFullScreenCoverModifier(
                N.self,
                destination: navigator.fullscreenDestination,
                onDismiss: onDismiss,
                content: content
            )
        )
    }
    
    func path<N: Navigator>(for root: N.CoreRoot, in navigator: Bindable<N>) -> Binding<NavigationPath> {
        guard let path = navigator.paths.first(where: { $0.root.wrappedValue == root }) else {
            fatalError("\(root) is not found in the \(N.self).paths array")
        }
        return path.value
    }
    
    func path<N: Navigator>(for root: N.CoreRoot, in navigator: Binding<N>) -> Binding<NavigationPath> {
        guard let path = navigator.paths.first(where: { $0.root.wrappedValue == root }) else {
            fatalError("\(root) is not found in the \(N.self).paths array")
        }
        return path.value
    }
}
