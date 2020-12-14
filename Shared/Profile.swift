//
//  Profile.swift
//  Profiles
//
//  Created by Yan on 2020/12/11.
//

import Foundation

public struct ProvisioningProfile: Hashable, Codable, Equatable {
    
    enum CodingKeys: String, CodingKey {
        case appIdName = "AppIDName"
        case applicationIdentifierPrefixs = "ApplicationIdentifierPrefix"
        case creationDate = "CreationDate"
        case platforms = "Platform"
        case expirationDate = "ExpirationDate"
        case name = "Name"
        case provisionedDevices = "ProvisionedDevices"
        case teamIdentifiers = "TeamIdentifier"
        case teamName = "TeamName"
        case timeToLive = "TimeToLive"
        case uuid = "UUID"
        case version = "Version"
        case entitlements = "Entitlements"
    }
    
    public var url: URL?
    
    public var appIdName: String
    
    public var applicationIdentifierPrefixs: [String]
    
    public var creationDate: Date
    
    public var platforms: [String]
    
    public var expirationDate: Date
    
    public var name: String
    
    public var provisionedDevices: [String]?
    
    public var teamIdentifiers: [String]
    
    public var teamName: String
    
    public var timeToLive: Int
    
    public var uuid: String
    
    public var version: Int
    
    public var entitlements: [String: PListDictionaryValue]
    
    var bundleIdentifier: String {
        switch entitlements["application-identifier"] {
        case .string(let value):
            return value
        default:
            return ""
        }
    }
    
    var teamIdentifier: String {
        switch entitlements["com.apple.developer.team-identifier"] {
        case .string(let value):
            return value
        default:
            return ""
        }
    }
}

public enum PListDictionaryValue: Hashable, Codable, Equatable {
    
    case string(String)
    case bool(Bool)
    case array([PListDictionaryValue])
    case unknown
    
    public init(from decoder: Decoder) throws {
        
        let container = try decoder.singleValueContainer()
        
        if let string = try? container.decode(String.self) {
            self = .string(string)
        } else if let bool = try? container.decode(Bool.self) {
            self = .bool(bool)
        } else if let array = try? container.decode([PListDictionaryValue].self) {
            self = .array(array)
        } else {
            self = .unknown
        }
        
    }
    
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.singleValueContainer()
        
        switch self {
        case .string(let string):
            try container.encode(string)
        case .bool(let bool):
            try container.encode(bool)
        case .array(let array):
            try container.encode(array)
        case .unknown:
            break
        }
        
    }
    
}
