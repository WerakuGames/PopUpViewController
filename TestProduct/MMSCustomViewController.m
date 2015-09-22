//
//  MMSCustomViewController.m
//  TestProduct
//
//  Created by Ahmad Ashraf Azman on 9/22/15.
//  Copyright (c) 2015 Ahmad Ashraf Azman. All rights reserved.
//

#import "MMSCustomViewController.h"

@interface MMSCustomViewController ()<UITableViewDataSource, UITableViewDelegate>{
    NSArray *watchArray1;
    NSArray *watchArray2;
}

@end

@implementation MMSCustomViewController
@synthesize delegate;


- (void)viewDidLoad {
    [super viewDidLoad];
    watchArray1 = [NSArray arrayWithObjects:
                  @"WishList 1",
                  @"WishList 2",
                  @"WishList 3",
                  @"WishList 4",
                  @"WishList 5",
                  @"WishList 6",
                  @"WishList 7",
                  @"WishList 8",
                  @"WishList 9",
                  nil];
    watchArray2 = [NSArray arrayWithObjects:
               @"Custom Wishlist",
               nil];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)closePopup:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(cancelButtonClicked:)]) {
        [self.delegate cancelButtonClicked:self];
    }
}

- (void) tableDidClicked:(int)sender{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(tableButtonClicked:withId:)]) {
        [self.delegate tableButtonClicked:self withId:sender];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return [watchArray1 count];
            break;
            
        default:
            return [watchArray2 count];
            break;
    };
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:CellIdentifier];
    }
    
    switch (indexPath.section) {
        case 0:
            cell.textLabel.text = [watchArray1 objectAtIndex:indexPath.row];
            break;
            
        default:
            cell.textLabel.text = [watchArray2 objectAtIndex:indexPath.row];
            break;
    }
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return @"Watchlist1";
            break;
            
        default:
            return @"Watchlist2";
            break;
    };
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0: {
            [self tableDidClicked:(int)indexPath.row];
            
        }
            break;
            
        default: {
            [self tableDidClicked:(int)indexPath.row];
            
        }
            break;
    }
    [tableView deselectRowAtIndexPath:tableView.indexPathForSelectedRow animated:YES];
}





/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
