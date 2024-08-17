import Foundation

public enum ServerType: String {
    case dev // db 개발, api 개발
    case prod // db 상용, api 상용
    
    var baseURL: String {
        switch self {
        case .dev:
            return "devURL"
        case .prod:
            return "prodURL"
        }
    }
}

public class ThisIsNetworkKit {
    public static func something() {
        print("CoreKitImportSuccessed")
    }
    
    static private(set) var serverType: ServerType = {
        if let appEnviroment = Bundle.main.infoDictionary?["App Enviroment"] as? String,
           let serverType = ServerType(rawValue: appEnviroment) {
            return serverType
        }
        assert(false, "App Enviroment가 설정되지 않았습니다")
        return .prod
    }()
    
    public static var thisServer: ServerType {
        return serverType
    }
}
