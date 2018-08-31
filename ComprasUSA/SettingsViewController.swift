//
//  SettingsViewController.swift
//  ComprasUSA
//
//  Created by Desenvolvimento on 31/08/18.
//  Copyright © 2018 Rafael. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var txDolar: UITextField!
    @IBOutlet weak var txIof: UITextField!
    
    let ud = UserDefaults.standard
    let valorDolar = 4.06
    let valorIof = 6.38
    
   
    override func viewDidLoad() {
       super.viewDidLoad()
        checaUsersDefault()
        txDolar.keyboardType = UIKeyboardType.numberPad
        txIof.keyboardType = UIKeyboardType.numberPad
        // Do any additional setup after loading the view.
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
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        txDolar.text = ud.string(forKey: "dolar")
        txIof.text = ud.string(forKey: "iof")
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
        
    }    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


extension SettingsViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        saveDolarIof()
        return true
    }
}
