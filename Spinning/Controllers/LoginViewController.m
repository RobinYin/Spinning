//
//  LoginViewController.m
//  Spinning
//
//  Created by Robin on 8/30/13.
//  Copyright (c) 2013 Robin. All rights reserved.
//

#import "LoginViewController.h"
#import "LoginHttpCmd.h"
@interface LoginViewController ()<UITextFieldDelegate,RbHttpDelegate>
@property (nonatomic, retain) UITextField *usernameTextField;
@property (nonatomic, retain) UITextField *passwordTextField;
@property (nonatomic, retain)RbHttpCmd *httpCmd;
@end

@implementation LoginViewController
@synthesize usernameTextField = _usernameTextField;
@synthesize passwordTextField = _passwordTextField;
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
    UITextField* field1 = [[UITextField alloc]initWithFrame:CGRectMake(LoginViewHorizontalGap, LoginViewOriginY + StatusHeaderHight  , LoginViewTextWidth, LoginViewTextHeight)];
    self.usernameTextField = field1;
    [field1 setBorderStyle:UITextBorderStyleRoundedRect];
    field1.font = [UIFont systemFontOfSize:16];
    field1.delegate = self;
    field1.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [field1 setPlaceholder:@"账号:"];
    [field1 setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:field1];
    [field1 release];
    
    
    UITextField* field2 = [[UITextField alloc]initWithFrame:CGRectMake(LoginViewHorizontalGap, field1.frame.origin.y+ field1.frame.size.height + LoginViewVerticalGap   , LoginViewTextWidth, LoginViewTextHeight)];
    self.passwordTextField = field2;
    [field2 setSecureTextEntry:YES];
    [field2 setBorderStyle:UITextBorderStyleRoundedRect];
    field2.font = [UIFont systemFontOfSize:16];
    field2.delegate = self;
    field2.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [field2 setPlaceholder:@"密码:"];
    [field2 setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:field2];
    [field2 release];
    
    UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextBtn setFrame:CGRectMake(92.25, field2.frame.origin.y+ field2.frame.size.height + LoginViewVerticalGap , 135.5, 27)];
    [nextBtn setBackgroundImage:[UIImage imageNamed:@"btn_normal"] forState:UIControlStateNormal];
    [nextBtn setTitle:@"登录" forState:UIControlStateNormal];
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
        [self onLoginData];
    }else
    {
//        [self.view makeToast:@"输入的反馈信息不能为空。"];
        [YRDropdownView showDropdownInView:self.view
                                     title:@"提示！"
                                    detail:@"输入的反馈信息不能为空！"
                                     image:[UIImage imageNamed:@"dropdown-alert"]
                                  animated:YES
                                 hideAfter:TipTime];
    }
}

- (BOOL)canNext
{
    return [self.usernameTextField.text length] &&[self.passwordTextField.text length] ;
}

- (void)onLoginData
{
    RbHttpClient *client = [RbHttpClient sharedInstance];
    LoginHttpCmd *cmd = [[[LoginHttpCmd alloc]init]autorelease];
    cmd.username = [self.usernameTextField text];
    cmd.password = md5(self.passwordTextField.text);
    self.httpCmd = cmd;
    cmd.delegate = self;
    [client onPostCmdAsync:self.httpCmd];
}


- (void) httpResult:(id)cmd  error:(NSError*)error
{
    NSLog(@"%@",NSStringFromClass([cmd class]));
    NSString *msg = nil;
    LoginHttpCmd *httpcmd = (LoginHttpCmd *)cmd;
    if (error) {
        msg = [NSString stringWithFormat:@"网络错误"];
    }else
    {
        if ([httpcmd.model.code isEqualToString:kSpinningHttpKeyOk]) {
            msg = [NSString stringWithFormat:@"登录成功！"];
        }else
        {
            msg = httpcmd.model.msg;
        }
    }
    [YRDropdownView showDropdownInView:self.view
                                 title:@"提示！"
                                detail:[NSString stringWithFormat:@"%@!",msg]
                                 image:[UIImage imageNamed:@"dropdown-alert"]
                              animated:YES
                             hideAfter:TipTime];
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
        [self onLoginData];
    }else
    {
        [YRDropdownView showDropdownInView:self.view
                                     title:@"提示！"
                                    detail:@"输入的反馈信息不能为空!"
                                     image:[UIImage imageNamed:@"dropdown-alert"]
                                  animated:YES
                                 hideAfter:TipTime];
    }
    return YES;
}


- (void)dealloc
{
    RbSafeRelease(_httpCmd);
    RbSafeRelease(_passwordTextField);
    RbSafeRelease(_usernameTextField);
    RbSuperDealoc;
}


@end
