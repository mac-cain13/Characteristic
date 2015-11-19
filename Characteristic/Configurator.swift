//
//  Configurator.swift
//  Characteristic
//
//  Created by Mathijs Kadijk on 20-11-15.
//  Copyright © 2015 Mathijs Kadijk. All rights reserved.
//

import Foundation

public class Configurator: UITableViewController {
  private static let DefaultTitle = "Configurator"

  public static func withItemGroups(itemGroups: [ItemGroup], title: String = DefaultTitle) -> UIViewController {
    let navigationController = R.storyboard.configurator.initialViewController!

    let configurator = navigationController.topViewController as! Configurator
    configurator.title = title
    configurator.itemGroups = itemGroups

    return navigationController
  }

  public static func withItems(items: [Item], title: String = DefaultTitle) -> UIViewController {
    return withItemGroups([ItemGroup(name: nil, items: items)], title: title)
  }

  private var itemGroups: [ItemGroup]!

  public override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return itemGroups.count
  }

  public override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return itemGroups[section].items.count
  }

  public override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return itemGroups[section].name
  }

  public override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let item = itemGroups[indexPath.section].items[indexPath.row]

    let cell = tableView.dequeueReusableCellWithIdentifier(R.reuseIdentifier.multipleChoiceCell, forIndexPath: indexPath)!
    cell.textLabel?.text = item.name
    cell.detailTextLabel?.text = item.value.title

    return cell
  }

  public override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    performSegueWithIdentifier(R.segue.presentCharacteristicChoices, sender: tableView)
  }

  public override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    guard let indexPath = tableView.indexPathForSelectedRow,
      destinationViewController = segue.destinationViewController as? MultipleChoicePicker else {
      print("[Characteristic/Configurator] FATAL ERROR: No selected row and/or case to MultipleChoicePicker failed, this is a bug in the library. Please report this to the maintainer.")
      return
    }

    let item = itemGroups[indexPath.section].items[indexPath.row]
    destinationViewController.item = item
  }

  private func saveChanges() {
    itemGroups.forEach { group in
      group.items.forEach { item in
        item.applyValue()
      }
    }
  }

  @IBAction func unwindFromMultipleChoicePickerToConfigurator(segue: UIStoryboardSegue) {
    if let sourceViewController = segue.sourceViewController as? MultipleChoicePicker,
      indexPath = indexPathForItem(item: sourceViewController.item, inGroups: itemGroups) {
        tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .None)
    }
  }

  @IBAction func cancelButtonTouched(sender: AnyObject) {
    dismissViewControllerAnimated(true, completion: nil)
  }

  @IBAction func saveButtonTouched(sender: AnyObject) {
    saveChanges()
    dismissViewControllerAnimated(true, completion: nil)
  }
}

private func indexPathForItem(item subject: Configurator.Item, inGroups groups: [Configurator.ItemGroup]) -> NSIndexPath? {
  for var section = 0; section < groups.count; ++section {
    let group = groups[section]
    for var row = 0; row < group.items.count; ++row {
      if group.items[row] === subject {
        return NSIndexPath(forRow: row, inSection: section)
      }
    }
  }

  return nil
}
