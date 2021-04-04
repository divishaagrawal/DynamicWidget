import Foundation

// MARK: - LayoutModel

struct LayoutModel: Codable {
    let states: [[String]]
    let attributes: [String]
    let viewModel: [ViewModel]

    // MARK: - ViewModel

    struct ViewModel: Codable {
        let title: String
        let subtitle, button, alert: String?
    }
}
