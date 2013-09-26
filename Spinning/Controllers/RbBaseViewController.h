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
@property (nonatomic, retain) UIButton *subleftBtn;
@property (nonatomic, retain) UIButton *subrightBtn;
- (void)configureNavigationView;
- (void)onLeftBtn:(id)sender;
- (void)onRightBtn:(id)sender;
- (void)onSubLeftBtn:(id)sender;
- (void)onSubRightBtn:(id)sender;

@end
