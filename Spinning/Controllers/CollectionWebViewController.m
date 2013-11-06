//
//  CollectionWebViewController.m
//  Spinning
//
//  Created by Robin on 9/26/13.
//  Copyright (c) 2013 Robin. All rights reserved.
//

#import "CollectionWebViewController.h"
#import "UIAlertView+MKBlockAdditions.h"
@interface CollectionWebViewController ()

@end

@implementation CollectionWebViewController

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
    [super configureNavigationView];
    
    [self.headerImageView setImage:[UIImage imageNamed:@"title_bggd"]];
    [self.rightBtn setBackgroundImage:[UIImage imageNamed:@"title_btn_edit_nomal.png"] forState:UIControlStateNormal];
    [self.rightBtn setBackgroundImage:[UIImage imageNamed:@"title_btn_edit_pressed.png"] forState:UIControlStateHighlighted];
    [self.rightBtn setBackgroundImage:[UIImage imageNamed:@"title_btn_edit_pressed.png"] forState:UIControlStateSelected];
    
    [self.subrightBtn setBackgroundImage:[UIImage imageNamed:nil] forState:UIControlStateNormal];
    [self.subrightBtn setBackgroundImage:[UIImage imageNamed:nil] forState:UIControlStateHighlighted];
    [self.subrightBtn setBackgroundImage:[UIImage imageNamed:nil] forState:UIControlStateSelected];
    
}


- (void)onSubRightBtn:(id)sender
{
    
}

- (void)configureOtherView
{
    [self.rightBtn setBackgroundImage:[UIImage imageNamed:@"title_btn_edit_nomal.png"] forState:UIControlStateNormal];
    [self.rightBtn setBackgroundImage:[UIImage imageNamed:@"title_btn_edit_pressed.png"] forState:UIControlStateHighlighted];
    [self.rightBtn setBackgroundImage:[UIImage imageNamed:@"title_btn_edit_pressed.png"] forState:UIControlStateSelected];
}

- (void)onRightBtn:(id)sender
{
    
    [UIAlertView alertViewWithTitle:@"您是否要删除此收藏?"
                            message:@"删除后，此收藏将不会再显示在您的收藏列表中。"
                  cancelButtonTitle:@"取消"
                  otherButtonTitles:[NSArray arrayWithObjects:@"删除", nil]
                          onDismiss:^(int buttonIndex)
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
         [globalHelper deleteToDB:data];
         
         [YRDropdownView showDropdownInView:[UIApplication sharedApplication].delegate.window
                                      title:@"提示！"
                                     detail:@"删除成功!"
                                      image:[UIImage imageNamed:@"dropdown-alert"]
                                   animated:YES
                                  hideAfter:TipTime];
         
         [self.navigationController popViewControllerAnimated:YES];
     }
                           onCancel:^()
     {
     }
     ];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
