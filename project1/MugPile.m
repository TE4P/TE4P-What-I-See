//
//  MugPile.m
//  project1
//
//  Created by Khoo Kah Lee on 1/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MugPile.h"
#import "pictureRow.h"
#import "SmartImage.h"
#import "LargeImage.h"

//#define kURL @"http://picasaweb.google.com/data/feed/api/user/flashout.net@gmail.com?alt=json"

#define kURL @"http://www.te4p.com/ios/feed.php"

@implementation MugPile



- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
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

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self loadDataFromServer];
}

-(void)loadDataFromServer
{
    NSURL *requestURL;
    requestURL = [NSURL URLWithString:kURL];
    
    
    NSURLRequest *requestObject;
    requestObject = [[NSURLRequest alloc] initWithURL:requestURL];
    
    NSURLConnection *theConnection=[[NSURLConnection alloc] initWithRequest:requestObject delegate:self];

    if (theConnection) {
        // Create the NSMutableData to hold the received data.
        // receivedData is an instance variable declared elsewhere.
        receivedData = [NSMutableData data];
    } else {
        // Inform the user that the connection failed.
        UIAlertView *a;
        a = [[UIAlertView alloc] initWithTitle:@"Error" message:@"I can't start the connection" delegate:nil cancelButtonTitle:@"OK lo~" otherButtonTitles:nil, nil];
        [a show];
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
    
    // do something with the data
    // receivedData is declared as a method instance elsewhere
   // NSLog(@"Succeeded! Received %d bytes of data",[receivedData length]);
    
    // convert receviedData into Array
//    NSDictionary *jsonArray =  [NSJSONSerialization JSONObjectWithData:receivedData options:NSJSONReadingMutableLeaves error:nil];
//    NSDictionary *entries = [[jsonArray objectForKey:@"feed"] objectForKey:@"entry"];
//    
//    urls = [[NSMutableArray alloc] init];
//    
//   
//    for (NSDictionary *entry in entries) {
////        NSString *thumbURL;
//         NSDictionary *mm= [[[entry objectForKey:@"media$group"] objectForKey:@"media$thumbnail"] objectAtIndex:0];
//        
//        [urls addObject:[mm objectForKey:@"url"]];
//        //NSLog(@"%@", [mm objectForKey:@"url"] );
//    }

    
    // convert receviedData into Array
    NSArray *jsonArray =  [NSJSONSerialization JSONObjectWithData:receivedData options:NSJSONReadingMutableLeaves error:nil];
    
    urls = [[NSMutableArray alloc] init];
    
    NSLog(@"%@", jsonArray);
    
    for (NSDictionary *entry in jsonArray) {
        [urls addObject:[entry objectForKey:@"url"]];
    }
    
    // redraw the table & thumbnails
    [self.tableView reloadData];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self resignFirstResponder];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return ceil([urls count] / 3.0);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    pictureRow *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[pictureRow alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    int idx = indexPath.row * 3;
 //   NSLog(@"set image to %@", [urls objectAtIndex:idx]);
    
//    NSURL *u = [NSURL URLWithString:[urls objectAtIndex:idx]];
//    NSData *d = [NSData dataWithContentsOfURL:u];
//    cell.thumb1.image = [UIImage imageWithData:d];
//    
//    cell.thumb2.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[urls objectAtIndex:idx+1]]]];
//    
//    cell.thumb3.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[urls objectAtIndex:idx+2]]]];
    [cell.thumb1 loadImage:[urls objectAtIndex:idx]];
    
    if (idx+1 < [urls count]) 
        [cell.thumb2 loadImage:[urls objectAtIndex:idx+1]];
    else
        cell.thumb2.image = nil;
    
    if (idx+2 < [urls count]) 
        [cell.thumb3 loadImage:[urls objectAtIndex:idx+2]];
    else
        cell.thumb3.image = nil;

    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}


// shake to refresh
-(BOOL)canBecomeFirstResponder
{
    return YES;
}

-(void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if (event.subtype == UIEventSubtypeMotionShake)
    {
        [self loadDataFromServer];
        // comemnt
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"%@", segue.identifier);
    UIImageView *target;
    pictureRow *parent = [[sender superview] superview];
    if ([segue.identifier isEqualToString:@"show1"])
        target = parent.thumb1;
    if ([segue.identifier isEqualToString:@"show2"])
        target = parent.thumb2;
    if ([segue.identifier isEqualToString:@"show3"])
        target = parent.thumb3;
    
    LargeImage *openingWin = [segue destinationViewController];
    
    openingWin.largeImage = target.image;    
}

//
//-(void)delete 
//{
//    NSString *url = [NSString stringWithFormat:@"http://.../del.php?id=XXXX"];
// [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
//}
@end
