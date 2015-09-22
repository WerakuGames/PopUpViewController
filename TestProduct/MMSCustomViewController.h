//
//  MMSCustomViewController.h
//  TestProduct
//
//  Created by Ahmad Ashraf Azman on 9/22/15.
//  Copyright (c) 2015 Ahmad Ashraf Azman. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MMSCustomViewControllerDelegate;

@interface MMSCustomViewController : UIViewController

@property (assign, nonatomic) id <MMSCustomViewControllerDelegate>delegate;

@end

@protocol MMSCustomViewControllerDelegate<NSObject>
@optional
- (void)cancelButtonClicked:(MMSCustomViewController*)secondDetailViewController;
@end
