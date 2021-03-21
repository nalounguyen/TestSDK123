//
//  Enums.swift
//  CredifyKit
//
//  Created by Nalou Nguyen on 16/03/2021.
//  Copyright © 2021 Credify. All rights reserved.
//

import Foundation
@_implementationOnly import CredifyCore


//MARK: Metadata for dynamic type
public enum MetadataType: Codable {
    case int(Int)
    case double(Double)
    case string(String)
    case bool(Bool)
    
    var ccModel: CCMetadataType {
        switch self {
        case .int(let value):
            return CCMetadataType.int(value)
        case .double(let value):
            return CCMetadataType.double(value)
        case .string(let value):
            return CCMetadataType.string(value)
        case .bool(let value):
            return CCMetadataType.bool(value)
        }
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        do {
            self = try .int(container.decode(Int.self))
        } catch DecodingError.typeMismatch {
            
            do {
                self = try .double(container.decode(Double.self))
            } catch DecodingError.typeMismatch {
                
                do {
                    self = try .string(container.decode(String.self))
                } catch DecodingError.typeMismatch {
                    
                    do {
                        self = try .bool(container.decode(Bool.self))
                    } catch DecodingError.typeMismatch {
                        throw DecodingError.typeMismatch(MetadataType.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Encoded payload not of an expected type"))
                    }
                }
            }
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .int(let int):
            try container.encode(int)
        case .double(let double):
            try container.encode(double)
        case .string(let string):
            try container.encode(string)
        case .bool(let bool):
            try container.encode(bool)
        }
    }
    
    public func toString() -> String {
        switch self {
        case .int(let value):
            return "\(value)"
        case .double(let value):
            return "\(value)"
        case .string(let value):
            return "\(value)"
        case .bool(let value):
            return "\(value)"
        }
    }
    
    public var orignalValue: Any {
        switch self {
        case .int(let value):
            return value
        case .double(let value):
            return value
        case .string(let value):
            return value
        case .bool(let value):
            return value
        }
    }
    
    static func convert(from value: CCMetadataType) -> MetadataType {
        switch value {
        case .int(let value):
            return MetadataType.int(value)
        case .double(let value):
            return MetadataType.double(value)
        case .string(let value):
            return MetadataType.string(value)
        case .bool(let value):
            return MetadataType.bool(value)
        }
    }
}


public enum EnvironmentType {
    case DEV, SIT, UAT, SANDBOX, PRODUCTION
    
    var ccObject: CCEnvironmentType {
        switch self {
        case .DEV: return .DEV
        case .SIT: return .SIT
        case .UAT: return .UAT
        case .SANDBOX: return .SANDBOX
        case .PRODUCTION: return .PRODUCTION
        }
    }
}
