import Vapor
import NemID

extension Application {
    public var nemid: NemID {
        .init(application: self)
    }
    
    public struct NemID {
        final class Storage {
            var makeLoginService: ((Application) -> NemIDLoginService)?
            var configuration: NemIDConfiguration?
            init() {}
        }
        
        struct Key: StorageKey {
            typealias Value = Storage
        }
        
        let application: Application
        
        var storage: Storage {
            if application.storage[Key.self] == nil {
                initialize()
            }
            return application.storage[Key.self]!
        }
        
        func initialize() {
            application.storage[Key.self] = .init()
            
            application.nemid.logins.use(.live)
        }
        
        public var configuration: NemIDConfiguration {
            get {
                guard let config = storage.configuration else {
                    fatalError("NemID configuration not found, use: app.nemid.configuration = ")
                }
                return config
            }
            nonmutating set {
                storage.configuration = newValue
            }
        }
    }
}

// MARK: LoginService
extension Application.NemID {
    public struct Logins {
        public struct Provider {
            let run: (Application) -> Void
            
            public init(_ run: @escaping (Application) -> Void) {
                self.run = run
            }
            
            public static var live: Self {
                .init { app in
                    app.nemid.logins.use {
                        LiveNemIDLoginService(
                            eventLoop: $0.eventLoopGroup.next(),
                            httpClient: $0.http.client.shared,
                            logger: $0.logger,
                            configuration: $0.nemid.configuration
                        )
                    }
                }
            }
        }
        
        private let nemID: Application.NemID
        
        init(_ nemID: Application.NemID) {
            self.nemID = nemID
        }
        
        public func use(_ makeService: @escaping (Application) -> NemIDLoginService) {
            nemID.storage.makeLoginService = makeService
        }
        
        public func use(_ provider: Provider) {
            provider.run(nemID.application)
        }
    }
    
    public var logins: Logins {
        .init(self)
    }
    
    public var login: NemIDLoginService {
        guard let factory = storage.makeLoginService else {
            fatalError("NemID login service not configured. Use app.nemid.use()")
        }
        return factory(application)
    }
}
