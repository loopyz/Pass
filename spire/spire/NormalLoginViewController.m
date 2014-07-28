//
//  NormalLoginViewController.m
//  spire
//
//  Created by Lucy Guo on 7/27/14.
//  Copyright (c) 2014 Niveditha Jayasekar. All rights reserved.
//

#import "NormalLoginViewController.h"
#import "NormalLoginForm.h"

@interface NormalLoginViewController ()

@end

@implementation NormalLoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]))
    {
        //set up form
        self.formController.form = [[NormalLoginForm alloc] init];
        self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    }
    return self;
}

- (void)submitLoginForm
{
    //now we can display a form value in our alert
    [[[UIAlertView alloc] initWithTitle:@"Login Form Submitted" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil] show];
}

@end
