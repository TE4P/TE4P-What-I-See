//
//  TakePhoto.h
//  project1
//
//  Created by Khoo Kah Lee on 1/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#define serverURL @"http://www.te4p.com/ios/rcv.php"

@interface TakePhoto : UIViewController<UIImagePickerControllerDelegate>
{    
    UIImagePickerController *ipicker;
    
}
- (IBAction)SnapIt:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *SnapButton;
@property (weak, nonatomic) IBOutlet UIImageView *UploadPreview;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *UploadIndicator;

@end