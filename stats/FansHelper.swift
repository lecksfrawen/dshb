//
//  FansHelper.swift
//  stats
//
//  Created by Lecksfrawen on 8/13/20.
//  Copyright © 2020 Lecksfrawen. All rights reserved.
//

import Foundation

// MARK: - Fans

/// Gets the information for the fans
///
/// Format: `[["fan name", "rpm"]]`
/// Output:
/// ```json
/// "fans": [
///  [
///    "Exhaust", #fan name
///    "1795rpm", #rpm
///  ]
///]
/// ```
func getFans() -> [[FanOrTemp]] {
  var fanList: [[FanOrTemp]] = []
  
  let fanCount: Int
  do    { fanCount = try SMCKit.fanCount() }
  catch { fanCount = 0 }
  
  for index in 0..<fanCount {
    // Not sorting fan names, most will not have more than 2 anyway
    let fanName: String
    do    { fanName = try SMCKit.fanName(index) }
    catch { fanName = "Fan \(index)" }
    
    
    let fanMaxSpeed: Int
    do {
      fanMaxSpeed = try SMCKit.fanMaxSpeed(index)
    } catch {
      continue
    }
    
    let singleFan: [FanOrTemp] = [
      FanOrTemp.string(fanName),
      FanOrTemp.string("\(fanMaxSpeed)rpm"),
      FanOrTemp.double(0.0)
    ]
    fanList.append(singleFan)
  }
  return fanList
}
