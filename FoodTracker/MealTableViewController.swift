//
//  MealTableViewController.swift
//  FoodTracker
//
//  Created by Ziga Besal on 28/10/15.
//  Copyright © 2015 Ziga Besal. All rights reserved.
//

import UIKit

class MealTableViewController: UITableViewController
{
    // MARK: Properties
    var meals = [Meal]()

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Check if there are any presaved meals, otherwise load just the sample data
        if let savedMeals = loadMeals()
        {
            meals += savedMeals
        }
        else
        {
            loadSampleMeals()
        }
        
        navigationItem.leftBarButtonItem = editButtonItem()
    }
    
    func loadSampleMeals()
    {
        let photo_one = UIImage(named: "meal1")!
        let meal_one = Meal(name: "Pizza", photo: photo_one, rating: 4)!
        
        let photo_two = UIImage(named: "meal2")!
        let meal_two = Meal(name: "Risotto with pork meat", photo: photo_two, rating: 3)!
        
        let photo_three = UIImage(named: "meal3")!
        let meal_three = Meal(name: "Something nasty", photo: photo_three, rating: 2)!
        
        let photo_four = UIImage(named: "meal4")!
        let meal_four = Meal(name: "Chicken wings", photo: photo_four, rating: 4)!
        
        let photo_five = UIImage(named: "meal5")!
        let meal_five = Meal(name: "Something that looks like asian food", photo: photo_five, rating: 5)!
        
        meals += [meal_one, meal_two, meal_three, meal_four, meal_five]
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return meals.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "MealTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! MealTableViewCell
        
        // Fetches the appropriate meal for the data source layout.
        let meal = meals[indexPath.row]
        
        cell.nameLabel.text = meal.name
        cell.photoImageView.image = meal.photo
        cell.ratingControl.rating = meal.rating

        return cell
    }


    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool
    {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath)
    {
        if editingStyle == .Delete
        {
            // Delete the row from the data source
            meals.removeAtIndex(indexPath.row)
            saveMeals()
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert
        {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier == "ShowDetail"
        {
            let mealDetailViewController = segue.destinationViewController as! MealViewController
            if let selectedMealCell = sender as? MealTableViewCell
            {
                let indexPath = tableView.indexPathForCell(selectedMealCell)!
                let selectedMeal = meals[indexPath.row]
                mealDetailViewController.meal = selectedMeal
            }
        }
        else if segue.identifier == "AddItem"
        {
            print("Adding new meal")
        }
    }
    
    @IBAction func unwindToMealList(sender: UIStoryboardSegue)
    {
        if let sourceViewController = sender.sourceViewController as? MealViewController, meal = sourceViewController.meal
        {
            if let selectedIndexPath = tableView.indexPathForSelectedRow
            {
                // If selectedIndexPath is sent from one of the cells in tableView
                // Update existing meal (function is unwinding from the MealView)
                meals[selectedIndexPath.row] = meal
                tableView.reloadRowsAtIndexPaths([selectedIndexPath], withRowAnimation: .None)
                
            }
            
            else
            {
                // Add a new meal.
                let newIndexPath = NSIndexPath(forRow: meals.count, inSection: 0)
                meals.append(meal)
                tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Bottom)
            }
            
            saveMeals()
        }
    }
    
    // MARK: NSCoding
    func saveMeals()
    {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(meals, toFile: Meal.ArchiveURL.path!)
        if !isSuccessfulSave
        {
            print("Something had gone wrong...")
        }
    }
    
    func loadMeals() -> [Meal]?
    {
        return NSKeyedUnarchiver.unarchiveObjectWithFile(Meal.ArchiveURL.path!) as? [Meal]
    }

}
