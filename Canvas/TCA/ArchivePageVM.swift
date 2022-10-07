import Combine
import ComposableArchitecture
import Foundation
import SwiftUIPager

enum ArchivePageVM {
    static let reducer = Reducer<State, Action, Environment> { state, action, _ in
        switch action {
        case .changePage(let index):
            state.currentPage = .withIndex(index)
            state.currentSelection = index
            return .none
        case .archiveListView(let action):
            return .none
        case .frameListView(let action):
            return .none
        }
    }
    .connect(
        ArchiveListVM.reducer,
        state: \.archiveListView,
        action: /ArchivePageVM.Action.archiveListView,
        environment: { _environment in
            ArchiveListVM.Environment(
                mainQueue: _environment.mainQueue,
                backgroundQueue: _environment.backgroundQueue
            )
        }
    )
    .connect(
        FrameListVM.reducer,
        state: \.frameListView,
        action: /ArchivePageVM.Action.frameListView,
        environment: { _environment in
            FrameListVM.Environment(
                mainQueue: _environment.mainQueue,
                backgroundQueue: _environment.backgroundQueue
            )
        }
    )
}

extension ArchivePageVM {
    enum Action: Equatable {
        case changePage(Int)

        case archiveListView(ArchiveListVM.Action)
        case frameListView(FrameListVM.Action)
    }

    struct State: Equatable {
        let pageIndexes = Array(0 ..< 2)

        var currentPage: Page = .withIndex(0)
        var currentSelection: Int = 0

        var archiveListView: ArchiveListVM.State?
        var frameListView: FrameListVM.State?
    }

    struct Environment {
        let mainQueue: AnySchedulerOf<DispatchQueue>
        let backgroundQueue: AnySchedulerOf<DispatchQueue>
    }
}
