//
//  TestProvider.swift
//  FuzFuz
//
//  Created by Cenker Ozkurt on 10/07/19.
//  Copyright © 2019 Cenker Ozkurt, Inc. All rights reserved.
//

import Foundation

/**
 TestProvider class confirms ProviderProtocol
 as a new networking provider for local json mocking purposes.
 */

public class TestProvider: ProviderProtocol {

    var fileName: String?
    
    // MARK: - Init Methods

    public init() {}
    
    public init(fileName: String) {
        self.fileName = fileName
    }

    // MARK: - Public Methods

    public func request(_ urlRequest: URLRequest?, success: @escaping (String) -> Void, failure: @escaping (Error) -> Void) {
        self.requestFile(urlRequest, success: success, failure: failure)
    }
    
    public var description: String {
        return "Test Provider"
    }

    // MARK: - Private Methods

    fileprivate func requestFile(_ urlRequest: URLRequest?, success: @escaping (String) -> Void, failure: (Error) -> Void) {

        guard let urlRequest = urlRequest, let url = urlRequest.url else {
            let error = NSError(domain: "com.coframework", code: 0, userInfo: ["error": "Invalid URL"])
            failure(error as Error)
            return
        }
        
        let fileName = self.fileName ?? url.deletingPathExtension().lastPathComponent.lowercased()

        let bundle = Bundle(for: TestProvider.self)
        if let path = bundle.path(forResource: fileName, ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: Data.ReadingOptions.alwaysMapped)

                if let dataString = String(data: data, encoding: String.Encoding.utf8) {
                    success(dataString)
                } else {
                    print("json string is empty/no exists")
                }

            } catch let error as NSError {
                print(error.localizedDescription)
            }
        } else {
            print("Invalid filename/path.")
        }
    }
}
