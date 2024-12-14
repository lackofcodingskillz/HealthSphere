import Vapor

func routes(_ app: Application) throws {
    app.post("login") { req -> HTTPStatus in
        struct LoginRequest: Content {
            let healthCard: String
        }

        let request = try req.content.decode(LoginRequest.self)

        // Get the current file's directory
        let currentDirectory = URL(fileURLWithPath: #file).deletingLastPathComponent()
        let fileURL = currentDirectory.appendingPathComponent("ids.json")

        // Debug: Log the file path
        app.logger.info("Loading health card data from: \(fileURL.path)")

        // Load the `ids.json` file
        guard let data = try? Data(contentsOf: fileURL) else {
            app.logger.error("Failed to load ids.json. File not found or unreadable.")
            throw Abort(.internalServerError, reason: "Could not load health card data.")
        }

        // Parse the JSON
        guard let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: [String]],
              let healthCards = json["healthCards"] else {
            app.logger.error("Failed to parse ids.json. Invalid JSON structure.")
            throw Abort(.internalServerError, reason: "Could not load health card data.")
        }

        // Check if the health card exists
        return healthCards.contains(request.healthCard) ? .ok : .notFound
    }
}
