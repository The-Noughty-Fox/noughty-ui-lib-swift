//
//  File.swift
//
//
//  Created by Lisnic Victor on 12.07.2021.
//

import Foundation
import ComposableArchitecture
import SwiftUI

extension Reducer {
    public func presents<Route, LocalState, LocalAction, LocalEnvironment>(
        _ localReducer: Reducer<LocalState, LocalAction, LocalEnvironment>,
        tag: CasePath<Route, LocalState>,
        selection: WritableKeyPath<State, Route?>,
        action toPresentationAction: CasePath<Action, PresentationAction<LocalAction>>,
        environment toLocalEnvironment: @escaping (Environment) -> LocalEnvironment
    ) -> Self {
      let id = UUID()
      return Self { state, action, environment in
        let wasPresented = state[keyPath: selection].flatMap(tag.extract(from:)) != nil
        return Self.combine(
          localReducer
            .cancellable(id: id)
            ._pullback(
                state: OptionalPath(selection).appending(path: tag),
                action: toPresentationAction.appending(path: /PresentationAction.isPresented),
                environment: toLocalEnvironment),
          self,
          Reducer<State, PresentationAction<LocalAction>, Void> { state, action, _ in
            if case .onDismiss = action {
                state[keyPath: selection] = nil
            }
            return wasPresented && state[keyPath: selection] == nil ? .cancel(id: id) : .none
          }
          .pullback(state: \.self, action: toPresentationAction, environment: { _ in () })
        )
        .run(&state, action, environment)
      }
    }
}

fileprivate extension Reducer {
    func cancellable(id: AnyHashable) -> Reducer {
        .init { state, action, environment in
            self.run(&state, action, environment).cancellable(id: id)
        }
    }
}

extension View {
    public func backdrop<State, Action, Content>(
        ifLet store: Store<State?, PresentationAction<Action>>,
        config: BackdropConfig,
        @ViewBuilder then content: @escaping (Store<State, Action>, BackDropContentConfig, Binding<Bool>) -> Content
    ) -> some View
    where Content: View {
        WithViewStore(store.scope(state: { $0 != nil })) { viewStore in
            self.backdrop(
                isShown: viewStore.binding(send: .onDismiss),
                config: config
            ) { contentConfig, isDragEnabled in
                IfLetStore(
                    store.scope(
                        state: Optional.cacheLastSome,
                        action: PresentationAction.isPresented
                    )
                ) { store in
                    content(store, contentConfig, isDragEnabled)
                }
            }
        }
    }
    
    public func backdrop<State, Action, Content, Route>(
        statePath: CasePath<Route, State>,
        route: Store<Route?, PresentationAction<Action>>,
        config: BackdropConfig,
        @ViewBuilder then content: @escaping (Store<State, Action>, BackDropContentConfig, Binding<Bool>) -> Content
    ) -> some View
    where Content: View {
        let stateStore = route.scope(
            state: { $0.flatMap(statePath.extract(from:)) },
            action: PresentationAction.isPresented
        )
        
        let isShownStore = route.scope(state: { $0.flatMap(statePath.extract(from:)) != nil })
        
        return WithViewStore(isShownStore) { viewStore in
            self.backdrop(
                isShown: viewStore.binding(send: .onDismiss),
                config: config) { contentConfig, isDragEnabled in
                IfLetStore(stateStore.scope(
                            state: Optional.cacheLastSome
                )) { store in
                    content(store, contentConfig, isDragEnabled)
                }
            }
        }
    }
}

extension Optional {
  static var cacheLastSome: (Self) -> Self {
    var lastWrapped: Wrapped?
    return {
      lastWrapped = $0 ?? lastWrapped
      return lastWrapped
    }
  }
}
