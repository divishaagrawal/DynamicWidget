
@testable import DynamicLayout
import XCTest

class DLViewModelTest: XCTestCase {
    var viewModel: DLViewModel!
    var response: RepositoryResponse!
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        viewModel = DLViewModel(completion: setResponse(response:))
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        viewModel = nil
    }

    func setResponse(response: RepositoryResponse?) {
        self.response = response
    }
}

extension DLViewModelTest {
    func test_fetchData() {
        viewModel.fetchData()
        XCTAssertNotNil(response)
    }
}
