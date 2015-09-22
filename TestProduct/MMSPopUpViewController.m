//
//  MMSPopUpViewController.m
//  TestProduct
//
//  Created by Ahmad Ashraf Azman on 9/21/15.
//  Copyright (c) 2015 Ahmad Ashraf Azman. All rights reserved.
//

#import "MMSPopUpViewController.h"
#import "MMSPopUpBackgroundView.h"
#import <objc/runtime.h>
#import <QuartzCore/QuartzCore.h>

#define kPopupModalAnimationDuration 0.35
#define kMMSPopupViewController @"kMMSPopupViewController"
#define kMMSPopupBackgroundView @"kMMSPopupBackgroundView"
#define kMMSSourceViewTag 23941
#define kMMSPopupViewTag 23942
#define kMMSOverlayViewTag 23945

@interface UIViewController (MMSPopupViewControllerPrivate)
- (UIView*)topView;
- (void)presentPopupView:(UIView*)popupView;
@end

static NSString *MMSPopupViewDismissedKey = @"MMSPopupViewDismissed";

////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Public

@implementation UIViewController (MMSPopUpViewController)

static void * const keypath = (void*)&keypath;

// :)
// To understand more of associated object. Please take on http://nshipster.com/associated-objects/.

- (UIViewController*)mms_popupViewController {
    return objc_getAssociatedObject(self, kMMSPopupViewController);
}

