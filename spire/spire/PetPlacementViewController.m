//
//  PetPlacementViewController.m
//  spire
//
//  Created by Jeffrey Zhang on 7/19/14.
//  Copyright (c) 2014 Niveditha Jayasekar. All rights reserved.
//

#import "PetPlacementViewController.h"
#import <Parse/Parse.h>

#define SCREEN_WIDTH ((([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait) || ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown)) ? [[UIScreen mainScreen] bounds].size.width : [[UIScreen mainScreen] bounds].size.height)
#define SCREEN_HEIGHT ((([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait) || ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown)) ? [[UIScreen mainScreen] bounds].size.height : [[UIScreen mainScreen] bounds].size.width)


@interface PetPlacementViewController ()

@end

@implementation PetPlacementViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)getVenues:(NSString *)url withCallback:(void (^)(NSString *locName)) callback
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:10];
    
    [request setHTTPMethod: @"GET"];
    
    __block NSDictionary *json;
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               json = [NSJSONSerialization JSONObjectWithData:data
                                                                      options:0
                                                                        error:nil];
                               NSLog(@"%@", json[@"response"][@"venues"][0]);
                               
                               callback(json[@"response"][@"venues"][0][@"name"]);
                           }];
}

- (void)getLocation:(void (^)(NSNumber *latitude, NSNumber *longitude, NSString *locName)) callback
{
    // TODO: take in callback, call with lat/long/name
    NSNumber *latitude = @3.14;
    NSNumber *longitude = @2.71;
    NSString *locName = @"Medium HQ";
    if ([CLLocationManager locationServicesEnabled]) {
        latitude = [NSNumber numberWithFloat:self.locationManager.location.coordinate.latitude];
        longitude = [NSNumber numberWithFloat:self.locationManager.location.coordinate.longitude];
        NSString *_4squareId = @"02K3GC4J1Y34WDZG4XIWHBSF2WJKOHIOMSTPWTWQVMPFALL2";
        NSString *_4squareSecret = @"XYHXKNHOVBPTX4KLXR1QID4QNA2RSMXZZQML32ANKP1H4VHJ";
        NSString *locFormat = @"https://api.foursquare.com/v2/venues/search?client_id=%@&client_secret=%@&v=20130815&ll=%@,%@";
        NSString *queryAddr = [NSString stringWithFormat:locFormat,_4squareId,_4squareSecret,latitude,longitude];
        [self getVenues:queryAddr withCallback:^(NSString *locName) {
            callback(latitude, longitude, locName);
        }];
    } else {
        NSLog(@"Fake location used");
        callback(latitude, longitude, locName);
    }
}

- (void)updatePet:(PFObject *)pet withDropped:(BOOL)dropped withLat:(NSNumber *)latitude withLong:(NSNumber *)longitude withName:(NSString *)locName
{
    [pet setObject:latitude forKey:@"latitude"];
    [pet setObject:longitude forKey:@"longitude"];
    [pet setObject:locName forKey:@"locName"];
    if (dropped) {
        [pet setObject:[NSNull null] forKey:@"currentUser"];
        [pet incrementKey:@"passes"];
    }
    // TODO: update miles
    [pet saveInBackground];
}

- (void)addPhoto:(NSData *)photoData withUser:(PFUser *)user withPet:(PFObject *)pet withLat:(NSNumber *)latitude withLong:(NSNumber *)longitude withName:(NSString *)locName withCaption:(NSString *)caption
{
    PFFile *image = [PFFile fileWithName:@"image.png" data:photoData];
    [image saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            PFObject *photo = [PFObject objectWithClassName:@"Photo"];
            [photo setObject:user forKey:@"user"];
            [photo setObject:pet forKey:@"pet"];
            [photo setObject:image forKey:@"image"];
            [photo setObject:caption forKey:@"caption"];
            [photo setObject:latitude forKey:@"latitude"];
            [photo setObject:longitude forKey:@"longitude"];
            [photo setObject:locName forKey:@"locName"];
            [photo setObject:@1 forKey:@"first"];
            // TODO: set first only if first taken by that (user, pet)
            [photo saveInBackground];
        }
    }];
}

