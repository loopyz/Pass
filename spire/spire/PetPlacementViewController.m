//
//  PetPlacementViewController.m
//  spire
//
//  Created by Jeffrey Zhang on 7/19/14.
//  Copyright (c) 2014 Niveditha Jayasekar. All rights reserved.
//

#import "PetPlacementViewController.h"
#import "VenueTableViewController.h"
#import "NoPetsErrorView.h"

@interface PetPlacementViewController () {
    CGFloat screenWidth;
    CGFloat screenHeight;
}

@end

@implementation PetPlacementViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        screenWidth = screenRect.size.width;
        screenHeight = screenRect.size.height;
        // Custom initialization
      self.dropButtonActivated = NO;
        self.facebookShareActivated = NO;
        self.tumblrShareActivated = NO;
        self.twitterShareActivated = NO;
        self.instagramShareActivated = NO;
    }
    return self;
}


- (void)updatePet:(PFObject *)pet withDropped:(BOOL)dropped withGeoPoint:(PFGeoPoint *)newGeoPoint withName:(NSString *)locName
{
    PFGeoPoint *oldGeoPoint = [pet objectForKey:@"geoPoint"];

    // TODO: Deprecated, remove.
    //[pet setObject:latitude forKey:@"latitude"];
    //[pet setObject:longitude forKey:@"longitude"];
    [pet setObject:newGeoPoint forKey:@"geoPoint"];
    [pet setObject:locName forKey:@"locName"];
    if (dropped) {
        [pet setObject:[NSNull null] forKey:@"currentUser"];
        [pet incrementKey:@"passes"];
    }

    // Calculate real miles from old location.
    NSNumber *miles = [NSNumber numberWithDouble:[oldGeoPoint distanceInMilesTo:newGeoPoint]];
    [pet incrementKey:@"miles" byAmount:miles];
    [pet saveInBackground];
}

- (void)addPhoto:(NSData *)photoData withUser:(PFUser *)user withPet:(PFObject *)pet withGeoPoint:(PFGeoPoint *)geoPoint withName:(NSString *)locName withCaption:(NSString *)caption
{
    if ([caption isEqualToString:@"Add a caption..."]) {
        caption = locName;
    }
    PFFile *image = [PFFile fileWithName:@"image.png" data:photoData];
    [image saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            PFObject *photo = [PFObject objectWithClassName:@"Photo"];
            [photo setObject:user forKey:@"user"];
            [photo setObject:pet forKey:@"pet"];
            [photo setObject:image forKey:@"image"];
            [photo setObject:caption forKey:@"caption"];
            // TODO: deprecated, remove.
            //[photo setObject:latitude forKey:@"latitude"];
            //[photo setObject:longitude forKey:@"longitude"];
            [photo setObject:geoPoint forKey:@"geoPoint"];
            [photo setObject:locName forKey:@"locName"];
            
            PFQuery *query = [PFQuery queryWithClassName:@"Photo"];
            [query whereKey:@"user" equalTo:user];
            [query whereKey:@"pet" equalTo:pet];
            [query countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
                NSNumber *first = number > 0 ? @0 : @1;
                [photo setObject:first forKey:@"first"];
                [photo saveInBackground];
            }];
        }
    }];
}

- (void)saveToParse:(NSData *)photoData withCaption:(NSString *)caption withDropped:(BOOL) dropped
{
    PFUser *currentUser = [PFUser currentUser];

    // Callback to call when location determined.
    void (^callback)(PFGeoPoint *geoPoint, NSString *locName) = ^void(PFGeoPoint *geoPoint, NSString *locName) {
        [self updatePet:self.pet withDropped:dropped withGeoPoint:geoPoint withName:locName];
        [self addPhoto:photoData withUser:currentUser withPet:self.pet withGeoPoint:geoPoint withName:locName withCaption:caption];
        
        if (dropped) {
            PFPush *push = [[PFPush alloc] init];
            [push setChannel:@"PetsNearby"];
            [push setMessage:[NSString stringWithFormat:@"A pet's been dropped at %@", locName]];
            [push sendPushInBackground];
        }
        // go back to home tab
        [self.tabBarController setSelectedIndex:0];
    };


    // Query for current location as GeoPoint.
    [PFGeoPoint geoPointForCurrentLocationInBackground:^(PFGeoPoint *geoPoint, NSError *error) {
        __block NSString *locName = @"Medium HQ";
        if (error) {
            // TODO: Handle when location disabled.
            NSLog(@"Fake location used");
            geoPoint = [PFGeoPoint geoPointWithLatitude:3.14 longitude:2.71];
            callback(geoPoint, locName);
        }

        // Push VenueViewController for selecting location.
        VenueTableViewController *vtvc = [[VenueTableViewController alloc] initWithGeoPoint:geoPoint andCallback:^(NSDictionary *selectedVenue) {
            if (selectedVenue == nil) {
                NSLog(@"Location not chosen");
            } else {
                locName = selectedVenue[@"name"];
            }
            callback(geoPoint, locName);
        }];
        [self presentViewController:vtvc animated:YES completion:nil];
    }];
}

