//
//  PickerDelegate.swift
//  KGuzmanPruebaTecnica
//
//  Created by MacBookMBA2 on 10/07/23.
//

import UIKit
import AVFoundation

class PickerDelegate: NSObject, UIPickerViewDelegate, UIPickerViewDataSource {
    var dataList: [AVAudioPlayer] = []
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return dataList.description
    }
}
