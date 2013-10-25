//
//  HistoryViewController.m
//  Spinning
//
//  Created by Robin on 8/30/13.
//  Copyright (c) 2013 Robin. All rights reserved.
//

#import "HistoryViewController.h"
#import "SpinningHistoryCell.h"
#import "HistoryHttpCmd.h"
#import "UIAlertView+MKBlockAdditions.h"
#import "LoginViewController.h"
#import "SpinningHistoryCell.h"
@interface HistoryViewController ()<UITableViewDataSource,UITableViewDelegate,PullingRefreshTableViewDelegate,RbHttpDelegate>

@property (nonatomic, retain)PullingRefreshTableView *tableView;
@property (nonatomic, retain)NSMutableArray *arrayCurrent;
@property (nonatomic, retain)HistoryHttpCmd *httpCmd;
@property (nonatomic, retain)NSString *cursor;

@end

@implementation HistoryViewController
@synthesize tableView = _tableView;
@synthesize arrayCurrent = _arrayCurrent;
@synthesize httpCmd = _httpCmd;
@synthesize cursor = _cursor;

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self tip];
    if (![self.arrayCurrent count]) {
        [self onGetData];
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

- (void)tip
{
    if (![RbUser sharedInstance].userid) {
        
        [self configureOriginData];
        
        [UIAlertView alertViewWithTitle:@"您还没有登录!"
                                message:@"请先登录后，才能进行评论操作。"
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
- (void)configureNavigationView
{
    [super configureNavigationView];
    [super configureNavigationView];
    [self.headerImageView setImage:[UIImage imageNamed:@"title_bggd"]];
    [self.leftBtn setBackgroundImage:[UIImage imageNamed:@"title_btn_return_nomal"] forState:UIControlStateNormal];
    [self.leftBtn setBackgroundImage:[UIImage imageNamed:@"title_btn_return_pressed"] forState:UIControlStateHighlighted];
    [self.leftBtn setBackgroundImage:[UIImage imageNamed:@"title_btn_return_pressed"] forState:UIControlStateSelected];
}

- (void)onLeftBtn:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)configureTableView{
    
    PullingRefreshTableView* tmpTable = [[PullingRefreshTableView alloc]initWithFrame:CGRectMake(0, NavigationHeight  + StatusHeaderHight , ScreenWidth,ScreenHeight - StatusBarHeight - NavigationHeight - TabBarHeight - StatusHeaderHight)];
    tmpTable.separatorColor = [UIColor clearColor];
    tmpTable.delegate = self;
    tmpTable.dataSource = self;
    tmpTable.pullingDelegate = self;
    tmpTable.backgroundColor = [UIColor clearColor];
    [self.view addSubview:tmpTable];
    self.tableView = tmpTable;
    //    [tmpTable launchRefreshing];
    RbSafeRelease(tmpTable);
    
}


- (NSDictionary *)onNewsListJson{
    
    NSString* path = [[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"NewsListTemplate0"] ofType:@"json"];
    NSData* data = [[NSData alloc] initWithContentsOfFile:path];
    NSString* str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    SBJSON *json = [[SBJSON alloc]init];
    NSDictionary *jsonDictionary = [json objectWithString:str error:nil];
    NSLog(@"dictionary = %@",jsonDictionary);
    
    RbSafeRelease(data);
    RbSafeRelease(json);
    RbSafeRelease(str)
    return jsonDictionary;
    
}

- (void)configureOriginData
{
    NSMutableArray *subArray = [NSMutableArray array];
    self.arrayCurrent = subArray;
    self.cursor = [NSString stringWithFormat:@"0"];
}


- (void)onRightBtn:(id)sender
{
    
}

#pragma mark -
#pragma mark tableView Datasource -----------

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.arrayCurrent count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"CellIdentifier";
    SpinningHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [[[SpinningHistoryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier]autorelease];
    }
    
    if (self.arrayCurrent) {
        if ([self.arrayCurrent count]) {
            HistoryModel *model = [self.arrayCurrent objectAtIndex:indexPath.row];
            
            
            [cell.titleLabel setText:model.name];
            [cell.cxtLabel setText:model.registertime];
        }
    }
    
    return cell;
}

#pragma mark -
#pragma mark tableView Delegate -----------

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return HistoryCellHeight;
}

#pragma mark -
#pragma mark datasource -----------

- (void)onGetData
{
    RbHttpClient *client = [RbHttpClient sharedInstance];
    HistoryHttpCmd *cmd = [[[HistoryHttpCmd alloc]init]autorelease];
    self.httpCmd = cmd;
    cmd.delegate = self;
    cmd.cursor = self.cursor;
    NSLog(@"%@",[RbUser sharedInstance].userid);
    cmd.userId = [RbUser sharedInstance].userid;
    [client onPostCmdAsync:self.httpCmd];
}

#pragma mark -
#pragma mark httpDelegate -----------
- (void) httpResult:(id)cmd  error:(NSError*)error
{
    HistoryHttpCmd *httpcmd = (HistoryHttpCmd *)cmd;
    NSString *msg = nil;
    
    if (error) {
        msg = [NSString stringWithFormat:@"网络错误"];
    }else
    {
        if ([[httpcmd.errorDict objectForKey:kSpinningHttpKeyCode] isEqualToString:kSpinningHttpKeyOk]) {
            msg = nil;
        }else
        {
            msg = [httpcmd.errorDict objectForKey:kSpinningHttpKeyMsg];
        }
    }
    if (msg) {
        [YRDropdownView showDropdownInView:self.view
                                     title:@"提示！"
                                    detail:[NSString stringWithFormat:@"%@!",msg]
                                     image:[UIImage imageNamed:@"dropdown-alert"]
                                  animated:YES
                                 hideAfter:3];
    }
    NSMutableArray *array = [NSMutableArray arrayWithArray:httpcmd.lists];
    if ([self.cursor isEqualToString:@"0"]) {
        self.arrayCurrent = array;
    }else
    {
        [self.arrayCurrent addObjectsFromArray:array];
    }
    if ([self.arrayCurrent count]) {
        ListModel *model = [self.arrayCurrent lastObject];
        if (model.mid) {
            self.cursor = model.mid;
            [InfoCountSingleton sharedInstance].notice = model.mid;
        }
        ListModel *info = [self.arrayCurrent objectAtIndex:0];
        if (info.mid) {
            [InfoCountSingleton sharedInstance].notice = info.mid;
            NSLog(@"%@",info.mid);
            [[InfoCountSingleton sharedInstance] save];
        }
    }
    [self.tableView tableViewDidFinishedLoading];
    if ([array count] ==10) {
        self.tableView.reachedTheEnd  = NO;
    }else
    {
        self.tableView.reachedTheEnd  = YES;
    }
    [self.tableView reloadData];
}


#pragma mark -
#pragma mark pullingTableViewDelegate -----------
- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView
{
    self.cursor = [NSString stringWithFormat:@"0"];
    [self onGetData];
}


- (void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView
{
    [self onGetData];
}

- (NSDate *)pullingTableViewRefreshingFinishedDate
{
    NSDateFormatter *df = [[[NSDateFormatter alloc] init ]autorelease];
    df.dateFormat = @"yyyy-MM-dd HH:mm";
    NSString *dateStr = [df stringFromDate:[NSDate date]];
    NSDate *date = [df dateFromString:dateStr];
    return date;
}


- (NSDate *)pullingTableViewLoadingFinishedDate
{
    NSDateFormatter *df = [[[NSDateFormatter alloc] init ]autorelease];
    df.dateFormat = @"yyyy-MM-dd HH:mm";
    NSString *dateStr = [df stringFromDate:[NSDate date]];
    NSDate *date = [df dateFromString:dateStr];
    return date;
}


#pragma mark -
#pragma mark - ScrollView Method
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.tableView tableViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self.tableView tableViewDidEndDragging:scrollView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)dealloc
{
    RbSafeRelease(_cursor);
    RbSafeRelease(_httpCmd);
    RbSafeRelease(_tableView);
    RbSafeRelease(_arrayCurrent);
    RbSuperDealoc;
}

@end
