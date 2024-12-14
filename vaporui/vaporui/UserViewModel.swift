import Foundation

class UserViewModel: ObservableObject {
    @Published var users: [User] = [] // Published property for the user list
    @Published var errorMessage: String? = nil // To handle errors (optional)

    func fetchUsers() {
        // Replace with your Vapor server's URL
        guard let url = URL(string: "http://127.0.0.1:8080/users") else {
            errorMessage = "Invalid URL."
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    self.errorMessage = "Error: \(error.localizedDescription)"
                }
                return
            }

            guard let data = data else {
                DispatchQueue.main.async {
                    self.errorMessage = "No data received."
                }
                return
            }

            do {
                let users = try JSONDecoder().decode([User].self, from: data)
                DispatchQueue.main.async {
                    self.users = users
                    self.errorMessage = nil // Clear any previous errors
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = "Failed to decode JSON: \(error.localizedDescription)"
                }
            }
        }.resume()
    }
}
