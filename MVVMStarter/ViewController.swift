//
//  ViewController.swift
//  MVVMStarter
//
//  Created by Mushfiq Humayoon on 16/06/23.
//

import DesignKit

class ViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet weak var infoLabel: UILabel!
    // MARK: - View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLabel()
    }
    //MARK: - Initial Setup of Label
    private func setupLabel() {
        infoLabel.text = "The second tab is working as a different module in this app"
    }
}

