//
//  MultipleChoicePicker.swift
//  Characteristic
//
//  Created by Mathijs Kadijk on 23-11-15.
//  Copyright © 2015 Mathijs Kadijk. All rights reserved.
//

import Foundation

class MultipleChoicePicker: UITableViewController {
  var item: Configurator.Item!

  override func viewDidLoad() {
    super.viewDidLoad()

    self.title = item.name
  }

  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return item.allValues.count
  }

  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let value = item.allValues[indexPath.row]

    let cell = tableView.dequeueReusableCellWithIdentifier(R.reuseIdentifier.choiceCell, forIndexPath: indexPath)!
    cell.textLabel?.text = value.title
    cell.accessoryType = item.equalValuesInTuples(item.currentValue, value) ? .Checkmark : .None

    return cell
  }

  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    item.currentValue = item.allValues[indexPath.row]
    performSegueWithIdentifier(R.segue.unwindFromMultipleChoicePickerToConfigurator, sender: tableView)
  }
}
