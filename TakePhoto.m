//
//  TakePhoto.m
//  project1
//
//  Created by Khoo Kah Lee on 1/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TakePhoto.h"

@implementation TakePhoto
@synthesize SnapButton;
@synthesize UploadPreview;
@synthesize UploadIndicator;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/
-(void)viewWillAppear:(BOOL)animated
{
    [self performSelector:@selector(showStaturBar) withObject:self afterDelay:0.1];
}

-(void)showStaturBar
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        ipicker = [[UIImagePickerController alloc] init];
        [ipicker setSourceType:UIImagePickerControllerSourceTypeCamera];
        CGRect f = self.view.frame;
        f.origin.x = 0; f.origin.y = 0;
        [ipicker.view setFrame:f];
        ipicker.showsCameraControls = NO;
        [ipicker setDelegate:self];
        
        [self.view insertSubview:ipicker.view atIndex:0];
        
    }
    else
    {
        // do something to tell user its uploaded
        UIAlertView *a;
        a = [[UIAlertView alloc] initWithTitle:@"Oops" message:@"Your device does not have camera." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [a show];
        
    }
}

- (UIImage *)scaleImage:(UIImage *)image toSize:(CGSize)targetSize {
    //If scaleFactor is not touched, no scaling will occur      
    CGFloat scaleFactor = 1.0;
    
    //Deciding which factor to use to scale the image (factor = targetSize / imageSize)
    if (image.size.width > targetSize.width || image.size.height > targetSize.height)
        if (!((scaleFactor = (targetSize.width / image.size.width)) > (targetSize.height / image.size.height))) //scale to fit width, or
            scaleFactor = targetSize.height / image.size.height; // scale to fit heigth.
    
    UIGraphicsBeginImageContext(targetSize); 
    
    //Creating the rect where the scaled image is drawn in
    CGRect rect = CGRectMake((targetSize.width - image.size.width * scaleFactor) / 2,
                             (targetSize.height -  image.size.height * scaleFactor) / 2,
                             image.size.width * scaleFactor, image.size.height * scaleFactor);
    
    //Draw the image into the rect
    [image drawInRect:rect];
    
    //Saving the image, ending image context
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return scaledImage;
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSLog(@"picked");
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    // resize image
    CGSize newSize = CGSizeMake(600, 600);
    
    UIImage *image = [self scaleImage:[info objectForKey:UIImagePickerControllerOriginalImage] toSize:newSize];

    NSURL *url = [NSURL URLWithString:serverURL];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:UIImageJPEGRepresentation(image, 75)];
    
    // hide camera 
    [UIView transitionWithView:self.view duration:0.5 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
            SnapButton.hidden = YES;
            ipicker.view.hidden = YES;
            
            UploadPreview.hidden = NO;
            UploadPreview.image = image;
    } completion:^(BOOL finished) {
        [UploadIndicator startAnimating];
    }];
    
    // send in background
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *err) {
        NSString *ret = [NSString stringWithUTF8String:[data bytes]];
        NSLog(@"responseData: %@", ret);  
        if ([ret isEqualToString:@"OK"])
        {
            // do something to tell user its uploaded
            UIAlertView *a;
            a = [[UIAlertView alloc] initWithTitle:@"Success" message:@"I have uploaded your photo." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [a show];
        }
        else
        {
            UIAlertView *a;
            a = [[UIAlertView alloc] initWithTitle:@"Error" message:ret delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [a show];
        }
        
        [UIView transitionWithView:self.view duration:0.5 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
            SnapButton.hidden = NO;
            ipicker.view.hidden = NO;
            UploadPreview.hidden = YES;
            [UploadIndicator stopAnimating];
        } completion:nil];
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }];
}

- (void)viewDidUnload
{
    [self setSnapButton:nil];
    [self setUploadPreview:nil];
    [self setUploadIndicator:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)SnapIt:(id)sender {
    [ipicker takePicture];
}
@end
