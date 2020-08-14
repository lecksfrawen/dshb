//
//  DiskHelper.swift
//  stats
//
//  Created by Lecksfrawen on 8/13/20.
//  Copyright © 2020 Lecksfrawen. All rights reserved.
//

import Foundation

// MARK: - Disk

/// A list of lists, each list containing the data of a disk
///
/// Format: `[["name", "use", "free"]]`
/// Output:
/// ```json
/// "diskUsage":[
///   [
///     "eticloud.com_Yosemite",
///     "276.5<span class='size'>GB</span>",
///     "42.63<span class='size'>GB</span>"
///   ]
/// ]
/// ```
func getDiskUsage() -> [[String]] {
  // TODO: @hectorddmx: Check how to get HD data
  return [
    [
      "HD",
      "0",
      "0.0<span class='size'>GB</span>",
      "0.0<span class='size'>GB</span>"
    ]
  ]
}
