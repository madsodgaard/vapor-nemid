import XCTVapor
import VaporNemID

final class VaporNemIDTests: XCTestCase {
    func test_defaultServices() throws {
        let app = Application(.testing)
        defer { app.shutdown() }
        
        app.nemid.configuration = .init(spCertificate: "", serviceProviderID: "", environment: .preproduction)
        XCTAssertTrue(app.nemid.login is LiveNemIDLoginService)
    }
}
