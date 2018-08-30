//
//  DataParser.swift
//  FamBam Trainer

// -----------------------
// Swift
// -----------------------

import Foundation

public class MSBLEMachineBroadcast: NSObject {
    public var name = "";
    public var address = "";
    public var realTime = false
    public var takenAt = Date()
    public var ordinalId: Int = 0
    public var buildMajor: Int?
    public var buildMinor: Int?
    public var dataType: Int?
    public var interval: Int?
    public var cadence: Int?
    public var heartRate: Int?
    public var power: Int?
    public var caloricBurn: Int?
    public var duration: TimeInterval?
    public var tripDistance: Double?
    public var gear: Int?
    
    public init(manufactureData: Data) {
        var data = manufactureData
        if (data.count > 17){
            data = data.subdata(in: Range(uncheckedBounds: (lower: 2, upper: data.count)))
        }
        
        var tempDistance: Int32?
        for (index, byte) in data.enumerated(){
            switch index {
            case 0: buildMajor = Int(byte)
            case 1: buildMinor = Int(byte)
            case 2: dataType = Int(byte);
            case 3: ordinalId = Int(byte)
            case 4: cadence = Int(byte)
            case 5: cadence = Int(UInt16(byte) << 8 | UInt16(cadence!))
            case 6: heartRate = Int(byte)
            case 7: heartRate = Int(UInt16(byte) << 8 | UInt16(heartRate!))
            case 8: power = Int(byte)
            case 9: power = Int(UInt16(byte) << 8 | UInt16(power!))
            case 10: caloricBurn = Int(byte)
            case 11: caloricBurn = Int(UInt16(byte) << 8 | UInt16(caloricBurn!))
            case 12: duration = Double(byte) * 60
            case 13: duration = duration! + Double(byte)
            case 14: tempDistance = Int32(byte)
            case 15: tempDistance = Int32(UInt16(byte) << 8 | UInt16(tempDistance!))
            case 16: gear = Int(byte)
            default: break
                
            }
        }
        
        cadence = cadence!/10
        heartRate = heartRate!/10
        
        super.init()
        
        if (dataType! == 0 || dataType! == 255) {
            interval = 0
        }
        else if (dataType! > 0 && dataType! < 128) {
            interval = dataType!
        }
        else if (dataType! > 128 && dataType! < 255) {
            interval = dataType! - 128
        }
        
        realTime = dataType! == 0 || (dataType! > 128 && dataType! < 255)
        
        // Converts tripDistance to miles
        if tempDistance! & 32768 != 0 {
            tripDistance = (Double(tempDistance! & 32767) * 0.62137119) / 10.0
        }
        else {
            tripDistance = Double(tempDistance!) / 10.0
        }
    }
    
    public var scanResult: String {
        get {
            return "scanResult"
        }
    }
    
    public var isValid: Bool {
        get {
            return name.characters.count > 0 && ordinalId > 0
        }
    }
}