- (void)yCameraControllerDidCancel {
    //[self.cvc dismissModalViewControllerAnimated:YES];
    // TODO: return to home page
    
    [self.tabBarController setSelectedIndex:0];

    
}

- (void)yCameraControllerdidSkipped {
    //[self.cvc dismissModalViewControllerAnimated:YES];
    // TODO: return to home page
    [self.tabBarController setSelectedIndex:0];


}

- (void)didFinishPickingImage:(UIImage *)image
{
    self.image = image;
    [self setupImagePetContainer];

}

- (void)setupScrollView
{
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.frame = CGRectMake(0, 0, screenWidth, screenHeight); //scroll view occupies full parent view!
    //specify CGRect bounds in place of self.view.bounds to make it as a portion of parent view!
    
    self.scrollView.contentSize = CGSizeMake([Util screenWidth], [Util screenHeight] + 180);   //scroll view size
    
    self.scrollView.showsVerticalScrollIndicator = NO;    // to hide scroll indicators!
    
    self.scrollView.showsHorizontalScrollIndicator = YES; //by default, it shows!
    
    self.scrollView.scrollEnabled = YES;     //say "NO" to disable scroll
    
    self.scrollView.canCancelContentTouches = NO;
    self.scrollView.delaysContentTouches = NO;
    
//    self.scrollView.touchesShouldCancelInContentView = ^(UIView *view) {
//        return view != self.container;
//    };
    
    [self.view addSubview:self.scrollView];               //adding to parent view!
}

- (void)setupImagePetContainer
{
    float screen_width = [Util screenWidth];
    UIView *container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, screen_width)];
    self.container = container;
    [self setupImage];
    [self setupPet];
    [self.scrollView addSubview:container];
}

- (void)setupImage
{
    float screen_width = [Util screenWidth];
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, screen_width, screen_width)];
    imgView.image = self.image;
    [self.container addSubview:imgView];
}

- (IBAction) imageMoved:(id) sender withEvent:(UIEvent *) event
{
    CGPoint point = [[[event allTouches] anyObject] locationInView:self.container];
    // TODO: use actual dims of pet image
    float max_height = [Util screenWidth] - 20;
    if (point.y > max_height) {
        point.y = max_height;
    }
    UIControl *control = sender;
    control.center = point;
}

- (IBAction) imageTouched:(id) sender withEvent:(UIEvent *) event
{
    self.scrollView.scrollEnabled = NO;
}

- (IBAction) imageReleased:(id) sender withEvent:(UIEvent *) event
{
    self.scrollView.scrollEnabled = YES;
}

- (void)setupPet
{
    NSString *petType = [self.pet objectForKey:@"type"];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake((self.view.frame.size.width - 190.5)/2 + 30, 47, 127.5, 127.5);
    [button addTarget:self action:@selector(imageTouched:withEvent:) forControlEvents:UIControlEventTouchDown];
    [button addTarget:self action:@selector(imageMoved:withEvent:) forControlEvents:UIControlEventTouchDragInside];
    [button addTarget:self action:@selector(imageReleased:withEvent:) forControlEvents:UIControlEventTouchUpInside|UIControlEventTouchUpOutside];
    [button setImage:[UIImage imageNamed:[petType stringByAppendingString:@".png"]] forState:UIControlStateNormal];
    button.exclusiveTouch = YES;

    [self.container addSubview:button];
    /*
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 190.5)/2 + 30, 47, 127.5, 127.5)];
    imgView.image = [UIImage imageNamed:@"tempavatar.png"];
    [self.scrollView addSubview:imgView];
     */
}


