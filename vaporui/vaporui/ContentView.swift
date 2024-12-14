import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = UserViewModel()

    var body: some View {
        NavigationView {
            VStack {
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                }

                List(viewModel.users) { user in
                    Text(user.name)
                }
                .navigationTitle("Users")

                Button(action: {
                    viewModel.fetchUsers()
                }) {
                    Text("Fetch Users")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .padding(.horizontal)
                }
            }
        }
        .onAppear {
            viewModel.fetchUsers()
        }
    }
}
