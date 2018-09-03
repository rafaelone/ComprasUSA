//
//  SettingsViewController.swift
//  ComprasUSA
//
//  Created by Desenvolvimento on 31/08/18.
//  Copyright © 2018 Rafael. All rights reserved.
//

import UIKit
import CoreData

class SettingsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var txDolar: UITextField!
    @IBOutlet weak var txIof: UITextField!
    @IBOutlet weak var tbEstado: UITableView!
    
    var fetchedResultController: NSFetchedResultsController<State>!
    var listaEstados:[State] = []
     let numberFormatter = NumberFormatter()
    let ud = UserDefaults.standard
    let valorDolar = 4.06
    let valorIof = 6.38
    
    let label: UILabel = {
        let label = UILabel()
        label.text = "Lista de estados vazia."
        label.textAlignment = .center
        label.textColor = UIColor.gray
        return label
    }()
    
   
    override func viewDidLoad() {
       super.viewDidLoad()
        checaUsersDefault()
        txDolar.keyboardType = UIKeyboardType.numberPad
        txIof.keyboardType = UIKeyboardType.numberPad
        carregaEstados()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        carregaEstados()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        txDolar.text = ud.string(forKey: "dolar")
        txIof.text = ud.string(forKey: "iof")
    }
    
    // Funcao feita para a primeira entrada no app os campos dolar e iof começarem com valores
    func checaUsersDefault(){
        let dolar = ud.string(forKey: "dolar")
        let iof = ud.string(forKey: "iof")
       
        if dolar == nil && iof == nil {
            print("checando user default")
            ud.set(valorDolar, forKey: "dolar")
            ud.set(valorIof, forKey: "iof")
            
        }
      
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func saveDolarIof(){
        view.endEditing(true)
        guard let dolar = txDolar.text else {return}
        guard let iof = txIof.text else {return}
        ud.set(dolar, forKey: "dolar")
        ud.set(iof, forKey: "iof")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        saveDolarIof()
        
    }
    
    func carregaEstados(){
        let fetchRequest: NSFetchRequest<State> = State.fetchRequest()
        let ordenaNome = NSSortDescriptor(key: "nome", ascending: true)
        fetchRequest.sortDescriptors = [ordenaNome]
        do{
            listaEstados = try context.fetch(fetchRequest)
            tbEstado.reloadData()
        }catch{
            print(error.localizedDescription)
        }
    }
    
    func showAlert(estado: State?){
        let title = estado == nil ? "Adicionar Estado" : "Atualizar Estado"
        let alert = UIAlertController(title: title, message: "", preferredStyle: .alert)
        let confirmar = UIAlertAction(title: "Adicionar", style: .default) { (action) in
            guard let nome = alert.textFields![0].text else {return}
            guard let taxa = alert.textFields![1].text else {return}
            let nomeEstado = nome
            let impostoEstado = Double(taxa)
            let estado = estado ?? State(context: self.context)
            estado.nome = nomeEstado
            estado.imposto = impostoEstado ?? 0
            do{
                try self.context.save()
                self.carregaEstados()
            }catch{print(error.localizedDescription)}
        }
        alert.addTextField { (textField) in
            textField.placeholder = "Nome do estado"
            textField.text = estado?.nome
        }
        alert.addTextField { (textField) in
            textField.placeholder = "Imposto"
            textField.text = estado?.imposto.description
        }
        let cancelar = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        alert.addAction(confirmar)
        alert.addAction(cancelar)
        present(alert, animated: true, completion: nil)
    }
    
    
    
    @IBAction func addEstado(_ sender: UIButton) {
        showAlert(estado: nil)
        
    }
    

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tbEstado.backgroundView = listaEstados.count == 0 ? label : nil
        return listaEstados.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tbEstado.dequeueReusableCell(withIdentifier: "celula", for: indexPath) as! EstadoTableViewCell
        cell.txEstado.text = listaEstados[indexPath.row].nome
        cell.txValor.text = "\(listaEstados[indexPath.row].imposto)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleta = UITableViewRowAction(style: .destructive, title: "Excluir") { (action, indexPath) in
            let estado = self.listaEstados[indexPath.row]
            self.context.delete(estado)
            do{
                try self.context.save()
                self.listaEstados.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                
            }catch{
                print(error.localizedDescription)
            }
        }
        let edita = UITableViewRowAction(style: .default, title: "Editar") { (action, indexPath) in
            let estado = self.listaEstados[indexPath.row]
            self.showAlert(estado: estado)
            tableView.setEditing(false, animated: true)
        }
        edita.backgroundColor = .blue
        return [deleta, edita]
    }

}


extension SettingsViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        saveDolarIof()
        return true
    }
}

extension SettingsViewController: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tbEstado.reloadData()
    }
}

