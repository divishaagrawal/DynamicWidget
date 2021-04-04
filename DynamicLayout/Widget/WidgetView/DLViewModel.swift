import Foundation

enum RepositoryResponse {
    case response(LayoutModel)
    case error(String)
}

final class DLViewModel {
    private let apiService: APIStrategy
    private var result: RepositoryResponse? {
        didSet {
            dataCompletion(result)
        }
    }

    // called after getting the response
    private let dataCompletion: (RepositoryResponse?) -> Void

    init(completion: @escaping (RepositoryResponse?) -> Void) {
        apiService = APIStrategyImpl()
        dataCompletion = completion
    }

    // returns success or error response
    func fetchData() {
        apiService.fetchData { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(value):
                self.result = .response(value)
            case let .failure(error):
                self.result = .error(error.localizedDescription)
            }
        }
    }
}