- (void)setupForm
{
    if (self.textEntry != nil) {
        self.textEntry.text = @"Add a caption...";
        return;
    }
    // HEY STYLING AFTER THIS POINT OCCURS ONCE
    
    self.textEntry = [[UITextView alloc] initWithFrame:CGRectMake(0, screenWidth, screenHeight, 100)];
    self.textEntry.layer.borderWidth = 1.0;
    self.textEntry.layer.borderColor =  [[UIColor colorWithRed:228/255.0f green:228/255.0f blue:228/255.0f alpha:1.0f] CGColor];
  
    self.textEntry.layer.shadowColor = [[UIColor whiteColor] CGColor];
    self.textEntry.layer.shadowOpacity = 1.0;
    self.textEntry.layer.shadowRadius = 0;
    self.textEntry.layer.shadowOffset = CGSizeMake(0.0, 1.0);
  
  self.textEntry.textColor = [UIColor colorWithRed:137/255.0f green:137/255.0f blue:137/255.0f alpha:1.0f];
  self.textEntry.font = [UIFont fontWithName:@"Avenir" size:15.0f];
    
    self.textEntry.inputAccessoryView = self.keyboardToolbar;
    // setup extra keyboard done button
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
  
    [self.scrollView addSubview:self.textEntry];
    self.textEntry.editable = YES;
     //self.textEntry.placeholder = @"Insert Caption";
  
    self.textEntry.delegate = self;
  
  // Do any additional setup after loading the view.
  [self setupDropButton];
    [self setupShareButtons];
  
    // completely got rid of labels
//  UIImageView *dropPetImage = [[UIImageView alloc] initWithFrame:CGRectMake(5, SCREEN_WIDTH + 115, 50, 53)];
//  dropPetImage.image = [UIImage imageNamed:@"pettab.png"];
//  [self.scrollView addSubview:dropPetImage];
//  
//  UILabel *dropLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, SCREEN_WIDTH + 125, 300, 30)];
//  
//  [dropLabel setTextColor:[UIColor colorWithRed:169/255.0f green:169/255.0f blue:169/255.0f alpha:1.0f]];
//  [dropLabel setBackgroundColor:[UIColor clearColor]];
//  [dropLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:18]];
//  
//  dropLabel.text = @"Drop your pet?";
//  dropLabel.lineBreakMode = NSLineBreakByWordWrapping;
//  dropLabel.numberOfLines = 0;
//  [self.scrollView addSubview:dropLabel];
//  
//    // TODO: HEY LUCY STYLE THIS THINGY
//    self.toggleDrop = [[UISwitch alloc] initWithFrame:CGRectMake(230, SCREEN_WIDTH + 125, SCREEN_WIDTH - 20, 44)];
//    [self.scrollView addSubview:self.toggleDrop];
  
    // label for togglign drop, doesn't work
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 50, SCREEN_WIDTH + 10 + 44 + 10 + 44, SCREEN_WIDTH - 20, 44)];
//    [self.scrollView addSubview:label];
}

- (void)setupDropButton
{
  self.dropButton = [UIButton buttonWithType:UIButtonTypeCustom];
  [self.dropButton setTitle:@"Show View" forState:UIControlStateNormal];
  
  self.dropButton.frame = CGRectMake(0, self.textEntry.frame.origin.y + self.textEntry.frame.size.height + 35, 320, 67);
  [self.dropButton addTarget:self action:@selector(dropPetButtonTouched) forControlEvents:UIControlEventTouchUpInside];
  
  UIImage *btnImage;
  if (self.dropButtonActivated) {
    btnImage = [UIImage imageNamed:@"keeppetbutton.png"];
  }
  else {
    btnImage = [UIImage imageNamed:@"droppetbutton.png"];
  }
  
  [self.dropButton setImage:btnImage forState:UIControlStateNormal];
  self.dropButton.contentMode = UIViewContentModeScaleToFill;
  
  [self.scrollView addSubview:self.dropButton];
}

- (void)setupShareButtons
{
    self.shareBG = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.textEntry.frame.origin.y + self.textEntry.frame.size.height + 120, 320, 84)];
    self.shareBG.image = [UIImage imageNamed:@"buttonform.png"];
    [self.scrollView addSubview:self.shareBG];
    [self setupFacebookButton];
    [self setupInstagramButton];
    [self setupTwitterButton];
    [self setupTumblrButton];
}

