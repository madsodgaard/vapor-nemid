import Vapor
import NemID

extension NemIDResponseError: DebuggableError {
    public var identifier: String {
        self.rawValue
    }
    
    public var reason: String {
        self.englishDescrption
    }
}
