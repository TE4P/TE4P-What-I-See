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
    // check cache
    app = [[UIApplication sharedApplication] delegate];
    UIImage *img = [app.imagecache objectForKey:url];
    if (!img)
    {
        // cancel previous download
        if (theConnection) [theConnection cancel];
           
        NSLog(@"download %@", url);
        NSURL *requestURL;
        requestURL = [NSURL URLWithString:url];
        
        NSURLRequest *requestObject;
        requestObject = [[NSURLRequest alloc] initWithURL:requestURL cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:30.0];
        
        
        theConnection=[[NSURLConnection alloc] initWithRequest:requestObject delegate:self];
        self.image = [UIImage imageNamed:@"notfound.jpg"]; 
        
        if (theConnection) {
            // Create the NSMutableData to hold the received data.
            // receivedData is an instance variable declared elsewhere.
            receivedData = [NSMutableData data];
        }
    }
    else
    {
        NSLog(@"using cache %@", url);
        self.image = img;
    }
    
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    // Append the new data to receivedData.
    // receivedData is an instance variable declared elsewhere.
    [receivedData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [app.imagecache setValue:[UIImage imageWithData:receivedData] forKey:[connection.originalRequest.URL absoluteString]];
    self.image = [UIImage imageWithData:receivedData];
    
    theConnection = nil;
    receivedData = nil;
}

@end
