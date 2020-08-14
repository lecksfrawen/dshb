//
//  SystemProfilerHelper.swift
//  stats
//
//  Created by hdb on 8/13/20.
//  Copyright © 2020 beltex. All rights reserved.
//

import Foundation

let sp = SystemProfiler()

enum SPDataTypes: String, CaseIterable {
  //MARK: - Interested
  
  // BootTime?
  case DiagnosticsDataType = "SPDiagnosticsDataType"
  
  // Connected storage devices and info
  case StorageDataType = "SPStorageDataType"
  
  // Graphic Cards and connected displays (noise)
  case DisplaysDataType = "SPDisplaysDataType"
  
  // Connected Ethernet Cards, mine starts with "Apple..."
  case EthernetDataType = "SPEthernetDataType"
  
  // Memory information, syze, type, serial number, status, speed, manufacturer, model
  case MemoryDataType = "SPMemoryDataType"
  
  // All network interfaces
  case NetworkDataType = "SPNetworkDataType"
  
  // Hmmm similar to above
  case NetworkLocationDataType = "SPNetworkLocationDataType"
  
  // Power information and configuration
  case PowerDataType = "SPPowerDataType"
  
  
//  //MARK: - Uninterested
//
//  // Wi-Fi and nearby networks
//  case AirPortDataType = "SPAirPortDataType"
//
//  // Gets installed apps (noise)
//  case ApplicationsDataType = "SPApplicationsDataType"
//
//  // Gets audio devices (noise)
//  case AudioDataType = "SPAudioDataType"
//
//  // Lists Bluetooth devices (noise)
//  case BluetoothDataType = "SPBluetoothDataType"
//
//  // Connected cameras
//  case CameraDataType = "SPCameraDataType"
//
//  // Connected external cards
//  case CardReaderDataType = "SPCardReaderDataType"
//
//  // Xcode and installed SKD's
//  case DeveloperToolsDataType = "SPDeveloperToolsDataType"
//
//  // Disabled drivers and kernel extensions
//  case DisabledSoftwareDataType = "SPDisabledSoftwareDataType"
//
//  // Connected Disc Burners
//  case DiscBurningDataType = "SPDiscBurningDataType"
//
//  // No output, for audio with fibre?
//  case FibreChannelDataType = "SPFibreChannelDataType"
//
//  // Firewall status and applications allowances
//  case FirewallDataType = "SPFirewallDataType"
//
//  // Firewire connected ports and devices?
//  case FireWireDataType = "SPFireWireDataType"
//
//  // Fonts (noise)
//  case FontsDataType = "SPFontsDataType"
//
//  // System frameworks
//  case FrameworksDataType = "SPFrameworksDataType"
//
//  // System general information
//  case HardwareDataType = "SPHardwareDataType"
//
//  // RAID devices
//  case HardwareRAIDDataType = "SPHardwareRAIDDataType"
//
//  // Applications and updates history
//  case InstallHistoryDataType = "SPInstallHistoryDataType"
//
//  // Mounted network volumes
//  case NetworkVolumeDataType = "SPNetworkVolumeDataType"
//
//  // NVMExpress
//  case NVMeDataType = "SPNVMeDataType"
//
//  // PCI connected devices (including eGPU's)
//  case PCIDataType = "SPPCIDataType"
//
//  // Settings Panes location and config (noise)
//  case PrefPaneDataType = "SPPrefPaneDataType"
//
//  // Connected printers
//  case PrintersDataType = "SPPrintersDataType"
//
//  // Supported printers
//  case PrintersSoftwareDataType = "SPPrintersSoftwareDataType"
//
//  // macOS and system information
//  case SoftwareDataType = "SPSoftwareDataType"
//
//  // Sync services... to what?
//  case SyncServicesDataType = "SPSyncServicesDataType"
//
//  // Thunderbolt interface info
//  case ThunderboltDataType = "SPThunderboltDataType"
//
//  // Accessibility config
//  case UniversalAccessDataType = "SPUniversalAccessDataType"
//
//  // USB interface info
//  case USBDataType = "SPUSBDataType"
//
//
//  //MARK: - Broken or bad output
//
//  case LogsDataType = "SPLogsDataType"
//
//
//  //MARK: - Unknown or empty output
//
//
//  // ???
//  case ComponentDataType = "SPComponentDataType"
//
//  // ???
//  case ConfigurationProfileDataType = "SPConfigurationProfileDataType"
//
//  // ???
//  case ManagedClientDataType = "SPManagedClientDataType"
//
//  // ???
//  case ParallelATADataType = "SPParallelATADataType"
//
//  // ???
//  case ParallelSCSIDataType = "SPParallelSCSIDataType"
//
//  // ???
//  case SASDataType = "SPSASDataType"
//
//  // ???
//  case SerialATADataType = "SPSerialATADataType"
//
//  // ???
//  case SPIDataType = "SPSPIDataType"
//
//  // ???
//  case StartupItemDataType = "SPStartupItemDataType"
//
//  // ???
//  case ExtensionsDataType = "SPExtensionsDataType"
//
//  // ???
//  case WWANDataType = "SPWWANDataType"
}

func printJSONForKey(dataType: SPDataTypes) {
  print(sp.GetJsonString(SPDataType: dataType.rawValue))
}

func printJSONForAllKeys() {
  let spDataTypes = SPDataTypes.allCases

  spDataTypes.forEach { spDataType in
//    print("")
//    print("### START \(spDataType.rawValue) ###")
    print(sp.GetJsonString(SPDataType: spDataType.rawValue))
//    print("### END \(spDataType.rawValue) ###")
//    print("")
  }
}

