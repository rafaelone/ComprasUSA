
//
//  RegistraAtualizaProdutoViewController.swift
//  ComprasUSA
//
//  Created by Desenvolvimento on 03/09/18.
//  Copyright © 2018 Rafael. All rights reserved.
//

import UIKit
import CoreData

class RegistraAtualizaProdutoViewController: UIViewController {
    
    @IBOutlet weak var txNome: UITextField!
    @IBOutlet weak var ivFoto: UIImageView!
    @IBOutlet weak var txEstado: UITextField!
    @IBOutlet weak var txValor: UITextField!
    @IBOutlet weak var slCartao: UISwitch!
    @IBOutlet weak var btAddEdit: UIButton!
    @IBOutlet weak var lbError: UILabel!
    
    let pickerView = UIPickerView(frame: .zero)
    let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 44))
    var produto: Product!
    var estado: State!
    var listaEstados:[State] = []
    var fetchedResultController: NSFetchedResultsController<State>!
    let ud = UserDefaults.standard
    var estadoSelecionado: State!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerView.dataSource = self
        pickerView.delegate = self
        toolBarConfiguracao()
        carregaEstados()
        txValor.keyboardType = UIKeyboardType.numberPad
        if produto != nil {
            txNome.text = produto.nome
            ivFoto.image = produto.image as? UIImage
            txValor.text = "\(produto.money)"
            slCartao.setOn(produto.cartao, animated: true)
            btAddEdit.setTitle("Atualizar", for: .normal)
            txEstado.text = produto.states?.nome
        //    estadoSelecionado = estado
            txValor.keyboardType = UIKeyboardType.numberPad
            
        }
       /* else{
            produto = Product(context: context)

        }*/
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        carregaEstados()
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func carregaEstados(){
        let fetchRequest: NSFetchRequest<State> = State.fetchRequest()
        let ordenaNome = NSSortDescriptor(key: "nome", ascending: true)
        fetchRequest.sortDescriptors = [ordenaNome]
        do{
            listaEstados = try context.fetch(fetchRequest)
        }catch{
            print(error.localizedDescription)
        }
        pickerView.reloadAllComponents()
    }
    
    
    @IBAction func addFoto(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "Selecionar foto", message: "De onde você gostaria de selecionar a foto ?", preferredStyle: .actionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            let acaoCamera = UIAlertAction(title: "Camera", style: .default) { (action) in
                self.selecionaFoto(sourceType: .camera)
            }
            alert.addAction(acaoCamera)
        }
        
        let biblioteca = UIAlertAction(title: "Bilioteca de fotos", style: .default) { (action) in
            self.selecionaFoto(sourceType: .photoLibrary)
        }
        alert.addAction(biblioteca)
        
        
        
        let cancelar = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        alert.addAction(cancelar)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    func selecionaFoto(sourceType: UIImagePickerControllerSourceType){
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    func toolBarConfiguracao(){
        let btOk = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(done))
        
        let btSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        
        let btCancel = UIBarButtonItem(title: "Cancelar", style: UIBarButtonItemStyle.plain, target: self, action: #selector(cancel))
        
        toolbar.backgroundColor = .white
        toolbar.setItems([btCancel, btSpace, btOk], animated: false)
        
        txEstado.inputView = pickerView
        txEstado.inputAccessoryView = toolbar
    }
    @objc func done() {
        let estado = listaEstados[pickerView.selectedRow(inComponent: 0)]
        txEstado.text = estado.nome
        estadoSelecionado = estado
        print(estado.imposto)
        cancel()
        
    }
    
    @objc func cancel() {
        view.endEditing(true)
    }
    
    @IBAction func addEditProduto(_ sender: UIButton) {
            print("TESTE")
        print(estadoSelecionado)
       
    
            
            guard let txtNome = txNome.text else {return}
            guard let txDinheiro = txValor.text else {return}
            let impostaEstadoSelecionado = estadoSelecionado.imposto
            let imagem = ivFoto.image
            let dinheiro = Double(txDinheiro) ?? 0
            
            let acrescimoComCartao = (dinheiro * ud.double(forKey: "iof"))/100
            let acrescimoComImpostoEstado = (dinheiro * impostaEstadoSelecionado)/100
            
            print("VALORES")
            print(acrescimoComCartao)
            print(acrescimoComImpostoEstado)
            
            //        if txtNome != "" && txDinheiro != "" && txEstado != ""{
            produto.nome = txtNome
            produto.image = imagem
            produto.states = estadoSelecionado
            produto.cartao = slCartao.isOn
            
            
            if slCartao.isOn {
                
                produto.money = dinheiro + acrescimoComCartao + acrescimoComImpostoEstado
            }else{
                produto.money = dinheiro + acrescimoComImpostoEstado
            }
            
            do{
                try context.save()
                
                navigationController?.popViewController(animated: true)
            }catch{
                print(error.localizedDescription)
            }
            
        
        
      
        
        //        }else{
        //            lbError.text = "Todos os campos são obrigatórios"
        
        //        }
        
        
    }
    
}


extension RegistraAtualizaProdutoViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            let aspectRation = image.size.width / image.size.height
            let tamanhoMaximo: CGFloat = 500
            var tamanhoMinimo: CGSize
            if aspectRation > 1 {
                tamanhoMinimo = CGSize(width: tamanhoMaximo, height: tamanhoMaximo/aspectRation)
            }else{
                tamanhoMinimo = CGSize(width: tamanhoMaximo*aspectRation, height: tamanhoMaximo)
            }
            UIGraphicsBeginImageContext(tamanhoMinimo)
            image.draw(in: CGRect(x: 0, y: 0, width: tamanhoMinimo.width, height: tamanhoMinimo.height))
            ivFoto.image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
        }
        dismiss(animated: true, completion: nil)
    }
}


extension RegistraAtualizaProdutoViewController: NSFetchedResultsControllerDelegate {
    //metodo disparado toda vez que ha uma mudanca de conteudo
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        pickerView.reloadAllComponents()
    }
}

extension RegistraAtualizaProdutoViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return listaEstados.count
    }
}

extension RegistraAtualizaProdutoViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return listaEstados[row].nome
    }
}
