import SwiftUI

struct ContentView: View {
    private let gridItemLayout = [
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]
    
    @ObservedObject var authenticator = Authenticator()

    var body: some View {
        NavigationView {
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
        .onAppear {
            authenticator.login()
        }
    }
}
