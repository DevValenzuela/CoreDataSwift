//
//  ViewController.swift
//  CrudCoreData
//
//  Created by David Valenzuela Pardo on 21/01/24.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    @IBOutlet weak var nameText: UITextField!
    
    @IBOutlet weak var active: UISwitch!
    
    @IBOutlet weak var edadText: UITextField!
    //var contexto: NSManagedObjectContext!
    
    func conexion () -> NSManagedObjectContext{
        let delegate = UIApplication.shared.delegate as! AppDelegate
        return delegate.persistentContainer.viewContext
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // contexto = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        // Do any additional setup after loading the view.
    }

    @IBAction func saveHandler(_ sender: UIButton) {
        let contexto = conexion()
        let entidadPersons = NSEntityDescription.entity(forEntityName: "Personas", in: contexto)
        let newPersona = NSManagedObject(entity: entidadPersons!, insertInto: contexto)
        
        let edadPerson = Int16(edadText.text!)
        
        newPersona.setValue(nameText.text, forKey: "nombre")
        newPersona.setValue(edadPerson, forKey: "edad")
        newPersona.setValue(active.isOn, forKey: "activo")
        
        do{
            try contexto.save()
            print("Save success fully!!")
            nameText.text = ""
            edadText.text = ""
            active.isOn = false
        }catch let error as NSError{
            print("Not save ", error)
        }
    }
    
    
    @IBAction func showHandler(_ sender:UIButton) {
        let contexto = conexion()
        let fetchRequest: NSFetchRequest<Personas> = Personas.fetchRequest()
        
        do{
            let results = try contexto.fetch(fetchRequest)
            print("Number registers = \(results.count)")
            for res in results as [NSManagedObject] {
                let namePerson = res.value(forKey: "nombre")
                let agePerson = res.value(forKey: "edad")
                let activePerson = res.value(forKey: "activo")
                print("name: \(namePerson!) - age: \(agePerson!) - active: \(activePerson!)")
            }
        }catch let error as NSError {
            print("Not Show ", error)
        }
    }
    

    @IBAction func removeHandler(_ sender: UIButton) {
        let contexto = conexion()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Personas")
        let borrar = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        print("Erase sucess fully!!")
        do{
            try contexto.execute(borrar)
        }catch let error as NSError{
            print("Not erase ", error)
        }
    }
}

