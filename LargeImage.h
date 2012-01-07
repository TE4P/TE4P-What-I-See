//
//  LargeImage.h
//  project1
//
//  Created by Khoo Kah Lee on 1/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LargeImage : UIViewController
- (IBAction)Close:(id)sender;
- (IBAction)SaveImage:(id)sender;

@property (strong, nonatomic) UIImage *largeImage;

@property (weak, nonatomic) IBOutlet UIImageView *myImageView;

@end
