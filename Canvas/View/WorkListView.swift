import SwiftUI

struct WorkListView: View {
    private let gridItemLayout = [
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]

    var body: some View {
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
    }
}
