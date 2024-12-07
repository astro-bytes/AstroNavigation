//
//  Navigator.swift
//  AstroNavigation
//
//  Created by Porter McGary on 12/6/24.
//

import Foundation
import Observation

@MainActor public protocol Navigator: Observable, AnyObject, Sendable {
    typealias CoreRoot = Root<Tab>
    typealias CorePath = Path<Tab>
    typealias Paths = [CorePath]
    
    associatedtype Destination: DestinationEntity
    associatedtype Tab: TabEntity
    
    var root: CoreRoot { get set }
    var tabSelection: Tab { get set }
    var modalDestination: Destination? { get set }
    var fullscreenDestination: Destination? { get set }
    var paths: Paths { get set }
}

public extension Navigator {
    func push(_ destination: Destination) {
        guard let index = index(for: root) else { return }
        paths[index].value.append(destination)
    }
    
    func replace(_ destination: Destination) {
        guard !isAt(root: root) else { return }
        pop()
        push(destination)
    }
    
    func pop() {
        guard let index = index(for: root) else { return }
        if isAtRoot(index), case .modal(let modal) = root {
            root = .tab(tabSelection)
            clear(for: modal)
        } else if !isAtRoot(index) {
            paths[index].value.removeLast()
        } else {
            return
        }
    }
    
    func popToRoot() {
        clearPath(of: root)
    }
    
    func navigate(to tab: Tab, preserveStack: Bool = true) {
        self.tabSelection = tab
        self.root = .tab(tab)
        if !preserveStack {
            clearPath(of: .tab(tab))
        }
        popModal()
        popFullscreenModal()
    }
    
    /// Pushes a destination onto the current navigationStack for the current Root
    func navigate(to destination: Destination, in modal: Modal) {
        self.root = .modal(modal)
        switch modal {
        case .standard:
            popFullscreenModal()
            self.modalDestination = destination
        case .fullscreen:
            popModal()
            self.fullscreenDestination = destination
        }
    }
    
    /// Removes all of the path items on the stack and replaces it with the destination
    func replace(_ destination: Destination, onto root: CoreRoot) {
        self.root = root
        self.push(destination)
        popModalBased(on: root)
    }
    
    /// Pops to the root of the specified ``Root``
    /// Should be used when in a modal or fullscreen modal
    func popToRoot(of root: CoreRoot) {
        self.root = root
        self.popToRoot()
        popModalBased(on: root)
    }
}

extension Navigator {
    func onTabChange(old: Tab, new: Tab) {
        root = .tab(new)
    }
    
    func onModalDismiss() {
        if root != .modal(.fullscreen) {
            root = .tab(tabSelection)
        }
    }
    
    
    func onFullScreenCoverDismiss() {
        if root != .modal(.standard) {
            root = .tab(tabSelection)
        }
    }
}

fileprivate extension Navigator {
    func clear(for modal: Modal) {
        switch modal {
        case .standard:
            popModal()
        case .fullscreen:
            popFullscreenModal()
        }
    }
    
    func popModal() {
        if modalDestination != nil {
            modalDestination = nil
            clearPath(of: .modal(.standard))
        }
    }
    
    func popFullscreenModal() {
        if fullscreenDestination != nil {
            fullscreenDestination = nil
            clearPath(of: .modal(.fullscreen))
        }
    }
    
    func popModalBased(on root: CoreRoot) {
        switch root {
        case .tab:
            popModal()
            popFullscreenModal()
        case .modal(let modal):
            switch modal {
            case .standard:
                popFullscreenModal()
            case .fullscreen:
                popModal()
            }
        }
    }
    
    func clearPath(of root: CoreRoot) {
        guard let index = index(for: root) else { return }
        guard !isAtRoot(index) else { return }
        var path = paths[index].value
        path.removeLast(path.count)
        paths[index].value = path
    }
    
    func isAt(root: CoreRoot) -> Bool {
        guard let index = index(for: root) else { return false }
        return isAtRoot(index)
    }
    
    func isAtRoot(_ index: Int) -> Bool {
        return paths[index].value.isEmpty
    }
    
    func index(for root: CoreRoot) -> Int? {
        paths.firstIndex(where: { $0.root == root })
    }
}
