//
//  SmartImage.h
//  project1
//
//  Created by Khoo Kah Lee on 1/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SmartImage : UIImageView
{
    NSMutableData *receivedData;
}
- (void)loadImage:(NSString *)url;
@end
