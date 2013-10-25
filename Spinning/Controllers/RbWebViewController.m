//
//  RbWebViewController.m
//  Spinning
//
//  Created by Robin on 9/10/13.
//  Copyright (c) 2013 Robin. All rights reserved.
//

#import "RbWebViewController.h"
#import <MessageUI/MessageUI.h>
#import "UIAlertView+MKBlockAdditions.h"
#import "LoginViewController.h"

@interface RbWebViewController ()<UIWebViewDelegate, UIActionSheetDelegate, MFMailComposeViewControllerDelegate>

@property (nonatomic, retain) UIWebView *mainWebView;
@property (nonatomic, retain) NSURL *URL;

- (id)initWithAddress:(NSString*)urlString;
- (id)initWithURL:(NSURL*)URL;



@end

@implementation RbWebViewController
@synthesize model = _model;
@synthesize mid = _mid;
@synthesize URL = _URL, mainWebView = _mainWebView;




#pragma mark - Initialization

- (id)initWithAddress:(NSString *)urlString {
    return [self initWithURL:[NSURL URLWithString:urlString]];
}

- (id)initWithURL:(NSURL*)pageURL {
    
    if(self = [super init]) {
        self.URL = pageURL;
    }
    
    return self;
}

- (void)onLeftBtn:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)onSubRightBtn:(id)sender
{
    if (![RbUser sharedInstance].userid) {
        
        [UIAlertView alertViewWithTitle:@"您还没有登录!"
                                message:@"请先登录后，才能进行收藏操作。"
                      cancelButtonTitle:@"取消"
                      otherButtonTitles:[NSArray arrayWithObjects:@"登录", nil]
                              onDismiss:^(int buttonIndex)
         {
             LoginViewController *viewController = [[LoginViewController new]autorelease];
             [self.navigationController pushViewController:viewController animated:YES];
         }
                               onCancel:^()
         {
         }
         ];
        return;
    }
    ListModel *data = [[[ListModel alloc]init]autorelease];
    data.time = self.model.time;
    data.title = self.model.title;
    data.mid = self.model.mid;
    data.articleurl = self.model.articleurl;
    data.totalcount = self.model.totalcount;
    data.icon = self.model.icon;
    data.content =self.model.content;
    data.source = self.model.source;
    LKDBHelper* globalHelper = [LKDBHelper getUsingLKDBHelper];
    [globalHelper createTableWithModelClass:[ListModel class]];
    [globalHelper insertToDB:data];
    
//    [self.view makeToast:@"收藏成功！"];
    
    [YRDropdownView showDropdownInView:self.view
                                 title:@"提示！"
                                detail:@"收藏成功！"
                                 image:[UIImage imageNamed:@"dropdown-alert"]
                              animated:YES
                             hideAfter:3];
}

- (void)onRightBtn:(id)sender
{
    if (![RbUser sharedInstance].userid) {
        
        [UIAlertView alertViewWithTitle:@"您还没有登录!"
                                message:@"请先登录后，才能进行分享操作。"
                      cancelButtonTitle:@"取消"
                      otherButtonTitles:[NSArray arrayWithObjects:@"登录", nil]
                              onDismiss:^(int buttonIndex)
         {
             LoginViewController *viewController = [[LoginViewController new]autorelease];
             [self.navigationController pushViewController:viewController animated:YES];
         }
                               onCancel:^()
         {
         }
         ];
        return;
    }
    NSString *shareText = [NSString stringWithFormat:@"%@!链接：%@（掌观中国针织）!",self.model.title,self.URL];
    [UMSocialConfig setSnsPlatformNames:@[UMShareToSina,UMShareToWechatTimeline,UMShareToWechatSession]];
    [UMSocialSnsService presentSnsIconSheetView:self appKey:UmengAppkey shareText:shareText shareImage:nil shareToSnsNames:@[UMShareToSina,UMShareToWechatTimeline,UMShareToWechatSession] delegate:nil];
}

- (void)configureAllViews
{
    [self configureNavigationView];
}

- (void)configureNavigationView
{
    [super configureNavigationView];
    [self.headerImageView setImage:[UIImage imageNamed:@"nav_bg"]];
    [self.leftBtn setBackgroundImage:[UIImage imageNamed:@"title_btn_return_nomal"] forState:UIControlStateNormal];
    [self.leftBtn setBackgroundImage:[UIImage imageNamed:@"title_btn_return_pressed"] forState:UIControlStateHighlighted];
    [self.leftBtn setBackgroundImage:[UIImage imageNamed:@"title_btn_return_pressed"] forState:UIControlStateSelected];
    
    [self.rightBtn setBackgroundImage:[UIImage imageNamed:@"title_btn_forward_nomal"] forState:UIControlStateNormal];
    [self.rightBtn setBackgroundImage:[UIImage imageNamed:@"title_btn_forward_pressed"] forState:UIControlStateHighlighted];
    [self.rightBtn setBackgroundImage:[UIImage imageNamed:@"title_btn_forward_pressed"] forState:UIControlStateSelected];
    
    [self.subrightBtn setBackgroundImage:[UIImage imageNamed:@"title_btn_store_nomal"] forState:UIControlStateNormal];
    [self.subrightBtn setBackgroundImage:[UIImage imageNamed:@"title_btn_store_pressed"] forState:UIControlStateHighlighted];
    [self.subrightBtn setBackgroundImage:[UIImage imageNamed:@"title_btn_store_pressed"] forState:UIControlStateSelected];
}




#pragma mark - Memory management

- (void)dealloc {
    
    _mainWebView.delegate = nil;
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    RbSafeRelease(_model);
    RbSafeRelease(_mid);
    RbSafeRelease(_URL);
    RbSafeRelease(_mainWebView);
    RbSuperDealoc;
}

#pragma mark - View lifecycle


- (void)viewDidLoad {
	[super viewDidLoad];
    
    _mainWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, NavigationHeight , ScreenWidth,ScreenHeight - StatusBarHeight - NavigationHeight)];
    _mainWebView.delegate = self;
    _mainWebView.scalesPageToFit = YES;
//    [_mainWebView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"news_bg"]]];
    [_mainWebView loadRequest:[NSURLRequest requestWithURL:self.URL]];
    [self.view addSubview:_mainWebView];
    [self configureAllViews];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    _mainWebView = nil;
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}



#
#pragma mark -
#pragma mark UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView {
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}


- (void)webViewDidFinishLoad:(UIWebView *)webView {
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    self.navigationItem.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

@end
