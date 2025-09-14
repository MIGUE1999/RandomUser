import SwiftUI

struct RandomUsersListView: View {
    @StateObject private var viewModel = RandomUsersViewModel()

    var body: some View {
        NavigationView {
            ZStack {
                List {
                    ForEach(viewModel.filteredUsers, id: \.self) { user in
                        NavigationLink(destination: UserDetailView(user: user)) {
                            UserRowView(user: user)
                        }
                        .onAppear {
                            if user == viewModel.filteredUsers.last && viewModel.searchText.isEmpty {
                                viewModel.loadUsers()
                            }
                        }
                        .swipeActions(edge: .trailing) {
                            Button(role: .destructive) {
                                if let index = viewModel.filteredUsers.firstIndex(of: user) {
                                    viewModel.deleteUser(at: index)
                                }
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                    }

                    if viewModel.isLoading && !viewModel.filteredUsers.isEmpty && viewModel.searchText.isEmpty {
                        HStack {
                            Spacer()
                            ProgressView()
                            Spacer()
                        }
                    }
                }
                .listStyle(PlainListStyle())
                .navigationTitle("Users")
                .searchable(text: $viewModel.searchText, placement: .navigationBarDrawer(displayMode: .automatic))

                if viewModel.isLoading && viewModel.filteredUsers.isEmpty && viewModel.searchText.isEmpty {
                    Color.black.opacity(0.1)
                        .ignoresSafeArea(.all)

                    ProgressView("Loading...")
                        .progressViewStyle(CircularProgressViewStyle())
                        .scaleEffect(1.5)
                }
            }
        }
        .onAppear {
            viewModel.loadUsers()
        }
        .alert("Error", isPresented: Binding<Bool>(
            get: { viewModel.errorMessage != nil },
            set: { newValue in
                if !newValue {
                    viewModel.errorMessage = nil
                }
            }
        ), actions: {
            Button("OK", role: .cancel) {
                viewModel.errorMessage = nil
            }
        }, message: {
            Text(viewModel.errorMessage ?? "Unknown error")
        })
    }
}
