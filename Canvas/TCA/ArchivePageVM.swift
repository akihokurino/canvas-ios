import Combine
import ComposableArchitecture
import Foundation
import SwiftUIPager

extension Page: Equatable {
    public static func == (lhs: SwiftUIPager.Page, rhs: SwiftUIPager.Page) -> Bool {
        return lhs.index == rhs.index
    }
}

enum ArchivePageVM {
    static let reducer = Reducer<State, Action, Environment> { state, action, _ in
        switch action {
        case .archiveListView(let action):
            switch action {
            case .startInitialize:
                state.currentPage = .withIndex(0)
            default:
                break
            }
            return .none
        case .frameListView(let action):
            switch action {
            case .startInitialize:
                state.currentPage = .withIndex(1)
            default:
                break
            }
            return .none
        case .changePage(let page):
            state.currentPage = page
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
        case changePage(Page)

        case archiveListView(ArchiveListVM.Action)
        case frameListView(FrameListVM.Action)
    }

    struct State: Equatable {
        let pageIndexes = Array(0 ..< 2)
        var currentPage: Page = .first()

        var archiveListView: ArchiveListVM.State?
        var frameListView: FrameListVM.State?
    }

    struct Environment {
        let mainQueue: AnySchedulerOf<DispatchQueue>
        let backgroundQueue: AnySchedulerOf<DispatchQueue>
    }
}
