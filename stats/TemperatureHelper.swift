//
//  TemperatureHelper.swift
//  stats
//
//  Created by hdb on 8/14/20.
//  Copyright © 2020 Lecksfrawen. All rights reserved.
//

import Foundation


func getTemperature() -> [[FanOrTemp]] {
  var sensors: [TemperatureSensor] = []
  
  do {
    // TODO: Add battery temperature from SystemKit? SMC will usually
    //       have a key for it too (though not always certain which one)
    let allKnownSensors = try SMCKit.allKnownTemperatureSensors().sorted
    { $0.name < $1.name }
    
    let allUnknownSensors: [TemperatureSensor]
    if true {
      allUnknownSensors = try SMCKit.allUnknownTemperatureSensors()
    } else { allUnknownSensors = [ ] }
    
    sensors = allKnownSensors + allUnknownSensors
  } catch {
    // TODO: Have some sort of warning message under temperature widget
    sensors = [ ]
  }
  
  var result: [[FanOrTemp]] = []
  
  for (i, sensor) in sensors.enumerated() {
    let name: String
    if sensor.name == "Unknown" {
      name = sensor.name + " (\(sensor.code.toString()))"
    } else {
      name = sensor.name
    }
    
    let value: Double = (try? SMCKit.temperature(sensors[i].code)) ?? 0
    
    result.append([
      FanOrTemp.string(name),
      FanOrTemp.string(String(value)),
      FanOrTemp.double(0.0)
    ])
  }
  
  return result
}
