//
//  TimerTimeViewController.swift
//  KGuzmanPruebaTecnica
//
//  Created by MacBookMBA2 on 07/07/23.
//

import UIKit
import CoreMotion
import AVFoundation

class TimerTimeViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var viewContent: UIView!
    @IBOutlet weak var viewOpciones: UIView!
    @IBOutlet weak var btnOpciones: UIButton!
    @IBOutlet weak var containerTime: UILabel!
    @IBOutlet weak var btnDetenerSound: UIButton!
    @IBOutlet weak var horaPicker: UILabel!
    @IBOutlet weak var minutoPicker: UILabel!
    @IBOutlet weak var segundoPicker: UILabel!
    @IBOutlet weak var timePicker: UIPickerView!
    @IBOutlet weak var message: UITextView!
    @IBOutlet weak var btn1: UIButton!
    @IBOutlet weak var btn2: UIButton!
    
    var countDownTimer = Timer()
    var totalTime = 0
    let motionManager = CMMotionManager()
    var audioPlayer: AVAudioPlayer?
    var listAudio: [AVAudioPlayer] = []
    
    let light = UIImpactFeedbackGenerator(style: .light)
    let medium = UIImpactFeedbackGenerator(style: .medium)
    let heavy = UIImpactFeedbackGenerator(style: .heavy)
    
    let horas = Array(0...23)
    let minutos = Array(0...59)
    let segundos = Array(0...59)
    
    var horasPicker: Int = 0
    var minutosPicker: Int = 0
    var segundosPicker: Int = 0
    
    let opciones:[String] = []
    var indexSonido: Int = 4
    var indexVibracion: Int = 4
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timePicker.delegate = self
        timePicker.dataSource = self
        
        timePicker.tag = 0
        timePicker.selectRow(0, inComponent: 0, animated: false)
        
        self.viewOpciones.isHidden = true
        self.btnDetenerSound.isHidden = true
        self.message.isHidden = true
        
        self.containerTime.isHidden = true
        
        loadAvAudioSession()
        prepareVibracion()
        configButton()
        userDefault()
    }
    
    @IBAction func opciones(_ sender: Any) {
        self.viewOpciones.isHidden = !self.viewOpciones.isHidden
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        motionManager.stopAccelerometerUpdates()
    }
    
    func configButton() {
        self.btn1.isHidden = true
        
        self.btn2.setTitle("Aceptar", for: .normal)
        self.btn2.titleLabel?.font = UIFont.systemFont(ofSize: 2)
        self.btn2.layer.cornerRadius = 30
        self.btn2.layer.masksToBounds = false
        self.btn2.layer.shadowColor = UIColor.gray.cgColor
        self.btn2.layer.shadowOpacity = 0.6
        self.btn2.layer.shadowOffset = CGSize(width: -1, height: 1)
        self.btn2.layer.shadowRadius = 4
        
        self.btn1.layer.cornerRadius = 30
        self.btn1.layer.masksToBounds = false
        self.btn1.layer.shadowColor = UIColor.red.cgColor
        self.btn1.layer.shadowOpacity = 0.5
        self.btn1.layer.shadowOffset = CGSize(width: -1, height: 1)
        self.btn1.layer.shadowRadius = 4
    }

    func userDefault() {
        let defaults = UserDefaults.standard
        
        let userDefaultSonido = defaults.string(forKey: "sonidoAlarma") ?? "vacio"
        let userDefaultVibracion = defaults.string(forKey: "vibracionAlarma") ?? "vacio"
        // print(userDefaultSonido, userDefaultVibracion)
        
        if userDefaultSonido == "" {
            
        } else if userDefaultSonido == "A huge dragon" {
            indexSonido = 0
        } else if userDefaultSonido == "Let Her Go" {
            indexSonido = 1
        } else if userDefaultSonido == "Save Your Tears" {
            indexSonido = 2
        }
        
        if userDefaultVibracion == "" {
            
        } else if userDefaultVibracion == "Light" {
            indexVibracion = 0
        } else if userDefaultVibracion == "Medium" {
            indexVibracion = 1
        } else if userDefaultVibracion == "Heavy" {
            indexVibracion = 2
        }
        
        // print(indexSonido)
    }
    
    func acelerometro() {
        if motionManager.isAccelerometerAvailable {
            motionManager.accelerometerUpdateInterval = 0.2
            
            motionManager.startAccelerometerUpdates(to: .main) { (data, error) in
                if let accelerometerData = data {
                    let acceleration = accelerometerData.acceleration
                        let x = acceleration.x
                        let y = acceleration.y
                        let z = acceleration.z

                        print(x, y, z)
                        
                    if (x > 0 || x < 1), y <= 0.0, z <= -1.0 {
                        self.message.isHidden = true
                        self.btn2.isHidden = false
                        self.motionManager.stopAccelerometerUpdates()
                            
                        self.btn1.setTitle("Pausa", for: .normal)
                        self.btn1.backgroundColor = .yellow
                        self.btn1.layer.shadowColor = UIColor.yellow.cgColor
                            
                        self.btn2.setTitle("Cancelar", for: .normal)
                        self.btn2.backgroundColor = .red
                            
                        self.startTimer()

                    }
                }
            }
        } else {
            let alert = UIAlertController(title: "Mensaje", message: "El acelerómetro no está disponible", preferredStyle: .alert)
            let aceptar = UIAlertAction(title: "Aceptar", style: .default)
            alert.addAction(aceptar)
            self.present(alert, animated: false)
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 5
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return horas.count
        case 1:
            return 1
        case 2:
            return minutos.count
        case 3:
            return 1
        case 4:
            return segundos.count
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return "\(horas[row])"
        case 1:
            return ":"
        case 2:
            return "\(minutos[row])"
        case 3:
            return ":"
        case 4:
            return "\(segundos[row])"
        default:
            return nil
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        horasPicker = timePicker.selectedRow(inComponent: 0)
        minutosPicker = timePicker.selectedRow(inComponent: 2)
        segundosPicker = timePicker.selectedRow(inComponent: 4)
        
        let totalSegundos = (horasPicker * 3600) + (minutosPicker * 60) + segundosPicker
        
        totalTime = totalSegundos
    }
    
    @IBAction func botonUno(_ sender: UIButton) {
        print(sender.currentTitle)
        if sender.currentTitle == "Cancelar" {
            endTimer()
            self.containerTime.isHidden = true
            self.horaPicker.isHidden = false
            self.minutoPicker.isHidden = false
            self.segundoPicker.isHidden = false
            self.timePicker.isHidden = false
            self.message.isHidden = true
            
            self.btn1.isHidden = true
            self.btn2.isHidden = false
            self.btn2.setTitle("Aceptar", for: .normal)
            self.btnDetenerSound.isHidden = true
        } else if sender.currentTitle == "Pausa" {
            endTimer()
            self.btn1.setTitle("Reanudar", for: .normal)
        } else if sender.currentTitle == "Reanudar" {
            startTimer()
            self.btn1.setTitle("Pausa", for: .normal)
        }
    }
    
    func startTimer() {
        countDownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }
    
    @objc func updateTime() {
        horaPicker.isHidden = true
        minutoPicker.isHidden = true
        segundoPicker.isHidden = true
        timePicker.isHidden = true
        containerTime.isHidden = false
        
        totalTime -= 1
        containerTime.text = timeFormatted(totalTime)
        // print(totalTime)
        if totalTime == 0 {
            endTimer()
            //print(indexSonido)
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
            
            if indexVibracion == 0 {
                light.impactOccurred()
            } else if indexVibracion == 1 {
                medium.impactOccurred()
            } else {
                heavy.impactOccurred()
            }
            
            self.message.isHidden = true
            self.btnDetenerSound.isHidden = false
        }
    }
    
    func timeFormatted(_ totalSeconds: Int) -> String {
        let horas = totalSeconds / 3600
        let minutos = (totalSeconds % 3600) / 60
        let segundosRestantes = (totalSeconds % 3600) % 60
          
        let tiempo = String(format: "%02d:%02d:%02d", horas, minutos, segundosRestantes)
        return tiempo
    }
    
    func loadAvAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
            try AVAudioSession.sharedInstance().setActive(true, options: [])
        } catch {
            print("Error al configurar AVAudioSession: \(error.localizedDescription)")
        }
    }
    
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
    
    @IBAction func btnDetenerSounds(_ sender: UIButton) {
        audioPlayer?.stop()
        
        if indexVibracion == 0 {
            //light.stop()
        } else if indexVibracion == 1 {
            // medium.stop()
        } else {
            // heavy.stop()
        }
    }
    
    func endTimer() {
        countDownTimer.invalidate()
    }
    
    @IBAction func botonDos(_ sender: UIButton) {
        if sender.currentTitle == "Aceptar" {
            self.message.isHidden = false
            self.btn1.isHidden = false
            self.btn1.backgroundColor = .red
            self.btn1.setTitle("Cancelar", for: .normal)
            self.btn2.isHidden = true
            self.btnDetenerSound.isHidden = true
            
            acelerometro()
            // startTimer()
        }
        
        if sender.currentTitle == "Cancelar" {
            endTimer()
            self.containerTime.isHidden = true
            self.horaPicker.isHidden = false
            self.minutoPicker.isHidden = false
            self.segundoPicker.isHidden = false
            self.timePicker.isHidden = false
            self.message.isHidden = true
            
            self.btn1.isHidden = true
            self.btn2.isHidden = false
            self.btn2.setTitle("Aceptar", for: .normal)
            self.btnDetenerSound.isHidden = true
        } else if sender.currentTitle == "Pausa" {
            endTimer()
            self.btn1.setTitle("Reanudar", for: .normal)
        } else if sender.currentTitle == "Reanudar" {
            startTimer()
            self.btn1.setTitle("Pausa", for: .normal)
        }
    }
    
    
}
    
