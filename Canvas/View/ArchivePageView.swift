import ComposableArchitecture
import SwiftUI
import SwiftUIPager

struct ArchivePageView: View {
    let store: Store<ArchivePageVM.State, ArchivePageVM.Action>

    var body: some View {
        WithViewStore(store) { viewStore in
            VStack {
                Picker("", selection: viewStore.binding(
                    get: \.currentSelection,
                    send: ArchivePageVM.Action.changePage
                )) {
                    Text("ワーク").tag(0)
                    Text("フレーム").tag(1)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(EdgeInsets(top: 0, leading: 12, bottom: 0, trailing: 12))

                Pager(
                    page: viewStore.currentPage,
                    data: viewStore.pageIndexes,
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
                                    state: { $0.frameListView },
                                    action: ArchivePageVM.Action.frameListView
                                ),
                                then: FrameListView.init(store:)
                            )
                        }
                    }
                )
                .onPageChanged { index in
                    viewStore.send(.changePage(index))
                }
            }
        }
    }
}
