//
//  TotalViewController.swift
//  ComprasUSA
//
//  Created by Usuário Convidado on 04/09/2018.
//  Copyright © 2018 Rafael. All rights reserved.
//

import UIKit
import CoreData

class TotalViewController: UIViewController {
    
    
    @IBOutlet weak var lbTotalDolar: UILabel!
    @IBOutlet weak var lbValorDolar: UILabel!
    @IBOutlet weak var lbTotalReal: UILabel!
    @IBOutlet weak var lbValorReal: UILabel!
    
    let ud = UserDefaults.standard
    

    var fetchedResultController: NSFetchedResultsController<Product>!
    var listaProduto:[Product] = []
    let numberFormatter = NumberFormatter()
    override func viewDidLoad() {
        super.viewDidLoad()
        carregaEstados()
        somaValores()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
                carregaEstados()
        somaValores()
    }
    
    
    func somaValores(){
        let valoresProdutos = listaProduto.map{$0.money}
        let somaValoresDolar = valoresProdutos.reduce(0, {$0 + $1})
        lbValorDolar.text = String(format:"%.2f", somaValoresDolar)
        lbValorDolar.textColor = UIColor.red
        lbValorReal.text = String(format:"%.2f", somaValoresDolar * ud.double(forKey: "dolar"))
        lbValorReal.textColor = UIColor.green
    }
    
    
    func carregaEstados(){
        let fetchRequest: NSFetchRequest<Product> = Product.fetchRequest()
        let ordenaNome = NSSortDescriptor(key: "nome", ascending: true)
        fetchRequest.sortDescriptors = [ordenaNome]
        do{
            listaProduto = try context.fetch(fetchRequest)
        }catch{
            print(error.localizedDescription)
        }
    }
  

}
