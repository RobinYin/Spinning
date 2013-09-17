//
//  TopicWebViewController.m
//  Spinning
//
//  Created by Robin on 9/17/13.
//  Copyright (c) 2013 Robin. All rights reserved.
//

#import "TopicWebViewController.h"
#import "CommentViewController.h"
@interface TopicWebViewController ()

@end

@implementation TopicWebViewController

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
    [self configureOtherView];
	// Do any additional setup after loading the view.
}

- (void)configureOtherView
{
    [self.rightBtn setBackgroundImage:[UIImage imageNamed:@"title_btn_edit_nomal.png"] forState:UIControlStateNormal];
    [self.rightBtn setBackgroundImage:[UIImage imageNamed:@"title_btn_edit_pressed.png"] forState:UIControlStateHighlighted];
    [self.rightBtn setBackgroundImage:[UIImage imageNamed:@"title_btn_edit_pressed.png"] forState:UIControlStateSelected];
}

- (void)onRightBtn:(id)sender
{
    CommentViewController *viewController = [[CommentViewController new]autorelease];
    viewController.mid = self.mid;
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
