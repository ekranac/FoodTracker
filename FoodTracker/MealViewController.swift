//
//  MealViewController.swift

//  FoodTracker
//
//  Created by Ziga Besal on 26/10/15.
//  Copyright © 2015 Ziga Besal. All rights reserved.
//

import UIKit

class MealViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    
    // MARK: Properties
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var ratingControl: RatingControl!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var meal: Meal?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        nameTextField.delegate=self
        checkValidMealName()
        
    }
    // MARK: UITextFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        // Hide the keyboard when the text field is no longer the first responder
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField)
    {
        saveButton.enabled = false
    }
    
    func checkValidMealName()
    {
        let text = nameTextField.text ?? ""
        saveButton.enabled = !text.isEmpty
    }
    
    func textFieldDidEndEditing(textField: UITextField)
    {
        checkValidMealName()
        navigationItem.title = textField.text
    }
    // MARK: UIImagePickerControllerDelegate
    func imagePickerControllerDidCancel(picker: UIImagePickerController)
    {
        // Dismiss the picker if the user canceled
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        // The info dictionary contains multiple representations of the image, and this uses the original.
        let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        // Set photoImageView to display the selected image.
        photoImageView.image = selectedImage
        dismissViewControllerAnimated(true, completion: nil)
    }
    // MARK: Navigation
    
    @IBAction func cancel(sender: UIBarButtonItem)
    {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if saveButton === sender
        {
            let name = nameTextField.text ?? ""
            let photo = photoImageView.image
            let rating = ratingControl.rating
            
            // Set the meal to be passed to MealTableViewController after the unwind segue.
            meal = Meal(name: name, photo: photo, rating: rating)
        }
    }
    
    // MARK: Actions
    
    @IBAction func selectImageFromPhotoLibrary(sender: UITapGestureRecognizer)
    {
        // Hide the keyboard
        nameTextField.resignFirstResponder()
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .PhotoLibrary
        
        imagePickerController.delegate = self
        presentViewController(imagePickerController, animated: true, completion: nil)
    }
    
}

