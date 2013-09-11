//
//  RbBaseViewController.h
//  Spinning
//
//  Created by Robin on 7/27/13.
//  Copyright (c) 2013 Robin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RbBaseViewController : UIViewController

@property (nonatomic, retain) UIImageView *headerImageView;
@property (nonatomic, retain) UIButton *leftBtn;
@property (nonatomic, retain) UIButton *rightBtn;

- (void)configureNavigationView;
- (void)onLeftBtn:(id)sender;
- (void)onRightBtn:(id)sender;


@end
