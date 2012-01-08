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


-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSLog(@"picked");
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    NSURL *url = [NSURL URLWithString:serverURL];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:UIImageJPEGRepresentation(image, 75)];
    
    SnapButton.hidden = YES;
    ipicker.view.hidden = YES;
    
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
        
        SnapButton.hidden = NO;
        ipicker.view.hidden = NO;
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }];
    //                    sendSynchronousRequest:request returningResponse:&response error:&err];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    
}

- (void)viewDidUnload
{
    [self setSnapButton:nil];
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
