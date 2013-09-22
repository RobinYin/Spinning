//
//  CheckDetailViewController.m
//  Spinning
//
//  Created by Robin on 9/18/13.
//  Copyright (c) 2013 Robin. All rights reserved.
//

#import "CheckDetailViewController.h"

@interface CheckDetailViewController ()<UIScrollViewDelegate>

@end

@implementation CheckDetailViewController
@synthesize name = _name;
@synthesize description = _description;
@synthesize code = _code;
@synthesize address = _address;
@synthesize date = _date;
@synthesize sponsor = _sponsor;

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
    [self onTest];
    [self configureAllViews];
	// Do any additional setup after loading the view.
}

- (void)onTest
{
    self.address = @"北京会议中心11号楼";
    self.code = @"ckia13091013900636";
    self.date = @"2013年9月11日";
    self.description = @"测试活动1活动简介\r\n内容简介123456\r\n哈哈哈哈哈哈";
    self.name = @"测试活动1";
    self.sponsor = @"中国纺织品工业协会\r\nXXXX企业\r\n北京XXXX公司";
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
    CGSize size1 = [self.name sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:CGSizeMake(ScreenWidth - 2*CheckDetailViewHorizontalGap, NSIntegerMax) lineBreakMode:NSLineBreakByCharWrapping];
    NSLog(@"%@",NSStringFromCGSize(size1));
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(CheckDetailViewHorizontalGap, CheckDetailViewVerticalGap, ScreenWidth - 2*CheckDetailViewHorizontalGap, size1.height)];
    [label1 setTextAlignment:UITextAlignmentCenter];
    [label1 setFont: [UIFont systemFontOfSize:16]];
    [label1 setBackgroundColor:[UIColor clearColor]];
    [label1 setNumberOfLines:0];
    [label1 setText: self.name];
    label1.textColor =  [UIColor colorWithRed:255./255 green:244./255 blue:98./255 alpha:1];
    
    CGSize size2 = [self.description sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(ScreenWidth - 2*CheckDetailViewHorizontalGap, NSIntegerMax) lineBreakMode:NSLineBreakByCharWrapping];
    NSLog(@"%@",NSStringFromCGSize(size2));
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(CheckDetailViewHorizontalGap, label1.frame.origin.y +label1.frame.size.height + CheckDetailViewVerticalGap, ScreenWidth - 2*CheckDetailViewHorizontalGap, size2.height)];
    [label2 setTextAlignment:UITextAlignmentCenter];
    [label2 setFont: [UIFont systemFontOfSize:14]];
    [label2 setBackgroundColor:[UIColor clearColor]];
    [label2 setNumberOfLines:0];
    [label2 setText: self.description];
    label2.textColor =  [UIColor whiteColor];
    
    CGSize size3 = [self.sponsor sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(ScreenWidth - 2*CheckDetailViewHorizontalGap, NSIntegerMax) lineBreakMode:NSLineBreakByCharWrapping];
    NSLog(@"%@",NSStringFromCGSize(size3));
    
    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(CheckDetailViewHorizontalGap, label2.frame.origin.y +label2.frame.size.height + CheckDetailViewVerticalGap, ScreenWidth - 2*CheckDetailViewHorizontalGap, 19)];
    [label3 setTextAlignment:UITextAlignmentCenter];
    [label3 setFont: [UIFont systemFontOfSize:15]];
    [label3 setBackgroundColor:[UIColor clearColor]];
    [label3 setNumberOfLines:0];
    [label3 setText: @"主办方"];
    label3.textColor =  [UIColor colorWithRed:255./255 green:244./255 blue:98./255 alpha:1];
    
    UILabel *label4 = [[UILabel alloc] initWithFrame:CGRectMake(CheckDetailViewHorizontalGap, label3.frame.origin.y +label3.frame.size.height + CheckDetailViewVerticalGap, ScreenWidth - 2*CheckDetailViewHorizontalGap, size3.height)];
    [label4 setTextAlignment:UITextAlignmentCenter];
    [label4 setFont: [UIFont systemFontOfSize:13]];
    [label4 setBackgroundColor:[UIColor clearColor]];
    [label4 setNumberOfLines:0];
    [label4 setText: self.sponsor];
    label4.textColor =  [UIColor whiteColor];
    
    CGSize size4 = [self.address sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(ScreenWidth - 2*CheckDetailViewHorizontalGap, NSIntegerMax) lineBreakMode:NSLineBreakByCharWrapping];
    NSLog(@"%@",NSStringFromCGSize(size4));
    
    
    UILabel *label5 = [[UILabel alloc] initWithFrame:CGRectMake(CheckDetailViewHorizontalGap, label4.frame.origin.y +label4.frame.size.height + CheckDetailViewVerticalGap, ScreenWidth - 2*CheckDetailViewHorizontalGap, 19)];
    [label5 setTextAlignment:UITextAlignmentCenter];
    [label5 setFont: [UIFont systemFontOfSize:15]];
    [label5 setBackgroundColor:[UIColor clearColor]];
    [label5 setNumberOfLines:0];
    [label5 setText: @"地址"];
    label5.textColor =  [UIColor colorWithRed:255./255 green:244./255 blue:98./255 alpha:1];
    
    UILabel *label6 = [[UILabel alloc] initWithFrame:CGRectMake(CheckDetailViewHorizontalGap, label5.frame.origin.y +label5.frame.size.height + CheckDetailViewVerticalGap, ScreenWidth - 2*CheckDetailViewHorizontalGap, size4.height)];
    [label6 setTextAlignment:UITextAlignmentCenter];
    [label6 setFont: [UIFont systemFontOfSize:13]];
    [label6 setBackgroundColor:[UIColor clearColor]];
    [label6 setNumberOfLines:0];
    [label6 setText: self.address];
    label6.textColor =  [UIColor whiteColor];
    
    CGSize size5 = [self.date sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(ScreenWidth - 2*CheckDetailViewHorizontalGap, NSIntegerMax) lineBreakMode:NSLineBreakByCharWrapping];
    NSLog(@"%@",NSStringFromCGSize(size5));
    
    
    UILabel *label7 = [[UILabel alloc] initWithFrame:CGRectMake(CheckDetailViewHorizontalGap, label6.frame.origin.y +label6.frame.size.height + CheckDetailViewVerticalGap, ScreenWidth - 2*CheckDetailViewHorizontalGap, 19)];
    [label7 setTextAlignment:UITextAlignmentCenter];
    [label7 setFont: [UIFont systemFontOfSize:15]];
    [label7 setBackgroundColor:[UIColor clearColor]];
    [label7 setNumberOfLines:0];
    [label7 setText: @"时间"];
    label7.textColor =  [UIColor colorWithRed:255./255 green:244./255 blue:98./255 alpha:1];
    
    UILabel *label8 = [[UILabel alloc] initWithFrame:CGRectMake(CheckDetailViewHorizontalGap, label7.frame.origin.y +label7.frame.size.height + CheckDetailViewVerticalGap, ScreenWidth - 2*CheckDetailViewHorizontalGap, size5.height)];
    [label8 setTextAlignment:UITextAlignmentCenter];
    [label8 setFont: [UIFont systemFontOfSize:13]];
    [label8 setBackgroundColor:[UIColor clearColor]];
    [label8 setNumberOfLines:0];
    [label8 setText: self.date];
    label8.textColor =  [UIColor whiteColor];
    
    
    UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextBtn setFrame:CGRectMake(92.25, label8.frame.origin.y +label8.frame.size.height + CheckDetailViewVerticalGap, 135.5, 27)];
    [nextBtn setBackgroundImage:[UIImage imageNamed:@"btn_normal"] forState:UIControlStateNormal];
    [nextBtn setTitle:@"确定" forState:UIControlStateNormal];
    [nextBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [nextBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [nextBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -30, 0, 0)];
    [nextBtn addTarget:self action:@selector(next:) forControlEvents:UIControlEventTouchUpInside];
    
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, NavigationHeight, ScreenWidth, ScreenHeight - NavigationBtnheight - StatusBarHeight)];
    scrollView.delegate = self;
    [scrollView setContentSize:CGSizeMake(320, nextBtn.frame.origin.y + nextBtn.frame.size.height + CheckDetailViewVerticalGap)];
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = YES;
    scrollView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:scrollView];
    
    [scrollView addSubview:label1];
    [scrollView addSubview:label2];
    [scrollView addSubview:label3];
    [scrollView addSubview:label4];
    [scrollView addSubview:label5];
    [scrollView addSubview:label6];
    [scrollView addSubview:label7];
    [scrollView addSubview:label8];
    [scrollView addSubview:nextBtn];
    
    RbSafeRelease(label1);
    RbSafeRelease(label2);
    RbSafeRelease(label3);
    RbSafeRelease(label4);
    RbSafeRelease(label5);
    RbSafeRelease(label6);
    RbSafeRelease(label7);
    RbSafeRelease(label8);
    
    RbSafeRelease(scrollView);
}

- (void)next:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)dealloc
{
    RbSafeRelease(_name);
    RbSafeRelease(_date);
    RbSafeRelease(_description);
    RbSafeRelease(_code);
    RbSafeRelease(_address);
    RbSafeRelease(_sponsor);
    RbSuperDealoc;
}


@end
