//
//  NormalLoginForm.m
//  spire
//
//  Created by Lucy Guo on 7/27/14.
//  Copyright (c) 2014 Niveditha Jayasekar. All rights reserved.
//

#import "NormalLoginForm.h"

@implementation NormalLoginForm

//let's make the email field's title red, just because we can

//- (NSDictionary *)emailField
//{
//    return @{@"textLabel.color": [UIColor redColor]};
//}

//we're happy with the layout and properties of our login form, but we
//want to add an additional button field at the end, so
//we've used the extraFields method

- (NSArray *)extraFields
{
    return @[
             
             //this field doesn't correspond to any property of the form
             //it's just an action button. the action will be called on first
             //object in the responder chain that implements the submitForm
             //method, which in this case would be the AppDelegate
             
             @{FXFormFieldTitle: @"Submit", FXFormFieldHeader: @"", FXFormFieldAction: @"submitLoginForm"},
             
             ];
}


@end
