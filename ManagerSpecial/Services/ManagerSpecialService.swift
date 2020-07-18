//
//  ServiceImp.swift
//  ManagerSpecial
//
//  Created by Ye Ma on 7/17/20.
//  Copyright © 2020 Ye Ma. All rights reserved.
//

import Foundation

enum ServiceError {
    case Client
    case Server
    case JSON
    
    var description: String {
        switch self {
        case .Client:
            return "Client error"
        case .Server:
            return "Service error"
        case .JSON:
            return "Incorrect JSON format"
        }
    }
}

enum ServiceStatus {
    case SUCCESS(ManagerSpecialResponse)
    case FAILURE(ServiceError)
}

protocol ManagerSpecialService: AnyObject {
    func fetch(_ closure: @escaping (ServiceStatus) -> Void)
}

final class ManagerSpecialServiceImpl: ManagerSpecialService {
    
    private let url: URL
    
    init() {
        url = URL(string: "https://raw.githubusercontent.com/Swiftly-Systems/code-exercise-ios/master/backup")!
    }
    
    func fetch(_ closure: @escaping (ServiceStatus) -> Void) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil || data == nil {
                closure(.FAILURE(.Client))
                return
            }
            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                closure(.FAILURE(.Server))
                return
            }

            guard let data = data else {
                closure(.FAILURE(.JSON))
                return
            }

            let decoder = JSONDecoder()
            if let managerSpecials = try? decoder.decode(ManagerSpecialResponse.self, from: data) {
                closure(.SUCCESS(managerSpecials))
            } else {
                closure(.FAILURE(.JSON))
            }

        }.resume()
    }
}
