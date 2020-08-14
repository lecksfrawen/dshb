//
//  Models.swift
//  stats
//
//  Created by hdb on 8/13/20.
//  Copyright © 2020 beltex. All rights reserved.
//

import Foundation

struct SystemData: Codable {
  let systatus: Systatus
}

// MARK: - Systatus
struct Systatus: Codable {
  let load: String
  let fans: [[FanOrTemp]]
  let uptime: String
  let temps: [[FanOrTemp]]
  let network: [[String]]
  let battery: [String]
  let cpuUsage: [[CPUUsage]]
  let boottime: String
  let diskUsage: [[String]]
  let memoryUsage: [MemoryUsage]
  
  enum CodingKeys: String, CodingKey {
    case load, fans, uptime
    case temps = "temps_"
    case network, battery, cpuUsage, boottime, diskUsage, memoryUsage
  }
}

enum CPUUsage: Codable {
  case doubleArray([Double])
  case integer(Int)
  
  init(from decoder: Decoder) throws {
    let container = try decoder.singleValueContainer()
    if let x = try? container.decode(Int.self) {
      self = .integer(x)
      return
    }
    if let x = try? container.decode([Double].self) {
      self = .doubleArray(x)
      return
    }
    throw DecodingError.typeMismatch(CPUUsage.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for CPUUsage"))
  }
  
  func encode(to encoder: Encoder) throws {
    var container = encoder.singleValueContainer()
    switch self {
    case .doubleArray(let x):
      try container.encode(x)
    case .integer(let x):
      try container.encode(x)
    }
  }
}

enum FanOrTemp: Codable {
  case double(Double)
  case string(String)
  
  init(from decoder: Decoder) throws {
    let container = try decoder.singleValueContainer()
    if let x = try? container.decode(Double.self) {
      self = .double(x)
      return
    }
    if let x = try? container.decode(String.self) {
      self = .string(x)
      return
    }
    throw DecodingError.typeMismatch(Fan.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for Fan"))
  }
  
  func encode(to encoder: Encoder) throws {
    var container = encoder.singleValueContainer()
    switch self {
    case .double(let x):
      try container.encode(x)
    case .string(let x):
      try container.encode(x)
    }
  }
}

enum MemoryUsage: Codable {
  case double(Double)
  case string(String)
  case stringArray([String])
  
  init(from decoder: Decoder) throws {
    let container = try decoder.singleValueContainer()
    if let x = try? container.decode([String].self) {
      self = .stringArray(x)
      return
    }
    if let x = try? container.decode(Double.self) {
      self = .double(x)
      return
    }
    if let x = try? container.decode(String.self) {
      self = .string(x)
      return
    }
    throw DecodingError.typeMismatch(MemoryUsage.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for MemoryUsage"))
  }
  
  func encode(to encoder: Encoder) throws {
    var container = encoder.singleValueContainer()
    switch self {
    case .double(let x):
      try container.encode(x)
    case .string(let x):
      try container.encode(x)
    case .stringArray(let x):
      try container.encode(x)
    }
  }
}
