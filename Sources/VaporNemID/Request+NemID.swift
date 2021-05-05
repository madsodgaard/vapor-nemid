import Vapor
import NemID

extension Request {
    public var nemid: NemID {
        .init(request: self)
    }
    
    public struct NemID {
        let request: Request
        
        public var login: NemIDLoginService {
            request.application.nemid.login
                .delegating(to: request.eventLoop)
                .logging(to: request.logger)
        }
        
        public var matchService: NemIDPIDCPRMatchClient {
            request.application.nemid.matchService
                .delegating(to: request.eventLoop)
                .logging(to: request.logger)
        }
    }
}
