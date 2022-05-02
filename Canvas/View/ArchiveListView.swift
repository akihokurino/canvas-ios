import Combine
import SwiftUI
import SwiftUIRefresh

struct ArchiveListView: View {
    @ObservedObject var workIntractor = WorkIntractor()
    @State var isRefreshing = false

    var body: some View {
        List {
            ForEach(workIntractor.works) { item in
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

            if workIntractor.hasNext {
                HStack {
                    Spacer()
                    ProgressView()
                    Spacer()
                }
                .frame(height: 60)
                .onAppear {
                    workIntractor.next {}
                }
            }
        }
        .pullToRefresh(isShowing: $isRefreshing) {
            isRefreshing = true
            workIntractor.initialize(isRefresh: true) {
                self.isRefreshing = false
            }
        }
        .overlay(
            Group {
                if workIntractor.isInitializing {
                    HUD(isLoading: $workIntractor.isInitializing)
                }
            }, alignment: .center
        )
        .navigationBarTitle("", displayMode: .inline)
        .onAppear {
            workIntractor.initialize {
                self.isRefreshing = false
            }
        }
    }
}

struct ArchiveRow: View {
    let data: CanvasAPI.WorkFragment

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
