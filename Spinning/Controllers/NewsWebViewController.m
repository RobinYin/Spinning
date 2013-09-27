//
//  NewsWebViewController.m
//  Spinning
//
//  Created by Robin on 9/27/13.
//  Copyright (c) 2013 Robin. All rights reserved.
//

#import "NewsWebViewController.h"
@interface NewsWebViewController ()

@end

@implementation NewsWebViewController

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
    [self.headerImageView setImage:[UIImage imageNamed:@"title_bgxw"]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
