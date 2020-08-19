//
//  NetworkHelper.swift
//  stats
//
//  Created by Lecksfrawen on 8/13/20.
//  Copyright © 2020 Lecksfrawen. All rights reserved.
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

func getNetwork() -> [[Network]] {
  guard let networkData = MobileHelpers.systemInfo["network"] as? [[Any]]
  else {
    return []
  }
  
  var result: [[Network]] = []
  for interface in networkData {
    var singleInterface: [Network] = []
    for value in interface {
      if let text: String = value as? String {
        singleInterface.append(Network.string(text))
      }
      if let textArray: [String] = value as? [String] {
        singleInterface.append(Network.stringArray(textArray))
      }
    }
    result.append(singleInterface)
  }
  return result
}