- (void)dropPetButtonTouched
{
  UIImage *btnImage;
  
  if (self.dropButtonActivated) {
    self.dropButtonActivated = NO;
    btnImage = [UIImage imageNamed:@"droppetbutton.png"];
  }
  else {
    self.dropButtonActivated = YES;
    btnImage = [UIImage imageNamed:@"keeppetbutton.png"];
  }
  
  [self.dropButton setImage:btnImage forState:UIControlStateNormal];
  
  // TODO: BUTTON TO DO OTHER STUFF WITH PET
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    [self.scrollView setContentOffset:CGPointMake(0, textField.frame.origin.y) animated:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
  [self.scrollView setContentOffset:CGPointZero animated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
  [textField resignFirstResponder];
  return NO;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
  [self.scrollView setContentOffset:CGPointMake(0, textView.frame.origin.y) animated:YES];
  if ([textView.text isEqualToString:@"Add a caption..."]) {
    textView.text = @"";
    textView.textColor = [UIColor blackColor]; //optional
  }
  [textView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
  if ([textView.text isEqualToString:@""]) {
    textView.text = @"Add a caption...";
    textView.textColor = [UIColor lightGrayColor]; //optional
  }
  [textView resignFirstResponder];
}

- (BOOL) textViewShouldBeginEditing:(UITextView *)textView
{
  self.textEntry.text = @"";
  return YES;
}

-(void) textViewDidChange:(UITextView *)textView
{
  if(self.textEntry.text.length == 0){
    self.textEntry.text = @"Comment";
    [self.textEntry resignFirstResponder];
  }
}


- (UIImage *)imageWithView:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, [[UIScreen mainScreen] scale]);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

- (IBAction) buttonTouched:(id) sender withEvent:(UIEvent *) event
{
    UIImage *image = [self imageWithView:self.container];
    NSLog(@"%f, %f", image.size.height, image.size.width);
    // submit image to parse
    [self saveToParse:UIImagePNGRepresentation(image) withCaption:self.textEntry.text withDropped:self.dropButtonActivated];
    
}

- (void)shareOnFacebook
{
    UIImage *btnImage;
    
    if (self.facebookShareActivated) {
        self.facebookShareActivated = NO;
        btnImage = [UIImage imageNamed:@"facebooksharebutton.png"];
    }
    else {
        self.facebookShareActivated = YES;
        btnImage = [UIImage imageNamed:@"facebooksharebuttonactive.png"];
    }
    
    [self.facebookButton setImage:btnImage forState:UIControlStateNormal];
}

- (void)shareOnTwitter
{
    UIImage *btnImage;
    
    if (self.twitterShareActivated) {
        self.twitterShareActivated = NO;
        btnImage = [UIImage imageNamed:@"twittersharebutton.png"];
    }
    else {
        self.twitterShareActivated = YES;
        btnImage = [UIImage imageNamed:@"twittersharebuttonactive.png"];
    }
    
    [self.twitterButton setImage:btnImage forState:UIControlStateNormal];
}

- (void)shareOnInstagram
{
    UIImage *btnImage;
    
    if (self.instagramShareActivated) {
        self.instagramShareActivated = NO;
        btnImage = [UIImage imageNamed:@"instagramsharebutton.png"];
    }
    else {
        self.instagramShareActivated = YES;
        btnImage = [UIImage imageNamed:@"instagramsharebuttonactive.png"];
    }
    
    [self.instagramButton setImage:btnImage forState:UIControlStateNormal];
}

- (void)shareOnTumblr
{
    UIImage *btnImage;
    
    if (self.tumblrShareActivated) {
        self.tumblrShareActivated = NO;
        btnImage = [UIImage imageNamed:@"tumblrsharebutton.png"];
    }
    else {
        self.tumblrShareActivated = YES;
        btnImage = [UIImage imageNamed:@"tumblrsharebuttonactive.png"];
    }
    
    [self.tumblrButton setImage:btnImage forState:UIControlStateNormal];
}

- (void)setupFacebookButton
{
    // Do any additional setup after loading the view.
    self.facebookButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.facebookButton setTitle:@"Show View" forState:UIControlStateNormal];
    
    
    self.facebookButton.frame = CGRectMake(15, self.textEntry.frame.origin.y + self.textEntry.frame.size.height + 120 + 7.5, 81, 43/2);
    [self.facebookButton addTarget:self action:@selector(shareOnFacebook) forControlEvents:UIControlEventTouchUpInside];
    
    UIImage *btnImage = [UIImage imageNamed:@"facebooksharebutton.png"];
    [self.facebookButton setImage:btnImage forState:UIControlStateNormal];
    self.facebookButton.contentMode = UIViewContentModeScaleToFill;
    
    [self.scrollView addSubview:self.facebookButton];
}

- (void)setupTwitterButton
{
    // Do any additional setup after loading the view.
    self.twitterButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.twitterButton setTitle:@"Show View" forState:UIControlStateNormal];
    
    
    self.twitterButton.frame = CGRectMake(screenWidth/2 + 15, self.textEntry.frame.origin.y + self.textEntry.frame.size.height + 120 + 8.5, 62.5, 17.5);
    [self.twitterButton addTarget:self action:@selector(shareOnTwitter) forControlEvents:UIControlEventTouchUpInside];
    
    UIImage *btnImage = [UIImage imageNamed:@"twittersharebutton.png"];
    [self.twitterButton setImage:btnImage forState:UIControlStateNormal];
    self.twitterButton.contentMode = UIViewContentModeScaleToFill;
    
    [self.scrollView addSubview:self.twitterButton];
}

