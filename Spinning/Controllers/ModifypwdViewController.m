//
//  ModifypwdViewController.m
//  Spinning
//
//  Created by Robin on 9/18/13.
//  Copyright (c) 2013 Robin. All rights reserved.
//

#import "ModifypwdViewController.h"
#import "ModifypwdHttpCmd.h"
@interface ModifypwdViewController ()<UITextFieldDelegate,RbHttpDelegate>
@property (nonatomic, retain) UITextField *usernameTextField;
@property (nonatomic, retain) UITextField *passwordTextField;
@property (nonatomic, retain) UITextField *oldpwdTextField;
@property (nonatomic, retain)RbHttpCmd *httpCmd;

@end

@implementation ModifypwdViewController
@synthesize usernameTextField = _usernameTextField;
@synthesize passwordTextField = _passwordTextField;
@synthesize oldpwdTextField = _oldpwdTextField;
@synthesize httpCmd = _httpCmd;

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
    UITextField* field1 = [[UITextField alloc]initWithFrame:CGRectMake(ModifypwdViewHorizontalGap, ModifypwdOriginY   , ModifypwdViewTextWidth, ModifypwdViewTextHeight)];
    self.usernameTextField = field1;
    [field1 setBorderStyle:UITextBorderStyleRoundedRect];
    field1.font = [UIFont systemFontOfSize:16];
    field1.delegate = self;
    field1.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [field1 setPlaceholder:@"账号:"];
    [field1 setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:field1];
    [field1 release];
    
    
    UITextField* field2 = [[UITextField alloc]initWithFrame:CGRectMake(LoginViewHorizontalGap, ModifypwdOriginY+ ModifypwdViewTextHeight + ModifypwdViewVerticalGap, ModifypwdViewTextWidth, ModifypwdViewTextHeight)];
    self.oldpwdTextField = field2;
    [field2 setSecureTextEntry:YES];
    [field2 setBorderStyle:UITextBorderStyleRoundedRect];
    field2.font = [UIFont systemFontOfSize:16];
    field2.delegate = self;
    field2.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [field2 setPlaceholder:@"原始密码:"];
    [field2 setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:field2];
    [field2 release];
    
    
    UITextField* field3 = [[UITextField alloc]initWithFrame:CGRectMake(LoginViewHorizontalGap, ModifypwdOriginY+ 2*ModifypwdViewTextHeight + 2*ModifypwdViewVerticalGap, ModifypwdViewTextWidth, ModifypwdViewTextHeight)];
    self.passwordTextField = field3;
    [field3 setSecureTextEntry:YES];
    [field3 setBorderStyle:UITextBorderStyleRoundedRect];
    field3.font = [UIFont systemFontOfSize:16];
    field3.delegate = self;
    field3.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [field3 setPlaceholder:@"新密码:"];
    [field3 setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:field3];
    [field3 release];
    
    UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextBtn setFrame:CGRectMake(92.25, 208, 135.5, 27)];
    [nextBtn setBackgroundImage:[UIImage imageNamed:@"btn_normal"] forState:UIControlStateNormal];
    [nextBtn setTitle:@"确定" forState:UIControlStateNormal];
    [nextBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [nextBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [nextBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -30, 0, 0)];
    [nextBtn addTarget:self action:@selector(next:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextBtn];
}

- (void)next:(id)sender
{
    [self.usernameTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
    if ([self canNext]) {
        [self onModifyData];
    }else
    {
        [self.view makeToast:@"输入的信息不能为空。"];
    }
}

- (BOOL)canNext
{
    return [self.oldpwdTextField.text length] &&[self.usernameTextField.text length] &&[self.passwordTextField.text length] ;
}

- (void)onModifyData
{
    RbHttpClient *client = [RbHttpClient sharedInstance];
    ModifypwdHttpCmd *cmd = [[[ModifypwdHttpCmd alloc]init]autorelease];
    cmd.username = [self.usernameTextField text];
    cmd.password = md5(self.passwordTextField.text);
    cmd.oldpwd = md5(self.oldpwdTextField.text);
    self.httpCmd = cmd;
    cmd.delegate = self;
    [client onPostCmdAsync:self.httpCmd];
}


- (void) httpResult:(id)cmd  error:(NSError*)error
{
    NSLog(@"%@",NSStringFromClass([cmd class]));
    NSString *msg = nil;
    ModifypwdHttpCmd *httpcmd = (ModifypwdHttpCmd *)cmd;
    if (error) {
        msg = [error localizedDescription];
    }else
    {
        msg = httpcmd.model.msg;
    }
    [self.view makeToast:[NSString stringWithFormat:@"%@",msg]];
    if ([httpcmd.model.code isEqualToString:kSpinningHttpKeyOk]) {
        [RbUser sharedInstance].password = md5(self.passwordTextField.text);
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

#pragma mark -
#pragma UITextField Delegate

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    if ([self canNext]) {
        [self onModifyData];
    }else
    {
        [self.view makeToast:@"输入的信息不能为空。"];
    }
    return YES;
}


- (void)dealloc
{
    RbSafeRelease(_httpCmd);
    RbSafeRelease(_passwordTextField);
    RbSafeRelease(_usernameTextField);
    RbSafeRelease(_oldpwdTextField);
    RbSuperDealoc;
}

@end
