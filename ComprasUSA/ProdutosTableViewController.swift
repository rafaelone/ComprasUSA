//
//  ProdutosTableViewController.swift
//  ComprasUSA
//
//  Created by Desenvolvimento on 03/09/18.
//  Copyright © 2018 Rafael. All rights reserved.
//

import UIKit
import CoreData

class ProdutosTableViewController: UITableViewController {
    
        var fetchedResultController: NSFetchedResultsController<Product>!
    
    let label: UILabel = {
        let label = UILabel()
        label.text = "Sua lista está vazia"
        label.textAlignment = .center
        label.textColor = UIColor.gray
        return label
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        carregaCompra()

    }
    
    private func carregaCompra() {
        let fetchRequest: NSFetchRequest<Product> = Product.fetchRequest()
        let ordenaCompra = NSSortDescriptor(key: "nome", ascending: true)
        fetchRequest.sortDescriptors = [ordenaCompra]
        fetchedResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultController.delegate = self
        do {
            try fetchedResultController.performFetch()
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? ViewController {
            vc.produto = fetchedResultController.object(at: tableView.indexPathForSelectedRow!)
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        tableView.backgroundView = fetchedResultController.fetchedObjects?.count == 0 ? label : nil
        return fetchedResultController.fetchedObjects?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ProdutosTableViewCell
        
        let produto = fetchedResultController.object(at: indexPath)
        cell.lbTitle.text = produto.nome
        cell.ivProduto.image = produto.image as? UIImage
        cell.lbPreco.text = "U$ \(produto.money)"
        
        print(cell.lbPreco)
        
        return cell
        
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            //delete the row form the data source
            let produto = fetchedResultController.object(at: indexPath)
            do {
                context.delete(produto)
                try context.save()
            } catch {
                print(error.localizedDescription)
            }
        }
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ProdutosTableViewController: NSFetchedResultsControllerDelegate{
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.reloadData()
    }
}
