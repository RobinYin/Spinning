//
//  RbWebViewController.h
//  Spinning
//
//  Created by Robin on 9/10/13.
//  Copyright (c) 2013 Robin. All rights reserved.
//

#import "RbBaseViewController.h"
#import "ListHttpCmd.h"
typedef NSUInteger RbWebViewControllerAvailableActions;
@interface RbWebViewController : RbBaseViewController
@property (nonatomic, retain) NSString *mid;
@property (nonatomic, retain) ListModel *model;
- (id)initWithAddress:(NSString*)urlString;
- (id)initWithURL:(NSURL*)URL;
@end
