//
//  Constants.swift
//  Sportify
//
//  Created by Hadir on 25/04/2024.
//

import Foundation
struct Constants {
    struct API {
        static let baseURL = "https://apiv2.allsportsapi.com/"
        static let key = "92daa8a2d3884b16e98b5882ce3bd20c2f107ba40f31b6e969780b7ed275893e"
        struct Endpoints{
            static let basketball = "basketball"
            static let football = "football"
            static let cricket = "cricket"
            static let tennis = "tennis"
        }
    }
}
enum HTTPHeaderField: String {
    case contentType = "Content-Type"
    case acceptType = "Accept"
    case acceptEncoding = "Accept-Encoding"
}

enum ContentType: String {
    case json = "application/json"
}
