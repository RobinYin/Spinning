//
//  CompanyViewController.m
//  Spinning
//
//  Created by Robin on 8/30/13.
//  Copyright (c) 2013 Robin. All rights reserved.
//

#import "CompanyViewController.h"

@interface CompanyViewController ()

@end

@implementation CompanyViewController

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
    [self configureAllViews];
	// Do any additional setup after loading the view.
}

- (void)onLeftBtn:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)onRightBtn:(id)sender
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configureAllViews
{
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"news_bg"]]];
    [self configureNavigationView];
    [self configureOtherView];
}

- (void)configureOtherView
{
    UILabel *label1 = [[[UILabel alloc] initWithFrame:CGRectMake(10, 54+ StatusHeaderHight, 300, 20)]autorelease];
    [label1 setFont: [UIFont systemFontOfSize:15]];
    [label1 setTextAlignment:UITextAlignmentCenter];
    [label1 setBackgroundColor:[UIColor clearColor]];
    [label1 setNumberOfLines:0];
    [label1 setTextColor:[UIColor whiteColor]];
    [label1 setText:@"中国针织工业协会"];
    [self.view addSubview:label1];
    
    UILabel *label2 = [[[UILabel alloc] initWithFrame:CGRectMake(10, 85+ StatusHeaderHight, 300, 96)]autorelease];
    [label2 setFont: [UIFont systemFontOfSize:13]];
    [label2 setBackgroundColor:[UIColor clearColor]];
    [label2 setNumberOfLines:0];
    [label2 setTextColor:[UIColor whiteColor]];
    [label2 setText:@"掌观中国针织系中国针织工业协会全力打造的行业服务平台。定位于打造专业、即时、客观、准确，具有公信力的信息服务，以新闻聚合、独家专访、热点话题讨论为特色逐步向移动互联延伸，及时收取协会通知、了解协会动态，成为每位业内人士的掌中宝。"];
    [self.view addSubview:label2];
}
- (void)configureNavigationView
{
    [super configureNavigationView];
    [self.headerImageView setImage:[UIImage imageNamed:@"title_bggd"]];
    [self.leftBtn setBackgroundImage:[UIImage imageNamed:@"title_btn_return_nomal"] forState:UIControlStateNormal];
    [self.leftBtn setBackgroundImage:[UIImage imageNamed:@"title_btn_return_pressed"] forState:UIControlStateHighlighted];
    [self.leftBtn setBackgroundImage:[UIImage imageNamed:@"title_btn_return_pressed"] forState:UIControlStateSelected];
    
    
    [self.rightBtn setBackgroundImage:[UIImage imageNamed:@"nav_left_btn.png"] forState:UIControlStateNormal];
    [self.rightBtn setBackgroundImage:[UIImage imageNamed:@"nav_left_btn_sel.png"] forState:UIControlStateHighlighted];
    [self.rightBtn setBackgroundImage:[UIImage imageNamed:@"nav_left_btn_sel.png"] forState:UIControlStateSelected];
}

@end
