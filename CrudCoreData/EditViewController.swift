//
//  EditViewController.swift
//  CrudCoreData
//
//  Created by David Valenzuela Pardo on 21/01/24.
//

import UIKit
import CoreData

class EditViewController: UIViewController {
    
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var ageText: UITextField!
    @IBOutlet weak var active: UISwitch!
    
    var personEditar: Personas!
    
    func conexion() -> NSManagedObjectContext {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        return delegate.persistentContainer.viewContext
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Name: \(personEditar.nombre!)")
        
        nameText.text = personEditar.nombre
        ageText.text = "\(personEditar.edad)"
        if personEditar.activo {
            active.isOn =  true
        }else{
            active.isOn =  false
        }
        // Do any additional setup after loading the view.
    }
    

    @IBAction func editHandler(_ sender: UIButton) {
        let contexto = conexion()
        let edadPerson = Int16(ageText.text!)
        
        personEditar.setValue(nameText.text, forKey: "nombre")
        personEditar.setValue(edadPerson, forKey: "edad")
        personEditar.setValue(active.isOn, forKey: "activo")
        
        do{
            try contexto.save()
            performSegue(withIdentifier: "sendTable", sender: self)
        }catch let error as NSError {
            print("Not Show ", error)
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
