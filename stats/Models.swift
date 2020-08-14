//
//  Models.swift
//  stats
//
//  Created by Lecksfrawen on 8/13/20.
//  Copyright © 2020 Lecksfrawen. All rights reserved.
//

import Foundation

/**
 Returns this keys line by line, each line defined as JSON
 ```json
 {
     "systatus": {
         "load": "1.18, 1.20, 1.19",
         "fans": [
             [
                 "Exhaust",
                 "1795rpm",
                 41.02642059326172
             ]
         ],
         "uptime": "0d 0h 42m",
         "temps_": [
             [
                 "CPU",
                 "52°",
                 22.723575592041016
             ],
             [
                 "CPU Heatsink",
                 "51°",
                 70.91463470458984
             ],
             [
                 "Airport Card",
                 "44°",
                 63.19105529785156
             ],
             [
                 "Ambient",
                 "37°",
                 42.5
             ],
             [
                 "HD Bay",
                 "36°",
                 37.916664123535156
             ],
             [
                 "Mem Bank A1",
                 "51°",
                 70.60975646972656
             ],
             [
                 "Mem Controller",
                 "43°",
                 79.56300354003906
             ],
             [
                 "Northbridge",
                 "45°",
                 61.575199127197266
             ],
             [
                 "Optical Drive",
                 "38°",
                 66.48373413085938
             ],
             [
                 "Power Supply",
                 "43°",
                 70.34552764892578
             ]
         ],
         "network": [
             [
                 "FC75230E-0D38-4FCD-9566-6D586B93F36F",
                 "Bluetooth-Modem",
                 "Modem"
             ],
             [
                 "2B4DCB9E-6B6D-451D-BB86-839A167CDDD9",
                 "en0",
                 "Ethernet",
                 "10.5.1.88",
                 "Ethernet"
             ]
         ],
         "battery": [],
         "cpuUsage": [
             [
                 7,
                 8,
                 0,
                 85,
                 15
             ],
             [
                 [
                     16,
                     8.759123802185059,
                     8.09555435180664,
                     0
                 ],
                 [
                     15,
                     6.903418064117432,
                     8.264188766479492,
                     0
                 ]
             ]
         ],
         "boottime": "10:20, Aug 10",
         "diskUsage": [
             [
                 "eticloud.com_Yosemite",
                 "87",
                 "276.5<span class='size'>GB</span>",
                 "42.63<span class='size'>GB</span>"
             ]
         ],
         "memoryUsage": [
             "151<span class='size'>MB</span>",
             "637<span class='size'>MB</span>",
             "307<span class='size'>MB</span>",
             "2.80<span class='size'>GB</span>",
             "330<span class='size'>MB</span>",
             17.437721252441406,
             [
                 "715,266",
                 "715,266"
             ],
             [
                 "120",
                 "120"
             ],
             "2.95<span class='size'>GB</span>",
             "5<span class='size'>MB</span>/1.0<span class='size'>GB</span>"
         ]
     }
 }
 ```
 
 For temps, we only care for this info:
 ```json
 "temps_": [
   [
     "CPU",  #temperature Name
     "52°", #temperature Info
     22.723575592041016 # no need
   ]
 ]
 ```
 
 For CPU usage, we only care for this info:
 ```json
 "cpuUsage": [
      [
         7, #CpuSys
         8, #CpuNice
         0, #CpuIdle
         85,  #no need
         15  #no need
      ],
      [  #no need for this array of arrays
        [
          16,
          8.759123802185059,
          8.09555435180664,
          0
        ],
        [
          15,
          6.903418064117432,
          8.264188766479492,
          0
        ]
      ]
    ]
 ```
 
 For fans usage, we only care for this info:
 ```json
 "fans": [
   [
     "Exhaust", #fan name
     "1795rpm", #rpm
     41.02642059326172   #no need
    ]
 ],
 ```
 
 For diskUsage, we only care for this info:
 ```json
 "diskUsage": [
   [
     "eticloud.com_Yosemite",  #Disk name
     "87", #no need
     "276.5<span class='size'>GB</span>", #use
     "42.63<span class='size'>GB</span>"  #free
   ]
 ]
 ```
 */
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
