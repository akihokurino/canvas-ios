import Combine
import ComposableArchitecture
import Foundation

enum WorkListVM {
    static let reducer = Reducer<State, Action, Environment> { _, action, _ in
        switch action {
        case .initialize:
            return .none
        }
    }
}

extension WorkListVM {
    enum Action: Equatable {
        case initialize
    }

    struct State: Equatable {}

    struct Environment {
        let mainQueue: AnySchedulerOf<DispatchQueue>
        let backgroundQueue: AnySchedulerOf<DispatchQueue>
    }
}
