//
//  pictureRow.h
//  project1
//
//  Created by Khoo Kah Lee on 1/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SmartImage.h"

@interface pictureRow : UITableViewCell

@property (strong, nonatomic) IBOutlet SmartImage *thumb1;
@property (strong, nonatomic) IBOutlet SmartImage *thumb2;
@property (strong, nonatomic) IBOutlet SmartImage *thumb3;
@end
