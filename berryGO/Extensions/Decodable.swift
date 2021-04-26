//
//  Decodable.swift
//  berryGO
//
//  Created by Evgeny Gusev on 20.02.2020.
//  Copyright © 2020 DATA5 CORP. All rights reserved.
//

import Foundation

extension Decodable {
  init(_ any: Any) throws {
    let data = try JSONSerialization.data(withJSONObject: any, options: .prettyPrinted)
    let decoder = JSONDecoder()
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:sszzz"
    decoder.dateDecodingStrategy = .formatted(dateFormatter)
    self = try decoder.decode(Self.self, from: data)
  }
}
