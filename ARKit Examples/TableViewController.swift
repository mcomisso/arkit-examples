//
//  TableViewController.swift
//  ARKit Examples
//
//  Created by Matteo Comisso on 02/02/2018.
//  Copyright © 2018 ReatailMeNot UK Ltd. All rights reserved.
//

import Foundation
import UIKit

class TableViewController: UIViewController {
    let dataSource = ["base", "draw", "earth", "plane", "basketball", "portal"]

    override func viewDidLoad() {
        super.viewDidLoad()
    }

}

extension TableViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") else {
            fatalError()
        }

        cell.textLabel?.text = self.dataSource[indexPath.row].capitalized.appending(" example")

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let action = self.dataSource[indexPath.row]
        self.performSegue(withIdentifier: action, sender: nil)
    }
}
