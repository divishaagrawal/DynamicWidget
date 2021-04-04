import Foundation

class APIStrategyImpl: APIStrategy {
    func fetchData(completion: @escaping (Result<LayoutModel, DLError>) -> Void) {
        // currently fetching data from locally stored json
        let decoder = JSONDecoder()
        do {
            if let data = readJSON(fileName: "mockData") {
                let model = try decoder.decode(LayoutModel.self, from: data)
                completion(.success(model))
            }
        } catch {
            completion(.failure(.customError))
        }
    }

    func readJSON(fileName: String) -> Data? {
        var data: Data?
        if let path = Bundle.main.path(forResource: fileName, ofType: "json") {
            do {
                let fileUrl = URL(fileURLWithPath: path)
                // Getting data from JSON file using the file URL
                data = try Data(contentsOf: fileUrl, options: .mappedIfSafe)
            } catch {
                data = nil
            }
        }
        return data
    }
}
