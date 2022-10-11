//
//  ViewController.swift
//  iBeaconDemo
//
//  Created by Admin on 10/10/22.
//

import UIKit
import CoreBluetooth
import CoreLocation

// MARK: - Transmitter
extension ViewController: CBPeripheralManagerDelegate {
    private func transmitter() {
        let transmitter = Transmitter.init().setUp(vc: self)
        peripheralManager = transmitter.0
        peripheralData = transmitter.1 as? [String: Any]
    }
    
    /// For Transimitter app
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        if peripheral.state == .poweredOn {
//            peripheralManager?.startAdvertising(peripheralData ?? [:])
        }
    }
}

// MARK: - Default app is Receiver app

// MARK: - Transmitter App
/// 1. Please uncomment Transmitter related code
/// 2. Comment Receiver related code, only viewDidLoad function code

// MARK: - Receiver App
/// 1. Please uncomment Receiver related, only viewDidLoad function code
/// 2. Comment Transmitter related code

class ViewController: UIViewController {

    // MARK: - Transmitter
    var peripheralManager: CBPeripheralManager? = nil
    var peripheralData: [String: Any]? = nil
    
    // MARK: - Receiver
    var locationManager: CLLocationManager? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// Receiver App
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestWhenInUseAuthorization()
        
        /// Transmitter App
        // transmitter()
    }
    
    func startScanning() {
        let beaconObj = Transmitter.beaconRegion()

        locationManager?.startMonitoring(for: beaconObj)
        locationManager?.startRangingBeacons(satisfying: beaconObj.beaconIdentityConstraint)
    }
}

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error: \(error.localizedDescription)")
    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable() {
                    startScanning()
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        if beacons.count > 0 {
            updateDistance(beacons[0].proximity)
        } else {
            updateDistance(.unknown)
        }
    }
    
    func updateDistance(_ distance: CLProximity) {
        UIView.animate(withDuration: 0.8) {
            switch distance {
            case .unknown:
                self.view.backgroundColor = UIColor.gray

            case .far:
                self.view.backgroundColor = UIColor.blue

            case .near:
                self.view.backgroundColor = UIColor.orange

            case .immediate:
                self.view.backgroundColor = UIColor.red

            @unknown default:
                self.view.backgroundColor = UIColor.white
            }
        }
    }
}
