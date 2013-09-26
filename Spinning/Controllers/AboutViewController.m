//
//  AboutViewController.m
//  Spinning
//
//  Created by Robin on 8/30/13.
//  Copyright (c) 2013 Robin. All rights reserved.
//

#import "AboutViewController.h"
#import "VersionViewController.h"
#import "CompanyViewController.h"
#import "FeedbackViewController.h"

@interface AboutViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, retain)NSMutableArray *arrayCurrent;
@property (nonatomic, retain)UITableView *tableView;

@end

@implementation AboutViewController
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
    
    UITableView* tmpTable = [[UITableView alloc]initWithFrame:CGRectMake(0, NavigationHeight + StatusHeaderHight , ScreenWidth,ScreenHeight - StatusBarHeight - NavigationHeight - TabBarHeight - StatusHeaderHight) style:UITableViewStyleGrouped];
    tmpTable.separatorColor = [UIColor grayColor];
    tmpTable.delegate = self;
    tmpTable.dataSource = self;
    tmpTable.backgroundColor = [UIColor clearColor];
    [self.view addSubview:tmpTable];
    self.tableView = tmpTable;
    RbSafeRelease(tmpTable);
    
}

- (void)onGetData
{
    NSMutableArray *array = [NSMutableArray arrayWithArray:[self onAboutListJson]];
    self.arrayCurrent = array;
    [self.tableView reloadData];
}
- (void)configureOriginData
{
    NSMutableArray *subArray = [NSMutableArray array];
    self.arrayCurrent = subArray;
}


- (NSMutableArray *)onAboutListJson{
    
    NSString* path = [[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"AboutListTemplate"] ofType:@"json"];
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
    [self.leftBtn setBackgroundImage:[UIImage imageNamed:@"title_btn_return_nomal"] forState:UIControlStateNormal];
    [self.leftBtn setBackgroundImage:[UIImage imageNamed:@"title_btn_return_pressed"] forState:UIControlStateHighlighted];
    [self.leftBtn setBackgroundImage:[UIImage imageNamed:@"title_btn_return_pressed"] forState:UIControlStateSelected];
    
    
    [self.rightBtn setBackgroundImage:[UIImage imageNamed:@"nav_left_btn.png"] forState:UIControlStateNormal];
    [self.rightBtn setBackgroundImage:[UIImage imageNamed:@"nav_left_btn_sel.png"] forState:UIControlStateHighlighted];
    [self.rightBtn setBackgroundImage:[UIImage imageNamed:@"nav_left_btn_sel.png"] forState:UIControlStateSelected];
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
    }
    
    if (self.arrayCurrent) {
        if ([self.arrayCurrent count]) {
            NSDictionary *dic = [[self.arrayCurrent objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
            [cell.textLabel setText:[dic objectForKey:@"title"]];
        }
    }
    
    return cell;
}

#pragma mark -
#pragma mark tableView Delegate -----------

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dic = [[self.arrayCurrent objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
    NSString *string = [dic objectForKey:@"link"];
    UIViewController *viewController = (UIViewController *)[[NSClassFromString(string) alloc]init];
    [viewController setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return MoreCellHeight;
}


- (void)onLeftBtn:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)onRightBtn:(id)sender
{
    
}

- (void)dealloc
{
    RbSafeRelease(_tableView);
    RbSafeRelease(_arrayCurrent);
    RbSuperDealoc;
}

@end
