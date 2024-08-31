import Foundation
import OpenapiGenerated
import OpenAPIURLSession

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

public class API {
    let client = Client(
        serverURL: URL(string: ServerType.current.baseURL)!,
        transport: URLSessionTransport()
    )
    
    func something() {
        Task {
            do {
                let response = try await client.post_sol_auth_sol_refresh(
                    .init(
                        body: .json(
                            .init(
                                refreshToken: ""
                            )
                        )
                    )
                )
                switch response {
                case .ok(let ok):
                    print(try ok.body.json.accessToken)
                case .unauthorized(let unauthorized):
                    print(unauthorized)
                case .undocumented(let statusCode, let undocumentedPayload):
                    print(statusCode)
                }
            }
        }
    }
}
