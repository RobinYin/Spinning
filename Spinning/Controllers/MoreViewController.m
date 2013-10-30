//
//  MoreViewController.m
//  Spinning
//
//  Created by Robin on 7/28/13.
//  Copyright (c) 2013 Robin. All rights reserved.
//

#import "MoreViewController.h"
#import "LoginViewController.h"
#import "CheckinViewController.h"
#import "BindViewController.h"
#import "HistoryViewController.h"
#import "CollectionViewController.h"
#import "AboutViewController.h"
#import "CompanyViewController.h"
#import "UIAlertView+MKBlockAdditions.h"

@interface MoreViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, retain)NSMutableArray *arrayCurrent;
@property (nonatomic, retain)UITableView *tableView;
@end

@implementation MoreViewController
@synthesize arrayCurrent = _arrayCurrent;
@synthesize tableView = _tableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (self.tableView) {
        [self.tableView reloadData];
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureOriginData];
    [self configureAllViews];
    [self onGetData];
	// Do any additional setup after loading the view.
}

- (void)configureAllViews
{
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"news_bg"]]];
    [self configureNavigationView];
    [self configureTableView];
}

- (void)configureTableView{
    
    UITableView* tmpTable = [[UITableView alloc]initWithFrame:CGRectMake(0, NavigationHeight+ StatusHeaderHight , ScreenWidth,ScreenHeight - StatusBarHeight - NavigationHeight - TabBarHeight - StatusHeaderHight) style:UITableViewStyleGrouped];
    tmpTable.separatorColor = [UIColor grayColor];
    tmpTable.delegate = self;
    tmpTable.dataSource = self;
    UIImageView *imageView = [[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"news_bg"]]autorelease];
    [tmpTable setBackgroundView:imageView];
    [self.view addSubview:tmpTable];
    self.tableView = tmpTable;
    RbSafeRelease(tmpTable);
    
}

- (void)onGetData
{
    NSMutableArray *array = [NSMutableArray arrayWithArray:[self onMoreListJson]];
    self.arrayCurrent = array;
    [self.tableView reloadData];
}
- (void)configureOriginData
{
    NSMutableArray *subArray = [NSMutableArray array];
    self.arrayCurrent = subArray;
}


- (NSMutableArray *)onMoreListJson{
    
    NSString* path = [[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"MoreListTemplate"] ofType:@"json"];
    NSData* data = [[NSData alloc] initWithContentsOfFile:path];
    NSString* str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    SBJSON *json = [[SBJSON alloc]init];
    NSMutableArray *array = [json objectWithString:str error:nil];
    NSLog(@"arrar = %@",array);
    RbSafeRelease(data);
    RbSafeRelease(json);
    RbSafeRelease(str)
    return array;
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configureNavigationView
{
    [super configureNavigationView];
    [self.headerImageView setImage:[UIImage imageNamed:@"title_bggd"]];
}


#pragma mark -
#pragma mark tableView Datasource -----------

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.arrayCurrent count];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.arrayCurrent objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier]autorelease];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
        [cell.textLabel setTextColor:[UIColor blackColor]];
        [cell.textLabel setFont:[UIFont systemFontOfSize:15]];
        [cell setBackgroundColor:[UIColor clearColor]];
        
//        UIBezierPath *maskPath = [UIBezierPath bezierPath];
//        
//        [maskPath moveToPoint:CGPointMake(10, 0)];
//        [maskPath addLineToPoint:CGPointMake(300, 0)];
//        [maskPath addLineToPoint:CGPointMake(300, 44)];
//        [maskPath addLineToPoint:CGPointMake(10, 44)];
//        [maskPath addLineToPoint:CGPointMake(5, 0)];
        
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(10, 0, 300, 44)];
        [view setBackgroundColor:[UIColor whiteColor]];
        [cell setBackgroundView:view];
        
    }
    
    if (self.arrayCurrent) {
        if ([self.arrayCurrent count]) {
            NSDictionary *dic = [[self.arrayCurrent objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
            [cell.textLabel setText:[dic objectForKey:@"title"]];
            if (indexPath.section == 0 && indexPath.row ==0) {
                NSLog(@"uid = %@",[RbUser sharedInstance].userid);
                if ([RbUser sharedInstance].userid) {
                    if (![[RbUser sharedInstance].userid isEqualToString:@""]) {
                        [cell.textLabel setText:[NSString stringWithFormat:@"%@(已登录)",[RbUser sharedInstance].username]];
                    }
                }
            }
        }
    }
    [cell groundToCellInTableView:tableView atIndexPath:indexPath];
    
    return cell;
}

#pragma mark -
#pragma mark tableView Delegate -----------

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0 && indexPath.section ==0) {
        if ([RbUser sharedInstance].userid) {
            if (![[RbUser sharedInstance].userid isEqualToString:@""]) {
                [UIAlertView alertViewWithTitle:@"您是否要退出登录?"
                                        message:@"退出登录后，你不能进行评论等相应操作，并且清除您的相关个人信息。"
                              cancelButtonTitle:@"取消"
                              otherButtonTitles:[NSArray arrayWithObjects:@"退出登录", nil]
                                      onDismiss:^(int buttonIndex)
                 {
                     [[RbUser sharedInstance] clear];
                     [self.tableView reloadData];
                 }
                                       onCancel:^()
                 {
                 }
                 ];
                return;
            }
        }
    }
    
    if (indexPath.row == 0 && indexPath.section ==1) {
        if (![RbUser sharedInstance].userid ) {
            NSLog(@"%@",[RbUser sharedInstance].userid);
            [UIAlertView alertViewWithTitle:@"您还没有登录!"
                                    message:@"请先登录后，才能进行签到操作。"
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
    }
    
    if (indexPath.row == 1 && indexPath.section ==1) {
        if (![RbUser sharedInstance].userid || [[RbUser sharedInstance] isKindOfClass:[NSNull class]]) {
             NSLog(@"%@",[RbUser sharedInstance].userid);
            [UIAlertView alertViewWithTitle:@"您还没有登录!"
                                    message:@"请先登录后，才能查看历史记录。"
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
    }
    
    if (indexPath.row == 0 && indexPath.section ==2) {
        if (![RbUser sharedInstance].userid || [[RbUser sharedInstance] isKindOfClass:[NSNull class]]) {
            NSLog(@"%@",[RbUser sharedInstance].userid);
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
    }

    NSDictionary *dic = [[self.arrayCurrent objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
    NSString *string = [dic objectForKey:@"link"];
    UIViewController *viewController = [(UIViewController *)[[NSClassFromString(string) alloc]init]autorelease];
    [viewController setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return MoreCellHeight;
}


- (void)dealloc
{
    RbSafeRelease(_tableView);
    RbSafeRelease(_arrayCurrent);
    RbSuperDealoc;
}

@end
