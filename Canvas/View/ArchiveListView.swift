import Combine
import SwiftUI
import SwiftUIRefresh

struct ArchiveListView: View {
    @ObservedObject var workListFetcher = WorkListFetcher()
    @State var isRefreshing = false

    var body: some View {
        List {
            ForEach(workListFetcher.works) { item in
                ZStack {
                    NavigationLink(destination: ArchiveDetailView(data: item)) {
                        EmptyView()
                    }
                    .opacity(0.0)
                    .buttonStyle(PlainButtonStyle())

                    ArchiveRow(data: item)
                }
                .listRowSeparator(.hidden)
            }

            if workListFetcher.hasNext {
                HStack {
                    Spacer()
                    ProgressView()
                    Spacer()
                }
                .frame(height: 60)
                .onAppear {
                    workListFetcher.next {}
                }
            }
        }
        .pullToRefresh(isShowing: $isRefreshing) {
            isRefreshing = true
            workListFetcher.initialize(isRefresh: true) {
                self.isRefreshing = false
            }
        }
        .navigationBarTitle("", displayMode: .inline)
        .onAppear {
            workListFetcher.initialize {
                self.isRefreshing = false
            }
        }
    }
}

struct ArchiveRow: View {
    let data: GraphQL.WorkFragment

    private let gridItemLayout = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]

    var body: some View {
        VStack(alignment: .leading) {
            Text(data.id)

            HStack {
                ForEach(data.thumbnails.shuffled().prefix(3)) { thumbnail in
                    RemoteImageView(url: thumbnail.imageUrl)
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: .infinity)
                        .cornerRadius(4)
                }
            }
        }
        .padding(.top, 10)
        .padding(.bottom, 10)
    }
}
