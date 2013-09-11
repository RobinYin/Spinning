//
//  LoginViewController.m
//  Spinning
//
//  Created by Robin on 8/30/13.
//  Copyright (c) 2013 Robin. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()<UITextFieldDelegate>

@end

@implementation LoginViewController

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
    [self configureInputViews];
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

- (void)configureInputViews
{
    UITextField* field1 = [[UITextField alloc]initWithFrame:CGRectMake(LoginViewHorizontalGap, LoginViewOriginY   , LoginViewTextWidth, LoginViewTextHeight)];
    [field1 setBorderStyle:UITextBorderStyleRoundedRect];
    field1.font = [UIFont systemFontOfSize:16];
    field1.delegate = self;
    field1.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [field1 setPlaceholder:@"账号:"];
    [field1 setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:field1];
    [field1 release];
    
    
    UITextField* field2 = [[UITextField alloc]initWithFrame:CGRectMake(LoginViewHorizontalGap, LoginViewOriginY+ LoginViewTextHeight + LoginViewVerticalGap   , LoginViewTextWidth, LoginViewTextHeight)];
    [field2 setBorderStyle:UITextBorderStyleRoundedRect];
    field2.font = [UIFont systemFontOfSize:16];
    field2.delegate = self;
    field2.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [field2 setPlaceholder:@"密码:"];
    [field2 setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:field2];
    [field2 release];
}

#pragma mark -
#pragma TextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
}

@end
