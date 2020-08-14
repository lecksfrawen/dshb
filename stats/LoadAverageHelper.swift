//
//  LoadAverageHelper.swift
//  stats
//
//  Created by hdb on 8/14/20.
//  Copyright © 2020 beltex. All rights reserved.
//

import Foundation


func getLoadAverage() -> String {
  let loadAverage = System.loadAverage()
  let loadAverageString = loadAverage.map{ String($0) }
  let result = loadAverageString.joined(separator: ", ")
  return result
}
