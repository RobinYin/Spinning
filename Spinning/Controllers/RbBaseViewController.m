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
	// Do any additional setup after loading the view.
}


- (void)configureNavigationView
{
    
    [self.navigationController setNavigationBarHidden:YES];
    UIImageView *navbgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, NavigationHeight)];
    navbgImageView.image = [UIImage imageNamed:@"nav_bg"];
    navbgImageView.userInteractionEnabled = YES;
    
    UIImageView *headerbgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, NavigationHeight)];
    headerbgImageView.userInteractionEnabled = YES;
    [navbgImageView addSubview:headerbgImageView];
    self.headerImageView = headerbgImageView;
    RbSafeRelease(headerbgImageView);
    
    
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.backgroundColor = [UIColor clearColor];
    backBtn.frame = CGRectMake(NavigationHorizonGap, NavigationVerticalGap, NavigationBtnWith, NavigationBtnheight);
    [backBtn addTarget:self action:@selector(onLeftBtn:) forControlEvents:UIControlEventTouchUpInside];
    [navbgImageView addSubview:backBtn];
    self.leftBtn = backBtn;
    
    
    UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    nextBtn.backgroundColor = [UIColor clearColor];
    nextBtn.frame = CGRectMake(ScreenWidth - NavigationBtnWith -NavigationHorizonGap, 0, NavigationBtnWith, NavigationBtnheight);
    [nextBtn addTarget:self action:@selector(onRightBtn:) forControlEvents:UIControlEventTouchUpInside];
    [navbgImageView addSubview:nextBtn];
    self.rightBtn = nextBtn;
    
    [self.view addSubview:navbgImageView];
    
}

- (void)onLeftBtn:(id)sender
{
    
}

- (void)onRightBtn:(id)sender
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    RbSafeRelease(_rightBtn);
    RbSafeRelease(_leftBtn);
    RbSafeRelease(_headerImageView);
    RbSuperDealoc;
}

@end
