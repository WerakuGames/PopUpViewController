//
//  ViewController.m
//  TestProduct
//
//  Created by Ahmad Ashraf Azman on 9/21/15.
//  Copyright (c) 2015 Ahmad Ashraf Azman. All rights reserved.
//

#import "ViewController.h"
#import "MMSDetailViewController.h"
#import "MMSPopUpViewController.h"
#import "MMSCustomViewController.h"
@interface ViewController () <MMSCustomViewControllerDelegate>

@end

@implementation ViewController
@synthesize testButton = _testButton;
@synthesize customTestButton = _customTestButton;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void) viewDidAppear:(BOOL)animated{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)touchButton:(id)sender{
    UIButton *button = (UIButton *)sender;
    int bTag = (int)button.tag;
    if (bTag == 1) {
        MMSDetailViewController *detailViewController = [[MMSDetailViewController alloc] initWithNibName:@"MMSDetailViewController" bundle:nil];
        [self presentPopupViewController:detailViewController animationType:0];

    }else if(bTag == 2){
        MMSCustomViewController *detailViewController = [[MMSCustomViewController alloc] initWithNibName:@"MMSCustomViewController" bundle:nil];
        detailViewController.delegate = self;
        [self presentPopupViewController:detailViewController animationType:0];

    }
}

- (void)cancelButtonClicked:(MMSCustomViewController *)aMMSCustomViewController
{
    [self dismissPopupViewControllerWithanimationType:MMSPopupViewAnimationFade];
}

- (void)tableButtonClicked:(MMSCustomViewController*)secondDetailViewController withId:(int)tabId{
    NSLog(@"TabId %d",tabId);
}
@end
