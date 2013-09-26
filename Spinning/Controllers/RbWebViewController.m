//
//  RbWebViewController.m
//  Spinning
//
//  Created by Robin on 9/10/13.
//  Copyright (c) 2013 Robin. All rights reserved.
//

#import "RbWebViewController.h"
#import <MessageUI/MessageUI.h>

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

- (void)onRightBtn:(id)sender
{
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
    
    [self.view makeToast:@"收藏成功！"];
}

- (void)configureAllViews
{
    [self configureNavigationView];
}

- (void)configureNavigationView
{
    [super configureNavigationView];
//    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"news_bg"]]];
    [self.headerImageView setImage:[UIImage imageNamed:@"title_bgxw"]];
    [self.leftBtn setBackgroundImage:[UIImage imageNamed:@"title_btn_return_nomal"] forState:UIControlStateNormal];
    [self.leftBtn setBackgroundImage:[UIImage imageNamed:@"title_btn_return_pressed"] forState:UIControlStateHighlighted];
    [self.leftBtn setBackgroundImage:[UIImage imageNamed:@"title_btn_return_pressed"] forState:UIControlStateSelected];
    
    [self.rightBtn setBackgroundImage:[UIImage imageNamed:@"title_btn_store_nomal"] forState:UIControlStateNormal];
    [self.rightBtn setBackgroundImage:[UIImage imageNamed:@"title_btn_store_pressed"] forState:UIControlStateHighlighted];
    [self.rightBtn setBackgroundImage:[UIImage imageNamed:@"title_btn_store_pressed"] forState:UIControlStateSelected];
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
