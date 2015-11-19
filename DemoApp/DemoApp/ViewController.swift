//
//  ViewController.swift
//  DemoApp
//
//  Created by Mathijs Kadijk on 23-11-15.
//  Copyright © 2015 Mathijs Kadijk. All rights reserved.
//

import UIKit
import Characteristic

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  @IBAction func openConfiguratorTouched(sender: AnyObject) {
    presentViewController(App.config.createConfigurator(), animated: true, completion: nil)
  }
}

