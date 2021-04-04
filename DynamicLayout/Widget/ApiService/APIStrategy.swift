
protocol APIStrategy {
    func fetchData(completion: @escaping (Result<LayoutModel, DLError>) -> Void)
}

enum DLError: Error {
    case customError

    var localizedDescription: String {
        switch self {
        case .customError:
            return "Something went wrong please try again..."
        }
    }
}