- (void)setupInstagramButton
{
    // Do any additional setup after loading the view.
    self.instagramButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.instagramButton setTitle:@"Show View" forState:UIControlStateNormal];
    
    
    self.instagramButton.frame = CGRectMake(15, self.textEntry.frame.origin.y + self.textEntry.frame.size.height + 120 + 47.5, 80, 21.5);
    [self.instagramButton addTarget:self action:@selector(shareOnInstagram) forControlEvents:UIControlEventTouchUpInside];
    
    UIImage *btnImage = [UIImage imageNamed:@"instagramsharebutton.png"];
    [self.instagramButton setImage:btnImage forState:UIControlStateNormal];
    self.instagramButton.contentMode = UIViewContentModeScaleToFill;
    
    [self.scrollView addSubview:self.instagramButton];
}

- (void)setupTumblrButton
{
    // Do any additional setup after loading the view.
    self.tumblrButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.tumblrButton setTitle:@"Show View" forState:UIControlStateNormal];
    
    
    self.tumblrButton.frame = CGRectMake(screenWidth/2 + 15, self.textEntry.frame.origin.y + self.textEntry.frame.size.height + 120 + 47.5, 62, 21);
    [self.tumblrButton addTarget:self action:@selector(shareOnTumblr) forControlEvents:UIControlEventTouchUpInside];
    
    UIImage *btnImage = [UIImage imageNamed:@"tumblrsharebutton.png"];
    [self.tumblrButton setImage:btnImage forState:UIControlStateNormal];
    self.tumblrButton.contentMode = UIViewContentModeScaleToFill;
    
    [self.scrollView addSubview:self.tumblrButton];
}

- (void)setupSubmitButton
{
  // Do any additional setup after loading the view.
  UIButton *submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
  [submitButton setTitle:@"Show View" forState:UIControlStateNormal];
    
  
  submitButton.frame = CGRectMake(0, self.shareBG.frame.origin.y + self.shareBG.frame.size.height + 30, 320, 47.5);
  [submitButton addTarget:self action:@selector(buttonTouched:withEvent:) forControlEvents:UIControlEventTouchUpInside];
  
  UIImage *btnImage = [UIImage imageNamed:@"submitbutton.png"];
  [submitButton setImage:btnImage forState:UIControlStateNormal];
  submitButton.contentMode = UIViewContentModeScaleToFill;
    
    self.scrollView.contentSize = CGSizeMake(screenWidth, self.shareBG.frame.origin.y + self.shareBG.frame.size.height + 50 + 120 + 82);
    
  [self.scrollView addSubview:submitButton];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    
    [Util currentPetWithBlock:^(PFObject *pet, NSError *error) {
        self.pet = pet;
    }];
    
    [self setupForm];
    [self setupSubmitButton];
    YCameraViewController *camController = [[YCameraViewController alloc] initWithNibName:@"YCameraViewController" bundle:nil];
    self.cvc = camController;
    camController.delegate = self;
  
  // setup extra keyboard done button
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
  
    [self presentViewController:camController animated:NO completion:^{
        // completion code
    }];
    
}

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
  
  [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
  [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification *)notification {
  [UIView beginAnimations:nil context:NULL];
  [UIView setAnimationDuration:0.3];
  
  CGRect frame = self.keyboardToolbar.frame;
  frame.origin.y = self.view.frame.size.height - 260.0;
  self.keyboardToolbar.frame = frame;
  
  [UIView commitAnimations];
}

- (void)keyboardWillHide:(NSNotification *)notification {
  //NSString *textFromKeyboard = self.textEntry.text;
  [self.textEntry resignFirstResponder];
}

-(void)clearText{
  [self.textEntry resignFirstResponder];
  self.textEntry.text = @"";
}

#pragma mark IBActions

- (IBAction)hideKeyboard:(id)sender {
	[self.textEntry resignFirstResponder];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

-(void)dismissKeyboard {
    [self.textEntry resignFirstResponder];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupScrollView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
  
  self.keyboardToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
  self.keyboardToolbar.barStyle = UIBarStyleBlackTranslucent;
  self.keyboardToolbar.items = [NSArray arrayWithObjects:
                         [[UIBarButtonItem alloc]initWithTitle:@"Clear" style:UIBarButtonItemStyleBordered target:self action:@selector(clearNumberPad)],
                         [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                         [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(keyboardWillHide:)],
                         nil];
  [self.keyboardToolbar sizeToFit];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
