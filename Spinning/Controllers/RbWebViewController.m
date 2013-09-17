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

@property (nonatomic, retain, readonly) UIBarButtonItem *backBarButtonItem;
@property (nonatomic, retain, readonly) UIBarButtonItem *forwardBarButtonItem;
@property (nonatomic, retain, readonly) UIBarButtonItem *refreshBarButtonItem;
@property (nonatomic, retain, readonly) UIBarButtonItem *stopBarButtonItem;
@property (nonatomic, retain, readonly) UIBarButtonItem *actionBarButtonItem;
@property (nonatomic, retain, readonly) UIActionSheet *pageActionSheet;

@property (nonatomic, retain) UIWebView *mainWebView;
@property (nonatomic, retain) NSURL *URL;

- (id)initWithAddress:(NSString*)urlString;
- (id)initWithURL:(NSURL*)URL;

- (void)updateToolbarItems;

- (void)goBackClicked:(UIBarButtonItem *)sender;
- (void)goForwardClicked:(UIBarButtonItem *)sender;
- (void)reloadClicked:(UIBarButtonItem *)sender;
- (void)stopClicked:(UIBarButtonItem *)sender;
- (void)actionButtonClicked:(UIBarButtonItem *)sender;

@end

@implementation RbWebViewController

@synthesize availableActions;
@synthesize mid = _mid;
@synthesize URL = _URL, mainWebView = _mainWebView;
@synthesize backBarButtonItem = _backBarButtonItem, forwardBarButtonItem = _forwardBarButtonItem, refreshBarButtonItem = _refreshBarButtonItem, stopBarButtonItem = _stopBarButtonItem, actionBarButtonItem = _actionBarButtonItem, pageActionSheet = _pageActionSheet;

#pragma mark - setters and getters

- (UIBarButtonItem *)backBarButtonItem {
    
    if (!_backBarButtonItem) {
        _backBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(goBackClicked:)];
        _backBarButtonItem.imageInsets = UIEdgeInsetsMake(2.0f, 0.0f, -2.0f, 0.0f);
		_backBarButtonItem.width = 18.0f;
    }
    return _backBarButtonItem;
}

- (UIBarButtonItem *)forwardBarButtonItem {
    
    if (!_forwardBarButtonItem) {
        _forwardBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"forward"] style:UIBarButtonItemStylePlain target:self action:@selector(goForwardClicked:)];
        _forwardBarButtonItem.imageInsets = UIEdgeInsetsMake(2.0f, 0.0f, -2.0f, 0.0f);
		_forwardBarButtonItem.width = 18.0f;
    }
    return _forwardBarButtonItem;
}

- (UIBarButtonItem *)refreshBarButtonItem {
    
    if (!_refreshBarButtonItem) {
        _refreshBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(reloadClicked:)];
    }
    
    return _refreshBarButtonItem;
}

- (UIBarButtonItem *)stopBarButtonItem {
    
    if (!_stopBarButtonItem) {
        _stopBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(stopClicked:)];
    }
    return _stopBarButtonItem;
}

- (UIBarButtonItem *)actionBarButtonItem {
    
    if (!_actionBarButtonItem) {
        _actionBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(actionButtonClicked:)];
    }
    return _actionBarButtonItem;
}

- (UIActionSheet *)pageActionSheet {
    
    if(!_pageActionSheet) {
        _pageActionSheet = [[UIActionSheet alloc]
                           initWithTitle:self.mainWebView.request.URL.absoluteString
                           delegate:self
                           cancelButtonTitle:nil
                           destructiveButtonTitle:nil
                           otherButtonTitles:nil];
        
        if((self.availableActions & RbWebViewControllerAvailableActionsCopyLink) == RbWebViewControllerAvailableActionsCopyLink)
            [_pageActionSheet addButtonWithTitle:NSLocalizedString(@"Copy Link", @"")];
        
        if((self.availableActions & RbWebViewControllerAvailableActionsOpenInSafari) == RbWebViewControllerAvailableActionsOpenInSafari)
            [_pageActionSheet addButtonWithTitle:NSLocalizedString(@"Open in Safari", @"")];
        
        if([MFMailComposeViewController canSendMail] && (self.availableActions & RbWebViewControllerAvailableActionsMailLink) == RbWebViewControllerAvailableActionsMailLink)
            [_pageActionSheet addButtonWithTitle:NSLocalizedString(@"Mail Link to this Page", @"")];
        
        [_pageActionSheet addButtonWithTitle:NSLocalizedString(@"Cancel", @"")];
        _pageActionSheet.cancelButtonIndex = [self.pageActionSheet numberOfButtons]-1;
    }
    
    return _pageActionSheet;
}

