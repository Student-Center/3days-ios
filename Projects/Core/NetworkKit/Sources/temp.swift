import Foundation


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