- (void)saveToParse:(NSData *)photoData withCaption:(NSString *)caption withDropped:(BOOL) dropped
{
    PFQuery *query = [PFQuery queryWithClassName:@"Pet"];
    PFUser *currentUser = [PFUser currentUser];
    [query whereKey:@"currentUser" equalTo:currentUser];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *pet, NSError *error) {
        [self getLocation:^(NSNumber *latitude, NSNumber *longitude, NSString *locName) {
            [self updatePet:pet withDropped:dropped withLat:latitude withLong:longitude withName:locName];
            [self addPhoto:photoData withUser:currentUser withPet:pet withLat:latitude withLong:longitude withName:locName withCaption:caption];
        }];
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

- (void)didFinishPickingImage:(UIImage *)image{
    self.image = image;
    [self setupImagePetContainer];

}

- (void)setupScrollView
{
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT); //scroll view occupies full parent view!
    //specify CGRect bounds in place of self.view.bounds to make it as a portion of parent view!
    
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT * 1.5);   //scroll view size
    
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
    float screen_width = SCREEN_WIDTH;
    UIView *container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, screen_width)];
    self.container = container;
    [self setupImage];
    [self setupPet];
    [self.scrollView addSubview:container];
}

- (void)setupImage
{
    float screen_width = SCREEN_WIDTH;
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, screen_width, screen_width)];
    imgView.image = self.image;
    [self.container addSubview:imgView];
}

- (IBAction) imageMoved:(id) sender withEvent:(UIEvent *) event
{
    CGPoint point = [[[event allTouches] anyObject] locationInView:self.container];
    // TODO: use actual dims of pet image
    float max_height = SCREEN_WIDTH - 20;
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
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake((self.view.frame.size.width - 190.5)/2 + 30, 47, 127.5, 127.5);
    [button addTarget:self action:@selector(imageTouched:withEvent:) forControlEvents:UIControlEventTouchDown];
    [button addTarget:self action:@selector(imageMoved:withEvent:) forControlEvents:UIControlEventTouchDragInside];
    [button addTarget:self action:@selector(imageReleased:withEvent:) forControlEvents:UIControlEventTouchUpInside|UIControlEventTouchUpOutside];
    [button setImage:[UIImage imageNamed:@"tempavatar.png"] forState:UIControlStateNormal];
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
    self.textEntry = [[UITextField alloc] initWithFrame:CGRectMake(10, SCREEN_WIDTH + 10, SCREEN_WIDTH - 20, 44)];
    //self.textEntry.layer.borderWidth = 1.0;
    //self.textEntry.layer.borderColor = [[UIColor grayColor] CGColor];
    [self.scrollView addSubview:self.textEntry];
    self.textEntry.placeholder = @"Caption";
    
    self.textEntry.delegate = self;
    
    // TODO: HEY LUCY STYLE THIS THINGY
    self.toggleDrop = [[UISwitch alloc] initWithFrame:CGRectMake(10, SCREEN_WIDTH + 10 + 44 + 10, SCREEN_WIDTH - 20, 44)];
    [self.scrollView addSubview:self.toggleDrop];
    
    // label for togglign drop, doesn't work
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 50, SCREEN_WIDTH + 10 + 44 + 10 + 44, SCREEN_WIDTH - 20, 44)];
//    [self.scrollView addSubview:label];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    [self.scrollView setContentOffset:CGPointMake(0, textField.frame.origin.y) animated:YES];
}


- (UIImage *) imageWithView:(UIView *)view
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
    [self saveToParse:UIImagePNGRepresentation(image) withCaption:self.textEntry.text withDropped:self.toggleDrop.on];
    
    // go back to home
    [self.tabBarController setSelectedIndex:0];
}

- (void)setupSubmitButton
{
    self.submitButton = [[UIButton alloc] initWithFrame:CGRectMake(10, SCREEN_HEIGHT - 100, SCREEN_WIDTH - 20, 44)];
    [self.submitButton setTitle:@"Submit" forState:UIControlStateNormal];
    [self.submitButton setTitleColor:[UIColor blueColor]
                            forState:UIControlStateNormal];
    self.submitButton.layer.borderWidth = 1.0;
    self.submitButton.layer.borderColor = [[UIColor grayColor] CGColor];
    
    [self.submitButton addTarget:self action:@selector(buttonTouched:withEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.scrollView addSubview:self.submitButton];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    
    
    YCameraViewController *camController = [[YCameraViewController alloc] initWithNibName:@"YCameraViewController" bundle:nil];
    self.cvc = camController;
    camController.delegate=self;
    
    [self presentViewController:camController animated:NO completion:^{
        // completion code
    }];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    [self.locationManager startUpdatingLocation];
    [self setupScrollView];
    [self setupForm];
    [self setupSubmitButton];
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
