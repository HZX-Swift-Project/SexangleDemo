//
//  ViewController.swift
//  SexangleDemo
//
//  Created by Meet on 2021/3/9.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var test1: UILabel!
    @IBOutlet weak var test2: UILabel!
    
    @IBOutlet weak var test3: UILabel!
    
    @IBOutlet weak var test4: UILabel!
    
    @IBOutlet weak var test5: UILabel!
    
    @IBOutlet weak var test6: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
       
        test1.setSixBorder()
        test2.setSixBorder(.left)
        test3.setSixBorder(.right)
        test4.setSixBorder(borderColor: .purple)
        test5.setSixBorder(.left, borderColor: .green, borderWidth: 5)
        test6.setSixBorder(.right, borderColor: .red)
    }


}

