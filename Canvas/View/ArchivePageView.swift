import ComposableArchitecture
import SwiftUI
import SwiftUIPager

struct ArchivePageView: View {
    let store: Store<ArchivePageVM.State, ArchivePageVM.Action>

    var body: some View {
        WithViewStore(store) { viewStore in
            Pager(
                page: viewStore.state.currentPage,
                data: viewStore.state.pageIndexes,
                id: \.hashValue,
                content: { index in
                    if index == 0 {
                        IfLetStore(
                            store.scope(
                                state: { $0.archiveListView },
                                action: ArchivePageVM.Action.archiveListView
                            ),
                            then: ArchiveListView.init(store:)
                        )
                    } else {
                        IfLetStore(
                            store.scope(
                                state: { $0.thumbnailListView },
                                action: ArchivePageVM.Action.thumbnailListView
                            ),
                            then: ThumbnailListView.init(store:)
                        )
                    }
                }
            )
        }
    }
}
