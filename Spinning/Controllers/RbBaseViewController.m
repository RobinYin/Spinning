//
//  RbBaseViewController.m
//  Spinning
//
//  Created by Robin on 7/27/13.
//  Copyright (c) 2013 Robin. All rights reserved.
//

#import "RbBaseViewController.h"


@interface RbBaseViewController ()

@end

@implementation RbBaseViewController

@synthesize headerImageView = _headerImageView;
@synthesize leftBtn = _leftBtn;
@synthesize rightBtn = _rightBtn;
@synthesize subleftBtn = _subleftBtn;
@synthesize subrightBtn = _subrightBtn;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) ) {
         [self setNeedsStatusBarAppearanceUpdate];
    }
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}


- (void)configureNavigationView
{
    
    [self.navigationController setNavigationBarHidden:YES];
    UIImageView *navbgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, NavigationHeight)];
    navbgImageView.image = [UIImage imageNamed:@"nav_bg"];
    navbgImageView.userInteractionEnabled = YES;
    
    UIImageView *headerbgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, StatusHeaderHight, ScreenWidth, NavigationHeight)];
    headerbgImageView.userInteractionEnabled = YES;
    [navbgImageView addSubview:headerbgImageView];
    self.headerImageView = headerbgImageView;
    RbSafeRelease(headerbgImageView);
    
    
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.backgroundColor = [UIColor clearColor];
    backBtn.frame = CGRectMake(NavigationHorizonGap, StatusHeaderHight + NavigationVerticalGap, NavigationBtnWith, NavigationBtnheight);
    [backBtn addTarget:self action:@selector(onLeftBtn:) forControlEvents:UIControlEventTouchUpInside];
    [navbgImageView addSubview:backBtn];
    self.leftBtn = backBtn;
    
    UIButton *subackBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    subackBtn.backgroundColor = [UIColor clearColor];
    subackBtn.frame = CGRectMake(NavigationHorizonGap + NavigationBtnWith+NavigationHorizonGap, StatusHeaderHight + NavigationVerticalGap, NavigationBtnWith, NavigationBtnheight);
    [subackBtn addTarget:self action:@selector(onSubLeftBtn:) forControlEvents:UIControlEventTouchUpInside];
    [navbgImageView addSubview:subackBtn];
    self.subleftBtn = subackBtn;
    
    
    UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    nextBtn.backgroundColor = [UIColor clearColor];
    nextBtn.frame = CGRectMake(ScreenWidth - NavigationBtnWith -NavigationHorizonGap, StatusHeaderHight + NavigationVerticalGap, NavigationBtnWith, NavigationBtnheight);
    [nextBtn addTarget:self action:@selector(onRightBtn:) forControlEvents:UIControlEventTouchUpInside];
    [navbgImageView addSubview:nextBtn];
    self.rightBtn = nextBtn;
    
    UIButton *subnextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    subnextBtn.backgroundColor = [UIColor clearColor];
    subnextBtn.frame = CGRectMake(ScreenWidth - 2*NavigationBtnWith -2*NavigationHorizonGap, StatusHeaderHight + NavigationVerticalGap, NavigationBtnWith, NavigationBtnheight);
    [subnextBtn addTarget:self action:@selector(onSubRightBtn:) forControlEvents:UIControlEventTouchUpInside];
    [navbgImageView addSubview:subnextBtn];
    self.subrightBtn = subnextBtn;
    
    [self.view addSubview:navbgImageView];
    RbSafeRelease(navbgImageView);
    
}

- (void)onLeftBtn:(id)sender
{
    
}

- (void)onRightBtn:(id)sender
{
    
}

- (void)onSubLeftBtn:(id)sender
{
    
}
- (void)onSubRightBtn:(id)sender
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    RbSafeRelease(_subrightBtn);
    RbSafeRelease(_subleftBtn);
    RbSafeRelease(_rightBtn);
    RbSafeRelease(_leftBtn);
    RbSafeRelease(_headerImageView);
    RbSuperDealoc;
}

@end
