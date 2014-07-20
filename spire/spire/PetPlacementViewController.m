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


- (void)saveImageToParse:(NSData *)data withCaption:(NSString *)caption {
    PFQuery *query = [PFQuery queryWithClassName:@"Pass"];
    PFUser *currentUser = [PFUser currentUser];
    [query whereKey:@"user" equalTo:currentUser];
    [query whereKeyDoesNotExist:@"complete"];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        PFFile *image = [PFFile fileWithName:@"image.png" data:data];
        [image saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                PFObject *photo = [PFObject objectWithClassName:@"Photo"];
                [photo setObject:image forKey:@"image"];
                [photo setObject:caption forKey:@"caption"];
                [photo saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (succeeded) {
                        [object addObject:image forKey:@"photos"];
                        [object saveInBackground];
                    } else {
                        NSLog(@"photo failed to save to parse: %@", error);
                    }
                }];
            } else {
                NSLog(@"image failed to save to parse: %@", error);
            }
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

- (void)setupTextEntry
{
    self.textEntry = [[UITextField alloc] initWithFrame:CGRectMake(10, SCREEN_WIDTH + 10, SCREEN_WIDTH - 20, 44)];
    //self.textEntry.layer.borderWidth = 1.0;
    //self.textEntry.layer.borderColor = [[UIColor grayColor] CGColor];
    [self.scrollView addSubview:self.textEntry];
    self.textEntry.placeholder = @"Caption";
    
    self.textEntry.delegate = self;
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
    [self saveImageToParse:UIImagePNGRepresentation(image) withCaption:self.textEntry.text];
    
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
    [self setupScrollView];
    [self setupTextEntry];
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
