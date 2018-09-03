//
//  EstadoTableViewCell.swift
//  ComprasUSA
//
//  Created by Desenvolvimento on 03/09/18.
//  Copyright © 2018 Rafael. All rights reserved.
//

import UIKit

class EstadoTableViewCell: UITableViewCell {
    @IBOutlet weak var txEstado: UILabel!
    @IBOutlet weak var txValor: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
