import Combine
import ComposableArchitecture
import Foundation

enum ArchivePageVM {
    static let reducer = Reducer<State, Action, Environment> { _, action, _ in
        switch action {
        case .archiveListView(let action):
            return .none
        case .thumbnailListView(let action):
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
        ThumbnailListVM.reducer,
        state: \.thumbnailListView,
        action: /ArchivePageVM.Action.thumbnailListView,
        environment: { _environment in
            ThumbnailListVM.Environment(
                mainQueue: _environment.mainQueue,
                backgroundQueue: _environment.backgroundQueue
            )
        }
    )
}

extension ArchivePageVM {
    enum Action: Equatable {
        case archiveListView(ArchiveListVM.Action)
        case thumbnailListView(ThumbnailListVM.Action)
    }

    struct State: Equatable {
        let pageIndexes = Array(0 ..< 2)
        
        var archiveListView: ArchiveListVM.State?
        var thumbnailListView: ThumbnailListVM.State?
    }

    struct Environment {
        let mainQueue: AnySchedulerOf<DispatchQueue>
        let backgroundQueue: AnySchedulerOf<DispatchQueue>
    }
}
