//
//  ViewController.swift
//  KGuzmanPruebaTecnica
//
//  Created by MacBookMBA2 on 05/07/23.
//

import UIKit
import CoreMotion

class TimeViewController: UIViewController {
    @IBOutlet weak var timerText: UITextView!
    @IBOutlet weak var textMessage: UITextView!
    @IBOutlet weak var btn1: UIButton!
    @IBOutlet weak var btn2: UIButton!
    
    var countDownTimer: Timer?
    var totalTime = 60
    let motionManager = CMMotionManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(timerText.text)
        
        self.textMessage.isHidden = true
        self.btn1.isHidden = true
        
        self.btn2.setTitle("Aceptar", for: .normal)
        self.btn2.backgroundColor = .green
        self.btn2.layer.cornerRadius = 30
        self.btn2.layer.masksToBounds = false
        self.btn2.layer.shadowColor = UIColor.yellow.cgColor
        self.btn2.layer.shadowOpacity = 0.5
        self.btn2.layer.shadowOffset = CGSize(width: -1, height: 1)
        self.btn2.layer.shadowRadius = 4
        
        self.btn1.layer.cornerRadius = 30
        self.btn1.layer.masksToBounds = false
        self.btn1.layer.shadowColor = UIColor.red.cgColor
        self.btn1.layer.shadowOpacity = 0.5
        self.btn1.layer.shadowOffset = CGSize(width: -1, height: 1)
        self.btn1.layer.shadowRadius = 4
        
        acelerometro()
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
                    //if x, y, z == 0 {}
                }
            }
        } else {
            let alert = UIAlertController(title: "Mensaje", message: "El acelerómetro no está disponible", preferredStyle: .alert)
            let aceptar = UIAlertAction(title: "Aceptar", style: .default)
            alert.addAction(aceptar)
            self.present(alert, animated: false)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        motionManager.stopAccelerometerUpdates()
    }
    
    func startTimer() {
        countDownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }
    
    @objc func updateTime() {
        totalTime -= 1
        timerText.text = timeFormatted(totalTime)
    }
    
    func timeFormatted(_ totalSeconds: Int) -> String {
        let horas = totalSeconds / 3600
            let minutos = (totalSeconds % 3600) / 60
            let segundosRestantes = (totalSeconds % 3600) % 60
        
        let tiempo = String(format: "%02d:%02d:%02d", horas, minutos, segundosRestantes)
        return tiempo
    }
    
    func endTimer() {
           countDownTimer?.invalidate()
       }

    @IBAction func btnAceptar(_ sender: Any) {
        self.textMessage.isHidden = false
        self.btn1.isHidden = false
        self.btn1.backgroundColor = .red
        self.btn1.setTitle("Cancelar", for: .normal)
        self.btn2.isHidden = true
        
        startTimer()
    }
    
    @IBAction func btnCancelar(_ sender: Any) {
        self.textMessage.isHidden = true
        self.btn2.isHidden = false
        
        self.btn1.setTitle("Pausa", for: .normal)
        self.btn1.backgroundColor = .yellow
        self.btn1.layer.shadowColor = UIColor.yellow.cgColor
        
        self.btn2.setTitle("Cancelar", for: .normal)
        self.btn2.backgroundColor = .red
        
        endTimer()
    }
    
}

