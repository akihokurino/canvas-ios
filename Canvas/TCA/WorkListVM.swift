import Combine
import ComposableArchitecture
import Foundation

enum WorkListVM {
    static let reducer = Reducer<State, Action, Environment> { _, action, _ in
        switch action {
        case .onAppear:
            return .none
        }
    }
}

extension WorkListVM {
    enum Action: Equatable {
        case onAppear
    }

    struct State: Equatable {}

    struct Environment {
        let mainQueue: AnySchedulerOf<DispatchQueue>
        let backgroundQueue: AnySchedulerOf<DispatchQueue>
    }
}