#pragma mark - Initialization

- (id)initWithAddress:(NSString *)urlString {
    return [self initWithURL:[NSURL URLWithString:urlString]];
}

- (id)initWithURL:(NSURL*)pageURL {
    
    if(self = [super init]) {
        self.URL = pageURL;
        self.availableActions = RbWebViewControllerAvailableActionsOpenInSafari | RbWebViewControllerAvailableActionsMailLink;
    }
    
    return self;
}

- (void)onLeftBtn:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)onRightBtn:(id)sender
{
    
}

- (void)configureAllViews
{
    [self configureNavigationView];
}

- (void)configureNavigationView
{
    [super configureNavigationView];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"news_bg"]]];
    [self.headerImageView setImage:[UIImage imageNamed:@"title_bgxw"]];
    [self.leftBtn setBackgroundImage:[UIImage imageNamed:@"title_btn_return_nomal"] forState:UIControlStateNormal];
    [self.leftBtn setBackgroundImage:[UIImage imageNamed:@"title_btn_return_pressed"] forState:UIControlStateHighlighted];
    [self.leftBtn setBackgroundImage:[UIImage imageNamed:@"title_btn_return_pressed"] forState:UIControlStateSelected];
}


#pragma mark - Memory management

- (void)dealloc {
    
    _mainWebView.delegate = nil;
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    RbSafeRelease(_mid);
    RbSafeRelease(_URL);
    RbSafeRelease(_mainWebView);
    RbSafeRelease(_backBarButtonItem);
    RbSafeRelease(_forwardBarButtonItem);
    RbSafeRelease(_refreshBarButtonItem);
    RbSafeRelease(_stopBarButtonItem);
    RbSafeRelease(_actionBarButtonItem);
    RbSafeRelease(_pageActionSheet);
    RbSuperDealoc;
}

#pragma mark - View lifecycle


- (void)viewDidLoad {
	[super viewDidLoad];
    
    _mainWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, NavigationHeight , ScreenWidth,ScreenHeight - StatusBarHeight - NavigationHeight - NavigationHeight)];
    _mainWebView.delegate = self;
    _mainWebView.scalesPageToFit = YES;
    [_mainWebView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"news_bg"]]];
    [_mainWebView loadRequest:[NSURLRequest requestWithURL:self.URL]];
    [self.view addSubview:_mainWebView];
    [self configureAllViews];
    [self updateToolbarItems];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    _mainWebView = nil;
    _backBarButtonItem = nil;
    _forwardBarButtonItem = nil;
    _refreshBarButtonItem = nil;
    _stopBarButtonItem = nil;
    _actionBarButtonItem = nil;
    _pageActionSheet = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    NSAssert(self.navigationController, @"SVWebViewController needs to be contained in a UINavigationController. If you are presenting SVWebViewController modally, use SVModalWebViewController instead.");
    
	[super viewWillAppear:animated];
	
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        [self.navigationController setToolbarHidden:NO animated:animated];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        [self.navigationController setToolbarHidden:YES animated:animated];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        return YES;
    
    return toInterfaceOrientation != UIInterfaceOrientationPortraitUpsideDown;
}

#pragma mark - Toolbar

