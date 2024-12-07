//
//  NavigationSheetModifier.swift
//  AstroNavigation
//
//  Created by Porter McGary on 12/7/24.
//

import SwiftUI

struct NavigationSheetModifier<N: Navigator, D: Identifiable, V: View>: ViewModifier {
    @Environment(N.self) var navigator
    
    let destination: Binding<D?>
    let onDismiss: (() -> Void)?
    let content: (D) -> V
    
    init(_: N.Type, destination: Binding<D?>, onDismiss: (() -> Void)?, content: @escaping (D) -> V) {
        self.destination = destination
        self.onDismiss = onDismiss
        self.content = content
    }
    
    func body(content modifierContent: Content) -> some View {
        @Bindable var bindableNav = navigator
        modifierContent.sheet(item: destination) {
            onDismiss?()
            navigator.onModalDismiss()
        } content: { item in
            NavigationStack(path: modifierContent.path(for: .modal(.standard), in: $bindableNav)) {
                content(item)
            }
            .environment(navigator)
        }
    }
}
