//
//  FeedbackViewController.m
//  Spinning
//
//  Created by Robin on 8/30/13.
//  Copyright (c) 2013 Robin. All rights reserved.
//

#import "FeedbackViewController.h"
#import "FeedbackHttpCmd.h"

@interface FeedbackViewController ()<UITextFieldDelegate,RbHttpDelegate>
@property (nonatomic, retain)UITextField *feedbackTextField;
@property (nonatomic, retain)RbHttpCmd *httpCmd;
@end

@implementation FeedbackViewController
@synthesize feedbackTextField = _feedbackTextField;
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
    [self configureOtherViews];
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

- (void)configureOtherViews
{
    UITextField* textField = [[UITextField alloc]initWithFrame:CGRectMake(10, 54+ StatusHeaderHight, 300, 300)];
    textField.font = [UIFont systemFontOfSize:14];
    textField.delegate = self;
    [textField setBackgroundColor:[UIColor whiteColor]];
    [textField setReturnKeyType:UIReturnKeyDone];
    [textField setBorderStyle:UITextBorderStyleRoundedRect];
    [self.view addSubview:textField];
    self.feedbackTextField = textField;
    [textField release];
    
    
    UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextBtn setFrame:CGRectMake(92.25, 364+ StatusHeaderHight, 135.5, 27)];
    [nextBtn setBackgroundImage:[UIImage imageNamed:@"btn_normal"] forState:UIControlStateNormal];
    [nextBtn setTitle:@"提交" forState:UIControlStateNormal];
    [nextBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [nextBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [nextBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -30, 0, 0)];
    [nextBtn addTarget:self action:@selector(next:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextBtn];
}

- (void)next:(id)sender
{
    [self.feedbackTextField resignFirstResponder];
    if ([self canNext]) {
        [self onFeedbackData];
    }else
    {
        [YRDropdownView showDropdownInView:self.view
                                     title:@"提示！"
                                    detail:[NSString stringWithFormat:@"输入的反馈信息不能为空!"]
                                     image:[UIImage imageNamed:@"dropdown-alert"]
                                  animated:YES
                                 hideAfter:3];
    }
}

- (BOOL)canNext
{
    return [self.feedbackTextField.text length];
}

- (void)onFeedbackData
{
    RbHttpClient *client = [RbHttpClient sharedInstance];
    FeedbackHttpCmd *cmd = [[[FeedbackHttpCmd alloc]init]autorelease];
    cmd.suggestion = self.feedbackTextField.text;
    self.httpCmd = cmd;
    cmd.delegate = self;
    [client onPostCmdAsync:self.httpCmd];
}


- (void) httpResult:(id)cmd  error:(NSError*)error
{
    NSLog(@"%@",NSStringFromClass([cmd class]));
    NSString *msg = nil;
    FeedbackHttpCmd *httpcmd = (FeedbackHttpCmd *)cmd;
    if (error) {
        msg = [NSString stringWithFormat:@"网络错误"];
    }else
    {
        if ([httpcmd.model.code isEqualToString:kSpinningHttpKeyOk]) {
            msg = [NSString stringWithFormat:@"你的意见已发送！"];
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
                             hideAfter:3];

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
        [self onFeedbackData];
    }else
    {
        [YRDropdownView showDropdownInView:self.view
                                     title:@"提示！"
                                    detail:@"输入的反馈信息不能为空!"
                                     image:[UIImage imageNamed:@"dropdown-alert"]
                                  animated:YES
                                 hideAfter:3];
        
        //        [YRDropdownView showDropdownInView:self.view
        //                                     title:@"提示！"
        //                                    detail:[NSString stringWithFormat:@"%@!",msg]
        //                                     image:[UIImage imageNamed:@"dropdown-alert"]
        //                                  animated:YES
        //                                 hideAfter:3];
    }
    return YES;
}


- (void)dealloc
{
    RbSafeRelease(_httpCmd);
    RbSafeRelease(_feedbackTextField);
    RbSuperDealoc;
}

@end
