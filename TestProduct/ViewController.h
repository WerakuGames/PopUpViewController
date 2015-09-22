//
//  ViewController.h
//  TestProduct
//
//  Created by Ahmad Ashraf Azman on 9/21/15.
//  Copyright (c) 2015 Ahmad Ashraf Azman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
{
    IBOutlet UIButton *testButton;
    IBOutlet UIButton *customTestButton;
}

@property (nonatomic, retain) IBOutlet UIButton *testButton;
@property (nonatomic, retain) IBOutlet UIButton *customTestButton;

-(IBAction)touchButton:(id)sender;

@end