- (void)updateToolbarItems {
    self.backBarButtonItem.enabled = self.mainWebView.canGoBack;
    self.forwardBarButtonItem.enabled = self.mainWebView.canGoForward;
    self.actionBarButtonItem.enabled = !self.mainWebView.isLoading;
    
    UIBarButtonItem *refreshStopBarButtonItem = self.mainWebView.isLoading ? self.stopBarButtonItem : self.refreshBarButtonItem;
    
    UIBarButtonItem *fixedSpace = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil]autorelease];
    fixedSpace.width = 5.0f;
    UIBarButtonItem *flexibleSpace = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil]autorelease];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        NSArray *items;
        CGFloat toolbarWidth = 250.0f;
        
        if(self.availableActions == 0) {
            toolbarWidth = 200.0f;
            items = [NSArray arrayWithObjects:
                     fixedSpace,
                     refreshStopBarButtonItem,
                     flexibleSpace,
                     self.backBarButtonItem,
                     flexibleSpace,
                     self.forwardBarButtonItem,
                     fixedSpace,
                     nil];
        } else {
            items = [NSArray arrayWithObjects:
                     fixedSpace,
                     refreshStopBarButtonItem,
                     flexibleSpace,
                     self.backBarButtonItem,
                     flexibleSpace,
                     self.forwardBarButtonItem,
                     flexibleSpace,
                     self.actionBarButtonItem,
                     fixedSpace,
                     nil];
        }
        
        UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, toolbarWidth, 44.0f)];
        [toolbar setBarStyle:UIBarStyleBlack];
        toolbar.items = items;
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:toolbar];
    }
    
    else {
        NSArray *items;
        
        if(self.availableActions == 0) {
            items = [NSArray arrayWithObjects:
                     flexibleSpace,
                     self.backBarButtonItem,
                     flexibleSpace,
                     self.forwardBarButtonItem,
                     flexibleSpace,
                     refreshStopBarButtonItem,
                     flexibleSpace,
                     nil];
        } else {
            items = [NSArray arrayWithObjects:
                     fixedSpace,
                     self.backBarButtonItem,
                     flexibleSpace,
                     self.forwardBarButtonItem,
                     flexibleSpace,
                     refreshStopBarButtonItem,
                     flexibleSpace,
                     self.actionBarButtonItem,
                     fixedSpace,
                     nil];
        }
        
        self.toolbarItems = items;
    }
}

#pragma mark -
#pragma mark UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView {
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [self updateToolbarItems];
}


- (void)webViewDidFinishLoad:(UIWebView *)webView {
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    self.navigationItem.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    [self updateToolbarItems];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [self updateToolbarItems];
}

#pragma mark - Target actions

- (void)goBackClicked:(UIBarButtonItem *)sender {
    [_mainWebView goBack];
}

- (void)goForwardClicked:(UIBarButtonItem *)sender {
    [_mainWebView goForward];
}

- (void)reloadClicked:(UIBarButtonItem *)sender {
    [_mainWebView reload];
}

- (void)stopClicked:(UIBarButtonItem *)sender {
    [_mainWebView stopLoading];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	[self updateToolbarItems];
}

- (void)actionButtonClicked:(id)sender {
    
    if(_pageActionSheet)
        return;
	
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        [self.pageActionSheet showFromBarButtonItem:self.actionBarButtonItem animated:YES];
    else
        [self.pageActionSheet showFromToolbar:self.navigationController.toolbar];
    
}

- (void)doneButtonClicked:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	NSString *title = [actionSheet buttonTitleAtIndex:buttonIndex];
    
	if([title isEqualToString:NSLocalizedString(@"Open in Safari", @"")])
        [[UIApplication sharedApplication] openURL:self.mainWebView.request.URL];
    
    if([title isEqualToString:NSLocalizedString(@"Copy Link", @"")]) {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = self.mainWebView.request.URL.absoluteString;
    }
    
    else if([title isEqualToString:NSLocalizedString(@"Mail Link to this Page", @"")]) {
        
		MFMailComposeViewController *mailViewController = [[[MFMailComposeViewController alloc] init]autorelease];
        
		mailViewController.mailComposeDelegate = self;
        [mailViewController setSubject:[self.mainWebView stringByEvaluatingJavaScriptFromString:@"document.title"]];
  		[mailViewController setMessageBody:self.mainWebView.request.URL.absoluteString isHTML:NO];
		mailViewController.modalPresentationStyle = UIModalPresentationFormSheet;
        
		[self presentModalViewController:mailViewController animated:YES];
	}
    
    _pageActionSheet = nil;
}

#pragma mark -
#pragma mark MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError *)error
{
	[self dismissModalViewControllerAnimated:YES];
}

@end
