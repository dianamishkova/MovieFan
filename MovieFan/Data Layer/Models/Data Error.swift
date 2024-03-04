//
//  Data Error.swift
//  MovieFan
//
//  Created by Диана Мишкова on 11.01.24.
//

import Foundation

enum DataError: Error {
    case networkingError(String)
    case coreDataError(String)
}
