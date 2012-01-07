//
//  SmartImage.m
//  project1
//
//  Created by Khoo Kah Lee on 1/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SmartImage.h"

@implementation SmartImage


- (void)loadImage:(NSString *)url
{
    
    NSURL *requestURL;
    requestURL = [NSURL URLWithString:url];
    
    NSURLRequest *requestObject;
    requestObject = [[NSURLRequest alloc] initWithURL:requestURL cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:30.0];
 
    NSURLConnection *theConnection=[[NSURLConnection alloc] initWithRequest:requestObject delegate:self];
    self.image = [UIImage imageNamed:@"notfound.jpg"]; 
    
    if (theConnection) {
        // Create the NSMutableData to hold the received data.
        // receivedData is an instance variable declared elsewhere.
        receivedData = [NSMutableData data];
    }
        
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    // Append the new data to receivedData.
    // receivedData is an instance variable declared elsewhere.
    [receivedData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    self.image = [UIImage imageWithData:receivedData];
    receivedData = nil;
}

@end
