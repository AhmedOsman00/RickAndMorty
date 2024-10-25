final class Container {
    static let shared = Container()
    private var dependenciesFactory = [String: () -> Any]()
    private var sharedDependencies = [String: Any]()

    private init() { }

    @MainActor func register<Dependency>(
        _ type: Dependency.Type,
        _ objectScope: ObjectScope = .transient,
        _ factory: @escaping (Container) -> Dependency
    ) {
        switch objectScope {
        case .singleton:
            sharedDependencies["\(type)"] = factory(Self.shared)
        case .transient:
            dependenciesFactory["\(type)"] = {
                factory(Self.shared)
            }
        }
    }

    func resolve<Dependency>(_ type: Dependency.Type) -> Dependency {
        if let dependency = sharedDependencies["\(type)"] as? Dependency {
            return dependency
        }

        if let dependency = dependenciesFactory["\(type)"]?() as? Dependency {
            return dependency
        }

        fatalError("Dependency not found for type \(type)")
    }

    func resolved<Dependency>() -> Dependency {
        return resolve(Dependency.self)
    }
}

enum ObjectScope {
    case singleton
    case transient
}
