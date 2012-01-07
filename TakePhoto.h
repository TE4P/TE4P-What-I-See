//
//  TakePhoto.h
//  project1
//
//  Created by Khoo Kah Lee on 1/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#define serverURL @"http://10.1.1.187/ios/rcv.php"

@interface TakePhoto : UIViewController<UIImagePickerControllerDelegate>
{    
    UIImagePickerController *ipicker;
    
}
- (IBAction)SnapIt:(id)sender;

@end