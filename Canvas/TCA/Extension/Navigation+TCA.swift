import ComposableArchitecture
import SwiftUI

extension NavigationLink {
    static func store<State, Action, DestinationContent>(
        _ store: Store<State?, Action>,
        destination: @escaping (_ destinationStore: Store<State, Action>) -> DestinationContent,
        action: @escaping (_ isActive: Bool) -> Void,
        label: @escaping () -> Label
    ) -> some View
        where DestinationContent: View,
        Destination == IfLetStore<State, Action, DestinationContent?>
    {
        WithViewStore(store.scope(state: { $0 != nil })) { viewStore in
            NavigationLink(
                destination: IfLetStore(
                    store.scope(state: replayNonNil()),
                    then: destination
                ),
                isActive: Binding(
                    get: { viewStore.state },
                    set: action
                ),
                label: label
            )
        }
    }
}

extension View {
    func navigate<State, Action, DestinationContent>(
        using store: Store<State?, Action>,
        destination: @escaping (_ destinationStore: Store<State, Action>) -> DestinationContent,
        onDismiss: @escaping () -> Void
    ) -> some View
        where DestinationContent: View
    {
        background(
            NavigationLink.store(
                store,
                destination: destination,
                action: { isActive in
                    if isActive == false {
                        onDismiss()
                    }
                },
                label: EmptyView.init
            )
        )
    }
}

extension Reducer {
    func connect<LocalState, LocalAction, LocalEnvironment>(
        _ localReducer: Reducer<LocalState, LocalAction, LocalEnvironment>,
        state toLocalState: WritableKeyPath<State, LocalState?>,
        action toLocalAction: CasePath<Action, LocalAction>,
        environment toLocalEnvironment: @escaping (Environment) -> LocalEnvironment
    ) -> Self {
        let localEffectsId = UUID()
        var lastNonNilLocalState: LocalState?
        return Self { state, action, environment in
            let localEffects = localReducer
                .optional()
                .replaceNilState(with: lastNonNilLocalState)
                .captureState { lastNonNilLocalState = $0 ?? lastNonNilLocalState }
                .pullback(state: toLocalState, action: toLocalAction, environment: toLocalEnvironment)
                .run(&state, action, environment)
                .cancellable(id: localEffectsId)
            let globalEffects = run(&state, action, environment)
            let hasLocalState = state[keyPath: toLocalState] != nil
            return .merge(
                localEffects,
                globalEffects,
                hasLocalState ? .none : .cancel(id: localEffectsId)
            )
        }
    }
}

extension Reducer {
    func captureState(_ capture: @escaping (_ state: State) -> Void) -> Self {
        .init { state, action, environment in
            capture(state)
            return run(&state, action, environment)
        }
    }
}

extension Reducer {
    func replaceNilState<S>(
        with replacement: @escaping @autoclosure () -> S?
    ) -> Self where State == S? {
        .init { state, action, environment in
            guard state != nil else {
                var replacedState = replacement()
                return run(&replacedState, action, environment)
            }
            return run(&state, action, environment)
        }
    }
}

func replayNonNil<A, B>(_ inputClosure: @escaping (A) -> B?) -> (A) -> B? {
    var lastNonNilOutput: B?
    return { inputValue in
        guard let outputValue = inputClosure(inputValue) else {
            return lastNonNilOutput
        }
        lastNonNilOutput = outputValue
        return outputValue
    }
}

func replayNonNil<T>() -> (T?) -> T? {
    replayNonNil { $0 }
}
