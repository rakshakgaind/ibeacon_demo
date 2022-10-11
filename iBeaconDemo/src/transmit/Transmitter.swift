//
//  Transmitter.swift
//  iBeaconDemo
//
//  Created by Admin on 10/10/22.
//

import CoreLocation
import CoreBluetooth
import UIKit

class Transmitter {
    static func beaconRegion() -> CLBeaconRegion {
        return CLBeaconRegion.init(uuid: UUID.init(uuidString: IPHONEX_UUID)!, major: 100, minor: 1, identifier: APP_BUNDLE)
    }
    
    func setUp(vc: ViewController) -> (CBPeripheralManager, NSMutableDictionary) {
        let beaconPeripheral = Transmitter.beaconRegion().peripheralData(withMeasuredPower: nil)
        
        let cbManager = CBPeripheralManager.init(delegate: vc, queue: nil)
        return (cbManager, beaconPeripheral)
    }
}
