//
//  SettingsViewController.m
//  spire
//
//  Created by Lucy Guo on 7/27/14.
//  Copyright (c) 2014 Niveditha Jayasekar. All rights reserved.
//

#import "SettingsViewController.h"
#import "SettingsForm.h"
#import "RootForm.h"
#import <Parse/Parse.h>
#import "LoginViewController.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]))
    {
        [self initNavBar];
        //set up form
        self.formController.form = [[SettingsForm alloc] init];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
}

- (void)initNavBar
{
    
    self.navigationController.navigationBar.topItem.title = @"Settings";
    self.navigationItem.title = @"Settings";
}

//these are action methods for our forms
//the methods escalate through the responder chain until
//they reach the AppDelegate

- (void)submitLoginForm
{
    //now we can display a form value in our alert
    [[[UIAlertView alloc] initWithTitle:@"Login Form Submitted" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil] show];
}

- (void)submitRegistrationForm:(UITableViewCell<FXFormFieldCell> *)cell
{
    //we can lookup the form from the cell if we want, like this:
    SettingsForm *form = cell.field.form;
    
    //we can then perform validation, etc
    if (form.agreedToTerms)
    {
        [[[UIAlertView alloc] initWithTitle:@"Login Form Submitted" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil] show];
    }
    else
    {
        [[[UIAlertView alloc] initWithTitle:@"User Error" message:@"Please agree to the terms and conditions before proceeding" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Yes Sir!", nil] show];
    }
}

- (void)logoutOfFacebook
{
    [PFUser logOut];
    LoginViewController *ppvc = [[LoginViewController alloc] init];
    
    [self.navigationController pushViewController:ppvc animated:YES];
}




@end
