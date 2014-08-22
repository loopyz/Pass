//
//  RegistrationForm.m
//  spire
//
//  Created by Lucy Guo on 7/27/14.
//  Copyright (c) 2014 Niveditha Jayasekar. All rights reserved.
//

#import "RegistrationForm.h"

@implementation RegistrationForm

//because we want to rearrange how this form
//is displayed, we've implemented the fields array
//which lets us dictate exactly which fields appear
//and in what order they appear

- (NSArray *)fields
{
    return @[
             
             //we want to add a group header for the field set of fields
             //we do that by adding the header key to the first field in the group
             
             @{FXFormFieldKey: @"email", FXFormFieldHeader: @"Account"},
             
             //we don't need to modify these fields at all, so we'll
             //just refer to them by name to use the default settings
             
             @"password",
             @"repeatPassword",
             
             //we want to add another group header here, and modify the auto-capitalization
             
             @{FXFormFieldKey: @"name", FXFormFieldHeader: @"Details",
               @"textField.autocapitalizationType": @(UITextAutocapitalizationTypeWords)},
             
             @"Username",
             
             //this is a multiple choice field, so we'll need to provide some options
             //because this is an enum property, the indexes of the options should match enum values
             
             @{FXFormFieldKey: @"gender", FXFormFieldOptions: @[@"Male", @"Female", @"It's Complicated"]},
             
             //another regular field
             
             @"dateOfBirth",
             

             //some more regular fields
             
             @"profilePhoto",
             @"phone",
             
             //this is a multiline text view that grows to fit its contents
             
             @{FXFormFieldKey: @"about", FXFormFieldType: FXFormFieldTypeLongText, FXFormFieldPlaceholder: @"Text..."},
             
             
             //we want to add a section header here, so we use another config dictionary
             
             @{FXFormFieldKey: @"termsAndConditions", FXFormFieldHeader: @"Legal"},
             
             //another regular field. note that we haven't actually instantiated the terms
             //and conditions or privacy policy view controllers - FXForms will instantiate
             //view controllers automatically if the value is nil, or will used the supplied
             //controller instance if there is one
             
             @"privacyPolicy",
             
             //the automatically generated title (Agreed To Terms) and cell (FXFormSwitchCell)
             //don't really work for this field, so we'll override them both (a type of
             //FXFormFieldTypeOption will use an checkmark instead of a switch by default)
             
             @{FXFormFieldKey: @"agreedToTerms", FXFormFieldTitle: @"I Agree To These Terms", FXFormFieldType: FXFormFieldTypeOption},
             
             //this field doesn't correspond to any property of the form
             //it's just an action button. the action will be called on first
             //object in the responder chain that implements the submitForm
             //method, which in this case would be the AppDelegate
             
             @{FXFormFieldTitle: @"Submit", FXFormFieldHeader: @"", FXFormFieldAction: @"submitRegistrationForm:"},
             
             ];
}

@end