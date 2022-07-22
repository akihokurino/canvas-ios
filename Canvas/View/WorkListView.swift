import ComposableArchitecture
import SwiftUI

struct WorkListView: View {
    private let gridItemLayout = [
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]

    let store: Store<WorkListVM.State, WorkListVM.Action>

    var body: some View {
        WithViewStore(store) { viewStore in
            ScrollView {
                LazyVGrid(columns: gridItemLayout, alignment: HorizontalAlignment.leading, spacing: 2) {
                    ForEach(Work.allCases) { work in
                        NavigationLink(destination: work.canvas) {
                            work.thumbnail
                        }
                    }
                }
            }
            .navigationBarTitle("", displayMode: .inline)
            .onAppear {
                viewStore.send(.onAppear)
            }
        }
    }
}
