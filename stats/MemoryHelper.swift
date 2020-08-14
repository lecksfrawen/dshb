//
//  MemoryHelper.swift
//  stats
//
//  Created by Lecksfrawen on 8/13/20.
//  Copyright © 2020 Lecksfrawen. All rights reserved.
//

import Foundation


// MARK: - Memory

//
//
//print("\n-- MEMORY --")
//print("\tPHYSICAL SIZE:   \(System.physicalMemory())GB")
//

fileprivate func memoryUnit(_ value: Double) -> (value: String, unit: String) {
    if value < 1.0 { return (String(Int(value * 1000.0)), "MB") }
    else           { return (NSString(format:"%.2f", value) as String, "GB") }
}

func getMemory() -> [MemoryUsage] {
  let memoryUsage = System.memoryUsage()
  
  let free = memoryUnit(memoryUsage.free)
  let compressed = memoryUnit(memoryUsage.compressed)
  let active = memoryUnit(memoryUsage.active)
  let inactive = memoryUnit(memoryUsage.inactive)
  let wired = memoryUnit(memoryUsage.wired)
  
  
  return [
    MemoryUsage.string("\(free.value)<span class='size'>\(free.unit)</span>"),
    MemoryUsage.string("\(compressed.value)<span class='size'>\(compressed.unit)</span>"),
    MemoryUsage.string("\(active.value)<span class='size'>\(active.unit)</span>"),
    MemoryUsage.string("\(inactive.value)<span class='size'>\(inactive.unit)</span>"),
    MemoryUsage.string("\(wired.value)<span class='size'>\(wired.unit)</span>"),
    // TODO: check how to get PageIn, PageOut, and SWAP
    MemoryUsage.double(0.0),
    MemoryUsage.stringArray(["0","0"]),
    MemoryUsage.stringArray(["0","0"]),
    MemoryUsage.string("0<span class='size'>MB</span>"),
    MemoryUsage.string("0<span class='size'>MB</span>/1<span class='size'>GB</span>"),
  ]
}
