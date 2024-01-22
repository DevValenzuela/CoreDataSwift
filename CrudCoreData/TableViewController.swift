//
//  TableViewController.swift
//  CrudCoreData
//
//  Created by David Valenzuela Pardo on 21/01/24.
//

import UIKit
import CoreData

class TableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    

    var persons: [Personas] = []
    @IBOutlet weak var TableView: UITableView!
    
    func conexion() -> NSManagedObjectContext {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        return delegate.persistentContainer.viewContext
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        TableView.reloadData()
        TableView.delegate = self
        TableView.dataSource = self
        showData()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return persons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = TableView.dequeueReusableCell(withIdentifier: "ceil", for: indexPath)
        let person = persons[indexPath.row]
        
        if person.activo {
            cell.textLabel?.text = "🎉 \(person.nombre!)"
            cell.detailTextLabel?.text = "\(person.edad)"
        }else{
            cell.textLabel?.text = "🥺 \(person.nombre!)"
            cell.detailTextLabel?.text = "\(person.edad)"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "enviarEdit", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "enviarEdit" {
            if let id = TableView.indexPathForSelectedRow {
                let fila =  persons[id.row]
                let destin = segue.destination as! EditViewController
                destin.personEditar = fila
            }
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let contexto = conexion()
        let person = persons[indexPath.row]
        
        if editingStyle == .delete{
            contexto.delete(person)
        }
        
        do{
            try contexto.save()
        }catch let error as NSError{
            print("Not Delete: ", error)
        }
        showData()
        tableView.reloadData()
    }
    
    func showData(){
        let contexto = conexion()
        let fetchRequest:NSFetchRequest<Personas> = Personas.fetchRequest()
        
        do{
            persons = try contexto.fetch(fetchRequest)
        }catch let error as NSError{
            print("Error: ", error)
        }
    }
    

}
