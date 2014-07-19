//
//  CameraViewController.m
//  spire
//
//  Created by Jeffrey Zhang on 7/19/14.//  Copyright (c) 2014 Niveditha Jayasekar. All rights reserved.
//

#import "CameraViewController.h"
#import "PetPlacementViewController.h"

@interface CameraViewController ()

@end

@implementation CameraViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSLog(@"Media Info: %@", info);
//    NSString *mediaType = [info valueForKey:UIImagePickerControllerMediaType];
//    
//    if([mediaType isEqualToString:(NSString*)kUTTypeImage]) {
//        UIImage *photoTaken = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
//        
//        //Save Photo to library only if it wasnt already saved i.e. its just been taken
//        if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
//            UIImageWriteToSavedPhotosAlbum(photoTaken, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
//        }
    
    // Access the uncropped image from info dictionary
    UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    
    // Dismiss controller
    // TODO: pet placement controller
    [picker dismissModalViewControllerAnimated:YES];
    [self removePhotoObservers];
    
//    // Resize image
//    UIGraphicsBeginImageContext(CGSizeMake(640, 960));
//    [image drawInRect: CGRectMake(0, 0, 640, 960)];
//    UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
    
    
    //Crop the image to a square
    CGSize imageSize = image.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    if (width != height) {
        CGFloat newDimension = MIN(width, height);
        CGFloat widthOffset = (width - newDimension) / 2;
        CGFloat heightOffset = (height - newDimension) / 2;
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(newDimension, newDimension), NO, 0.);
        [image drawAtPoint:CGPointMake(-widthOffset, -heightOffset)
                 blendMode:kCGBlendModeCopy
                     alpha:1.];
        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    NSLog(@"%f, %f", image.size.width, image.size.height);
    // DONE WITH IMAGE
    
    PetPlacementViewController *pvc = [[PetPlacementViewController alloc] initWithImage:image];
    [self.navigationController pushViewController:pvc animated:YES];

    
    //
    // Upload image
    //NSData *imageData = UIImageJPEGRepresentation(image, 0.05f);
    //[self uploadImage:imageData];
    //[picker release];
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    UIAlertView *alert;
    //NSLog(@"Image:%@", image);
    if (error) {
        alert = [[UIAlertView alloc] initWithTitle:@"Error!"
                                           message:[error localizedDescription]
                                          delegate:nil
                                 cancelButtonTitle:@"OK"
                                 otherButtonTitles:nil];
        [alert show];
        //[alert release];
    }
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissModalViewControllerAnimated:YES];
}

- (void) addPhotoObservers {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeCameraOverlay) name:@"_UIImagePickerControllerUserDidCaptureItem" object:nil ];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addCameraOverlay) name:@"_UIImagePickerControllerUserDidRejectItem" object:nil ];
}

- (void) removePhotoObservers {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)addCameraOverlay {
    if (self.picker) {
        self.picker.cameraOverlayView = self.overlay;
        //[self.picker.cameraOverlayView addSubview:self.overlay];

    }
}

-(void)removeCameraOverlay {
    if (self.picker) {
        self.picker.cameraOverlayView = nil;
        //[self.overlay removeFromSuperview];
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        NSArray *media = [UIImagePickerController
                          availableMediaTypesForSourceType: UIImagePickerControllerSourceTypeCamera];
        
        if ([media containsObject:(NSString*)kUTTypeImage] == YES) {
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            //Create camera overlay
            CGRect f = picker.view.bounds;
            f.size.height -= picker.navigationBar.bounds.size.height;
            CGFloat barHeight = (f.size.height - f.size.width) / 2;
            UIGraphicsBeginImageContext(f.size);
            [[UIColor colorWithWhite:0 alpha:0.5] set];
            UIRectFillUsingBlendMode(CGRectMake(0, 0, f.size.width, barHeight), kCGBlendModeNormal);
            // TODO: fix bar height
            UIRectFillUsingBlendMode(CGRectMake(0, f.size.height - barHeight, f.size.width, barHeight), kCGBlendModeNormal);
            UIImage *overlayImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            UIImageView *overlayIV = [[UIImageView alloc] initWithFrame:f];
            overlayIV.image = overlayImage;
            self.overlay = overlayIV;
            self.picker = picker;
            [self addCameraOverlay];
            [self addPhotoObservers];
            
            //picker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
            [picker setMediaTypes:[NSArray arrayWithObject:(NSString *)kUTTypeImage]];
            
            picker.delegate = self;
            [self presentModalViewController:picker animated:YES];
            //[picker release];
            
        }
        else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Unsupported!"
                                                            message:@"Camera does not support photo capturing."
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            //[alert release];
        }
        
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Unavailable!"
                                                        message:@"This device does not have a camera."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        //[alert release];
    }
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
