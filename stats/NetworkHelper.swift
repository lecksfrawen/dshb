//
//  NetworkUsage.swift
//  stats
//
//  Created by hdb on 8/13/20.
//  Copyright © 2020 beltex. All rights reserved.
//

import Foundation
import NetUtils

//print("\n-- SYSTEM --")
//print("\tMODEL:           \(System.modelName())")
//
////let names = System.uname()
////print("\tSYSNAME:         \(names.sysname)")
////print("\tNODENAME:        \(names.nodename)")
////print("\tRELEASE:         \(names.release)")
////print("\tVERSION:         \(names.version)")
////print("\tMACHINE:         \(names.machine)")
//

/**
 ```json
 "network": [
     [
     "FC75230E-0D38-4FCD-9566-6D586B93F36F",
     "Bluetooth-Modem",
     "Modem",
     ],
     [
     "2B4DCB9E-6B6D-451D-BB86-839A167CDDD9",
     "en0",
     "Ethernet",
     "10.5.1.88",
     "Ethernet"
     ]
 ],
 ```
 */
func getNetwork() -> [[String]] {
  var result: [[String]] = []
  let interfaces = NetUtils.Interface.allInterfaces()
  for interface in interfaces {
    if interface.isUp == false
        || interface.isRunning == false
        || interface.isLoopback
        || interface.family != .ipv4 {
      continue
    }
    let interfaceDataList: [String] = [
      "00000000-0000-0000-0000-000000000000",
      interface.name,
      interface.family.toString(),
      interface.address ?? "",
    ]
    result.append(interfaceDataList)
  }
  return result
}
