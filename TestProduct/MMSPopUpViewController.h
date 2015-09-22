//
//  MMSPopUpViewController.h
//  TestProduct
//
//  Created by Ahmad Ashraf Azman on 9/21/15.
//  Copyright (c) 2015 Ahmad Ashraf Azman. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MMSPopUpBackgroundView;


// Enum on selection for Pop Up Animation.

typedef enum {
    MMSPopupViewAnimationFade = 0,
    MMSPopupViewAnimationSlideBottomTop = 1,
    MMSPopupViewAnimationSlideBottomBottom,
    MMSPopupViewAnimationSlideTopTop,
    MMSPopupViewAnimationSlideTopBottom,
    MMSPopupViewAnimationSlideLeftLeft,
    MMSPopupViewAnimationSlideLeftRight,
    MMSPopupViewAnimationSlideRightLeft,
    MMSPopupViewAnimationSlideRightRight,
} MMSPopupViewAnimation;

@interface UIViewController (MMSPopupViewController)

@property (nonatomic, retain) UIViewController *mms_popupViewController;
@property (nonatomic, retain) MMSPopUpBackgroundView *mms_popupBackgroundView;

- (void)presentPopupViewController:(UIViewController*)popupViewController animationType:(MMSPopupViewAnimation)animationType;
- (void)presentPopupViewController:(UIViewController*)popupViewController animationType:(MMSPopupViewAnimation)animationType dismissed:(void(^)(void))dismissed;
- (void)dismissPopupViewControllerWithanimationType:(MMSPopupViewAnimation)animationType;

@end
