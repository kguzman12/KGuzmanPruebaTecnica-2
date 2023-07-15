//
//  CofiguracionViewController.swift
//  KGuzmanPruebaTecnica
//
//  Created by MacBookMBA2 on 05/07/23.
//

import UIKit
import AVFoundation

class ConfiguracionViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    @IBOutlet weak var vibracionSonido: UISwitch!
    @IBOutlet weak var sonido: UISwitch!
    @IBOutlet weak var vibracion: UISwitch!
    @IBOutlet weak var listSonidos: UITextField!
    @IBOutlet weak var listVibracion: UITextField!
    @IBOutlet weak var btnSaveTemporaly: UIButton!
    
    var listAudio: [AVAudioPlayer] = []
    var audioPlayer: AVAudioPlayer?
    
    let light = UIImpactFeedbackGenerator(style: .light)
    let medium = UIImpactFeedbackGenerator(style: .medium)
    let heavy = UIImpactFeedbackGenerator(style: .heavy)
    
    var firstListData = ["A huge dragon", "Let Her Go", "Save Your Tears"]
    var secondListData = ["Light", "Medium", "Heavy"]
    
    var indexSonido: Int = 0
    var indexVibracion: Int = 0
    
    var userDefaultSonido: String = ""
    var userDefaultVibracion: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        vibracionSonido.addTarget(self, action: #selector(selectSwith(_:)), for: .valueChanged)
        sonido.addTarget(self, action: #selector(selectSwith(_:)), for: .valueChanged)
        vibracion.addTarget(self, action: #selector(selectSwith(_:)), for: .valueChanged)
        
        listSonidos.text = userDefaultSonido
        
        configSwitch()
        configPickerView()
        configBtn()
        loadAvAudioSession()
        // loadSounds()
        prepareVibracion()
        recuperaUserDefault()
    }
    
    func configSwitch() {
        self.vibracionSonido.isOn = false
        self.sonido.isOn = false
        self.vibracion.isOn = false
        self.listVibracion.isEnabled = false
        self.listSonidos.isEnabled = false
    }
    
    func configPickerView() {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        listSonidos.inputView = pickerView
        
        let pickerView2 = UIPickerView()
        pickerView2.delegate = self
        pickerView2.dataSource = self
        listVibracion.inputView = pickerView2
        
        pickerView.tag = 1
        pickerView2.tag = 2
    }
    
    func configBtn() {
        self.btnSaveTemporaly.layer.cornerRadius = 20
        self.btnSaveTemporaly.layer.masksToBounds = false
        self.btnSaveTemporaly.layer.shadowColor = UIColor.gray.cgColor
        self.btnSaveTemporaly.layer.shadowOpacity = 0.6
        self.btnSaveTemporaly.layer.shadowOffset = CGSize(width: -1, height: 1)
        self.btnSaveTemporaly.layer.shadowRadius = 4
    }
    
    @objc func selectSwith(_ sender : UISwitch){
        if sender == vibracionSonido {
            listSonidos.isEnabled = true
            listVibracion.isEnabled = true
            
            vibracion.isOn = false
            sonido.isOn = false
        }
        else if sender == vibracion {
            listSonidos.isEnabled = false
            listVibracion.isEnabled = true
            
            vibracionSonido.isOn = false
            sonido.isOn = false
            listSonidos.text = ""
        }
        else if sender == sonido {
            listSonidos.isEnabled = true
            listVibracion.isEnabled = false
            
            vibracionSonido.isOn = false
            vibracion.isOn = false
            listVibracion.text = ""
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return firstListData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return firstListData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 1 {
            listSonidos.text = firstListData[row]
            indexSonido = row
            // print(indexSonido)
            if indexSonido == 0 {
                loadSoundFirst()
                audioPlayer?.play()
            } else if indexSonido == 1 {
                loadSoundSecond()
                audioPlayer?.play()
            } else {
                loadSoundThird()
                audioPlayer?.play()
            }
            
            listSonidos.resignFirstResponder()
        } else if pickerView.tag == 2 {
            listVibracion.text = secondListData[row]
            indexVibracion = row
            // print(indexVibracion)
            if indexVibracion == 0 {
                light.impactOccurred()
            } else if indexVibracion == 1 {
                medium.impactOccurred()
            } else {
                heavy.impactOccurred()
            }
            
            listVibracion.resignFirstResponder()
        }
    }
    
    func loadAvAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
            try AVAudioSession.sharedInstance().setActive(true, options: [])
        } catch {
            print("Error al configurar AVAudioSession: \(error.localizedDescription)")
        }
    }
    
    /*func loadSounds() {
        guard let soundURL1 = Bundle.main.url(forResource: "A huge dragon", withExtension: "mp3") else { return }
        guard let soundURL2 = Bundle.main.url(forResource: "Let Her Go", withExtension: "mp3") else { return }
        guard let soundURL3 = Bundle.main.url(forResource: "Save Your Tears", withExtension: "mp3") else { return }
        
        do {
            let sound1 = try AVAudioPlayer(contentsOf: soundURL1)
            let sound2 = try AVAudioPlayer(contentsOf: soundURL2)
            let sound3 = try AVAudioPlayer(contentsOf: soundURL3)
            
            listAudio = [sound1, sound2, sound3]
        } catch {
            print("Error loading sounds: \(error.localizedDescription)")
        }
    }
    
    func playSound(at index: Int) {
        guard index >= 0 && index < listAudio.count else { return }
        // print(listAudio[index])
        let audioPlayer = listAudio[index]
        audioPlayer.play()
    }
    */
    
    func loadSoundFirst() {
        guard let soundURL1 = Bundle.main.url(forResource: "A huge dragon", withExtension: "mp3") else {
            return
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL1)
        } catch {
            print("Error al crear el reproductor de audio: \(error.localizedDescription)")
        }
    }
    
    func loadSoundSecond() {
        guard let soundURL2 = Bundle.main.url(forResource: "Let Her Go", withExtension: "mp3") else {
            return
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL2)
        } catch {
            print("Error al crear el reproductor de audio: \(error.localizedDescription)")
        }
    }
    
    func loadSoundThird() {
        guard let soundURL3 = Bundle.main.url(forResource: "Save Your Tears", withExtension: "mp3") else {
            return
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL3)
        } catch {
            print("Error al crear el reproductor de audio: \(error.localizedDescription)")
        }
    }
    
    func prepareVibracion() {
        light.prepare()
        medium.prepare()
        heavy.prepare()
    }
    
    @IBAction func btnSaveTemporaly(_ sender: Any) {
        saveTemporaly(sonido: listSonidos.text, vibracion: listVibracion.text)
    }
    
    func saveTemporaly(sonido: String?, vibracion: String?) {
        // print(listSonidos.text, listVibracion.text)
        
        let defaults = UserDefaults.standard
        
        if sonido != "" {
            defaults.set(listSonidos.text, forKey: "sonidoAlarma")
        } else {
            defaults.set(listSonidos.text, forKey: "sonidoAlarma")
        }
        
        if vibracion != "" {
            defaults.set(listVibracion.text, forKey: "vibracionAlarma")
        } else {
            defaults.set(listVibracion.text, forKey: "vibracionAlarma")
        }
        
        defaults.synchronize()
        
        let alertController = UIAlertController(title: "Mensaje", message: "Configuración guardada correctamente", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Aceptar", style: .default)
        alertController.addAction(okAction)

        present(alertController, animated: true, completion: nil)
    }
    
    func recuperaUserDefault() {
        let defaults = UserDefaults.standard
        
        userDefaultSonido = defaults.string(forKey: "sonidoAlarma") ?? ""
        userDefaultVibracion = defaults.string(forKey: "vibracionAlarma") ?? ""
        indexSonido = defaults.integer(forKey: "indexSonido")
        indexVibracion = defaults.integer(forKey: "indeVibracion")
        // print(indexVibracion)
        
        if userDefaultSonido == "" {
            listSonidos.text = ""
            sonido.isOn = false
            listSonidos.isEnabled = false
        } else {
            // print(userDefaultSonido)
            listSonidos.text = userDefaultSonido
            sonido.isOn = true
            listSonidos.isEnabled = true
        }
        
        if userDefaultVibracion == "" {
            listVibracion.text = ""
            vibracion.isOn = false
            listVibracion.isEnabled = false
        } else {
            listVibracion.text = userDefaultVibracion
            vibracion.isOn = true
            listVibracion.isEnabled = true
        }
    }
}