- (void)setMms_popupViewController:(UIViewController *)mms_popupViewController {
    objc_setAssociatedObject(self, kMMSPopupViewController, mms_popupViewController, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
}

- (MMSPopUpBackgroundView*)mms_popupBackgroundView {
    return objc_getAssociatedObject(self, kMMSPopupBackgroundView);
}

- (void)setMms_popupBackgroundView:(MMSPopUpBackgroundView *)mms_popupBackgroundView {
    objc_setAssociatedObject(self, kMMSPopupBackgroundView, mms_popupBackgroundView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
}

- (void)presentPopupViewController:(UIViewController*)popupViewController animationType:(MMSPopupViewAnimation)animationType dismissed:(void(^)(void))dismissed
{
    self.mms_popupViewController = popupViewController;
    [self presentPopupView:popupViewController.view animationType:animationType dismissed:dismissed];
}

- (void)presentPopupViewController:(UIViewController*)popupViewController animationType:(MMSPopupViewAnimation)animationType
{
    [self presentPopupViewController:popupViewController animationType:animationType dismissed:nil];
}

- (void)dismissPopupViewControllerWithanimationType:(MMSPopupViewAnimation)animationType
{
    UIView *sourceView = [self topView];
    UIView *popupView = [sourceView viewWithTag:kMMSPopupViewTag];
    UIView *overlayView = [sourceView viewWithTag:kMMSOverlayViewTag];
    
    switch (animationType) {
        case MMSPopupViewAnimationSlideBottomTop:
        case MMSPopupViewAnimationSlideBottomBottom:
        case MMSPopupViewAnimationSlideTopTop:
        case MMSPopupViewAnimationSlideTopBottom:
        case MMSPopupViewAnimationSlideLeftLeft:
        case MMSPopupViewAnimationSlideLeftRight:
        case MMSPopupViewAnimationSlideRightLeft:
        case MMSPopupViewAnimationSlideRightRight:
            [self slideViewOut:popupView sourceView:sourceView overlayView:overlayView withAnimationType:animationType];
            break;
            
        default:
            [self fadeViewOut:popupView sourceView:sourceView overlayView:overlayView];
            break;
    }
}



////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark View Handling

- (void)presentPopupView:(UIView*)popupView animationType:(MMSPopupViewAnimation)animationType
{
    [self presentPopupView:popupView animationType:animationType dismissed:nil];
}

- (void)presentPopupView:(UIView*)popupView animationType:(MMSPopupViewAnimation)animationType dismissed:(void(^)(void))dismissed
{
    UIView *sourceView = [self topView];
    sourceView.tag = kMMSSourceViewTag;
    popupView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin |UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin;
    popupView.tag = kMMSPopupViewTag;
    
    // check if source view controller is not in destination
    if ([sourceView.subviews containsObject:popupView]) return;
    
    // customize popupView
    popupView.layer.shadowPath = [UIBezierPath bezierPathWithRect:popupView.bounds].CGPath;
    popupView.layer.masksToBounds = NO;
    popupView.layer.shadowOffset = CGSizeMake(5, 5);
    popupView.layer.shadowRadius = 5;
    popupView.layer.shadowOpacity = 0.5;
    popupView.layer.shouldRasterize = YES;
    popupView.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    
    // Add semi overlay
    UIView *overlayView = [[UIView alloc] initWithFrame:sourceView.bounds];
    overlayView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    overlayView.tag = kMMSOverlayViewTag;
    overlayView.backgroundColor = [UIColor clearColor];
    
    // BackgroundView
    self.mms_popupBackgroundView = [[MMSPopUpBackgroundView alloc] initWithFrame:sourceView.bounds];
    self.mms_popupBackgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.mms_popupBackgroundView.backgroundColor = [UIColor clearColor];
    self.mms_popupBackgroundView.alpha = 0.0f;
    [overlayView addSubview:self.mms_popupBackgroundView];
    
    // Make the Background Clickable
    UIButton * dismissButton = [UIButton buttonWithType:UIButtonTypeCustom];
    dismissButton.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    dismissButton.backgroundColor = [UIColor clearColor];
    dismissButton.frame = sourceView.bounds;
    [overlayView addSubview:dismissButton];
    
    popupView.alpha = 0.0f;
    [overlayView addSubview:popupView];
    [sourceView addSubview:overlayView];
    
    [dismissButton addTarget:self action:@selector(dismissPopupViewControllerWithanimation:) forControlEvents:UIControlEventTouchUpInside];
    switch (animationType) {
        case MMSPopupViewAnimationSlideBottomTop:
        case MMSPopupViewAnimationSlideBottomBottom:
        case MMSPopupViewAnimationSlideTopTop:
        case MMSPopupViewAnimationSlideTopBottom:
        case MMSPopupViewAnimationSlideLeftLeft:
        case MMSPopupViewAnimationSlideLeftRight:
        case MMSPopupViewAnimationSlideRightLeft:
        case MMSPopupViewAnimationSlideRightRight:
            dismissButton.tag = animationType;
            [self slideViewIn:popupView sourceView:sourceView overlayView:overlayView withAnimationType:animationType];
            break;
        default:
            dismissButton.tag = MMSPopupViewAnimationFade;
            [self fadeViewIn:popupView sourceView:sourceView overlayView:overlayView];
            break;
    }
    
    [self setDismissedCallback:dismissed];
}

-(UIView*)topView {
    UIViewController *recentView = self;
    
    while (recentView.parentViewController != nil) {
        recentView = recentView.parentViewController;
    }
    return recentView.view;
}

- (void)dismissPopupViewControllerWithanimation:(id)sender
{
    if ([sender isKindOfClass:[UIButton class]]) {
        UIButton* dismissButton = sender;
        switch (dismissButton.tag) {
            case MMSPopupViewAnimationSlideBottomTop:
            case MMSPopupViewAnimationSlideBottomBottom:
            case MMSPopupViewAnimationSlideTopTop:
            case MMSPopupViewAnimationSlideTopBottom:
            case MMSPopupViewAnimationSlideLeftLeft:
            case MMSPopupViewAnimationSlideLeftRight:
            case MMSPopupViewAnimationSlideRightLeft:
            case MMSPopupViewAnimationSlideRightRight:
                [self dismissPopupViewControllerWithanimationType:(int)dismissButton.tag];
                break;
            default:
                [self dismissPopupViewControllerWithanimationType:MMSPopupViewAnimationFade];
                break;
        }
    } else {
        [self dismissPopupViewControllerWithanimationType:MMSPopupViewAnimationFade];
    }
}

//////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Animations

#pragma mark --- Slide

// Refer on some sources on how to do slide animations

- (void)slideViewIn:(UIView*)popupView sourceView:(UIView*)sourceView overlayView:(UIView*)overlayView withAnimationType:(MMSPopupViewAnimation)animationType
{
    // Generating Start and Stop Positions
    CGSize sourceSize = sourceView.bounds.size;
    CGSize popupSize = popupView.bounds.size;
    CGRect popupStartRect;
    switch (animationType) {
        case MMSPopupViewAnimationSlideBottomTop:
        case MMSPopupViewAnimationSlideBottomBottom:
            popupStartRect = CGRectMake((sourceSize.width - popupSize.width) / 2,
                                        sourceSize.height,
                                        popupSize.width,
                                        popupSize.height);
            
            break;
        case MMSPopupViewAnimationSlideLeftLeft:
        case MMSPopupViewAnimationSlideLeftRight:
            popupStartRect = CGRectMake(-sourceSize.width,
                                        (sourceSize.height - popupSize.height) / 2,
                                        popupSize.width,
                                        popupSize.height);
            break;
            
        case MMSPopupViewAnimationSlideTopTop:
        case MMSPopupViewAnimationSlideTopBottom:
            popupStartRect = CGRectMake((sourceSize.width - popupSize.width) / 2,
                                        -popupSize.height,
                                        popupSize.width,
                                        popupSize.height);
            break;
            
        default:
            popupStartRect = CGRectMake(sourceSize.width,
                                        (sourceSize.height - popupSize.height) / 2,
                                        popupSize.width,
                                        popupSize.height);
            break;
    }
    CGRect popupEndRect = CGRectMake((sourceSize.width - popupSize.width) / 2,
                                     (sourceSize.height - popupSize.height) / 2,
                                     popupSize.width,
                                     popupSize.height);
    
    // Set starting properties
    popupView.frame = popupStartRect;
    popupView.alpha = 1.0f;
    [UIView animateWithDuration:kPopupModalAnimationDuration delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
        [self.mms_popupViewController viewWillAppear:NO];
        self.mms_popupBackgroundView.alpha = 1.0f;
        popupView.frame = popupEndRect;
    } completion:^(BOOL finished) {
        [self.mms_popupViewController viewDidAppear:NO];
    }];
}



- (void)slideViewOut:(UIView*)popupView sourceView:(UIView*)sourceView overlayView:(UIView*)overlayView withAnimationType:(MMSPopupViewAnimation)animationType
{
    // Generating Start and Stop Positions
    CGSize sourceSize = sourceView.bounds.size;
    CGSize popupSize = popupView.bounds.size;
    CGRect popupEndRect;
    switch (animationType) {
        case MMSPopupViewAnimationSlideBottomTop:
        case MMSPopupViewAnimationSlideTopTop:
            popupEndRect = CGRectMake((sourceSize.width - popupSize.width) / 2,
                                      -popupSize.height,
                                      popupSize.width,
                                      popupSize.height);
            break;
        case MMSPopupViewAnimationSlideBottomBottom:
        case MMSPopupViewAnimationSlideTopBottom:
            popupEndRect = CGRectMake((sourceSize.width - popupSize.width) / 2,
                                      sourceSize.height,
                                      popupSize.width,
                                      popupSize.height);
            break;
        case MMSPopupViewAnimationSlideLeftRight:
        case MMSPopupViewAnimationSlideRightRight:
            popupEndRect = CGRectMake(sourceSize.width,
                                      popupView.frame.origin.y,
                                      popupSize.width,
                                      popupSize.height);
            break;
        default:
            popupEndRect = CGRectMake(-popupSize.width,
                                      popupView.frame.origin.y,
                                      popupSize.width,
                                      popupSize.height);
            break;
    }
    
    [UIView animateWithDuration:kPopupModalAnimationDuration delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^{
        [self.mms_popupViewController viewWillDisappear:NO];
        popupView.frame = popupEndRect;
        self.mms_popupBackgroundView.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [popupView removeFromSuperview];
        [overlayView removeFromSuperview];
        [self.mms_popupViewController viewDidDisappear:NO];
        self.mms_popupViewController = nil;
        
        id dismissed = [self dismissedCallback];
        if (dismissed != nil)
        {
            ((void(^)(void))dismissed)();
            [self setDismissedCallback:nil];
        }
    }];
}

#pragma mark --- Fade

- (void)fadeViewIn:(UIView*)popupView sourceView:(UIView*)sourceView overlayView:(UIView*)overlayView
{
    // Generating Start and Stop Positions
    CGSize sourceSize = sourceView.bounds.size;
    CGSize popupSize = popupView.bounds.size;
    CGRect popupEndRect = CGRectMake((sourceSize.width - popupSize.width) / 2,
                                     (sourceSize.height - popupSize.height) / 2,
                                     popupSize.width,
                                     popupSize.height);
    
    // Set starting properties
    popupView.frame = popupEndRect;
    popupView.alpha = 0.0f;
    
    [UIView animateWithDuration:kPopupModalAnimationDuration animations:^{
        [self.mms_popupViewController viewWillAppear:NO];
        self.mms_popupBackgroundView.alpha = 0.5f;
        popupView.alpha = 1.0f;
    } completion:^(BOOL finished) {
        [self.mms_popupViewController viewDidAppear:NO];
    }];
}

- (void)fadeViewOut:(UIView*)popupView sourceView:(UIView*)sourceView overlayView:(UIView*)overlayView
{
    [UIView animateWithDuration:kPopupModalAnimationDuration animations:^{
        [self.mms_popupViewController viewWillDisappear:NO];
        self.mms_popupBackgroundView.alpha = 0.0f;
        popupView.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [popupView removeFromSuperview];
        [overlayView removeFromSuperview];
        [self.mms_popupViewController viewDidDisappear:NO];
        self.mms_popupViewController = nil;
        
        id dismissed = [self dismissedCallback];
        if (dismissed != nil)
        {
            ((void(^)(void))dismissed)();
            [self setDismissedCallback:nil];
        }
    }];
}

#pragma mark -
#pragma mark Category Accessors

#pragma mark --- Dismissed

- (void)setDismissedCallback:(void(^)(void))dismissed
{
    objc_setAssociatedObject(self, &MMSPopupViewDismissedKey, dismissed, OBJC_ASSOCIATION_RETAIN);
}

- (void(^)(void))dismissedCallback
{
    return objc_getAssociatedObject(self, &MMSPopupViewDismissedKey);
}


@end
