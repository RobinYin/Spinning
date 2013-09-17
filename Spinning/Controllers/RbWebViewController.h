//
//  RbWebViewController.h
//  Spinning
//
//  Created by Robin on 9/10/13.
//  Copyright (c) 2013 Robin. All rights reserved.
//

#import "RbBaseViewController.h"

enum {
    RbWebViewControllerAvailableActionsNone             = 0,
    RbWebViewControllerAvailableActionsOpenInSafari     = 1 << 0,
    RbWebViewControllerAvailableActionsMailLink         = 1 << 1,
    RbWebViewControllerAvailableActionsCopyLink         = 1 << 2
};

typedef NSUInteger RbWebViewControllerAvailableActions;
@interface RbWebViewController : RbBaseViewController
@property (nonatomic, retain) NSString *mid;
- (id)initWithAddress:(NSString*)urlString;
- (id)initWithURL:(NSURL*)URL;

@property (nonatomic, assign) RbWebViewControllerAvailableActions availableActions;
@end
