@testable import DynamicLayout
import XCTest

class ViewBuilderTest: XCTestCase {
    var viewBuilder: ViewBuilder!
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        viewBuilder = ViewBuilder()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        viewBuilder = nil
    }
}

extension ViewBuilderTest {
    func test_addAttribute() {
        viewBuilder.addAttribute(Attributes.button)
        XCTAssertEqual(viewBuilder.attributes[0], Attributes.button)
    }

    func test_setFrame() {
        let frame = CGRect(x: 0, y: 0, width: 10, height: 10)
        _ = viewBuilder.setFrame(frame)
        XCTAssertEqual(frame.origin.x, 0)
    }

    func test_setButtonTarget() {
        _ = viewBuilder.setButtonTarget(for: DLWidgetView())
        XCTAssertNotNil(viewBuilder.target)
    }

    func test_setData() {
        let viewModel = LayoutModel.ViewModel(title: "Problem", subtitle: "Author Divisha", button: nil, alert: nil)
        _ = viewBuilder.setData(data: viewModel)
        XCTAssertNotNil(viewBuilder.data?.subtitle)
        XCTAssertEqual(viewBuilder.data?.title, "Problem")
        XCTAssertNil(viewBuilder.data?.alert)
    }

    func test_build() {
        viewBuilder.addAttribute(Attributes.button)
        XCTAssertNotNil(viewBuilder.build())
        XCTAssertEqual(viewBuilder.build().backgroundColor, UIColor.blue)
    }
}
