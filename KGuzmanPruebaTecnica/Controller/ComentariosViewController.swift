//
//  ComentariosViewController.swift
//  KGuzmanPruebaTecnica
//
//  Created by MacBookMBA2 on 05/07/23.
//

import UIKit

class ComentariosViewController: UIViewController, UIPickerViewDelegate {
    @IBOutlet weak var imagen: UIImageView!
    @IBOutlet weak var txtNombre: UITextField!
    @IBOutlet weak var txtComentario: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.txtNombre.layer.borderWidth = 2
        self.txtNombre.layer.borderColor = UIColor.yellow.cgColor
        
        self.txtComentario.layer.cornerRadius = 8
        self.txtComentario.layer.borderWidth = 2
        self.txtComentario.layer.borderColor = UIColor.yellow.cgColor
        
        imagen.contentMode = .scaleAspectFit
        imagen.layer.cornerRadius = imagen.frame.size.width / 2
        imagen.layer.borderColor = UIColor.red.cgColor
        imagen.clipsToBounds = true
    }

}
