//
//  NotificationViewController.m
//  Spinning
//
//  Created by Robin on 7/28/13.
//  Copyright (c) 2013 Robin. All rights reserved.
//

#import "NotificationViewController.h"
#import "SpinningNotificationCell.h"
#import "NotifyHttpCmd.h"
#import "UIAlertView+MKBlockAdditions.h"
#import "LoginViewController.h"
#import "ReadModel.h"
#import "NotifyReadModel.h"
#import "NotifyWebViewController.h"

@interface NotificationViewController ()<UITableViewDataSource,UITableViewDelegate,PullingRefreshTableViewDelegate,RbHttpDelegate>

@property (nonatomic, retain)PullingRefreshTableView *tableView;
@property (nonatomic, retain)NSMutableArray *arrayCurrent;
@property (nonatomic, retain)NotifyHttpCmd *httpCmd;
@property (nonatomic, retain)NSString *cursor;


@end

@implementation NotificationViewController

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

- (void)tip
{
    if (![RbUser sharedInstance].userid) {
        
        [self configureOriginData];
        
        [UIAlertView alertViewWithTitle:@"您还没有登录!"
                                message:@"请先登录后，才能查看通知。"
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
    [self.headerImageView setImage:[UIImage imageNamed:@"title_bgtz"]];
    [self.leftBtn setHidden:YES];
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
    SpinningNotificationCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [[[SpinningNotificationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier]autorelease];
    }
    
    if (self.arrayCurrent) {
        if ([self.arrayCurrent count]) {
            ListModel *model = [self.arrayCurrent objectAtIndex:indexPath.row];
            
            LKDBHelper* globalHelper = [LKDBHelper getUsingLKDBHelper];
            [globalHelper createTableWithModelClass:[NotifyReadModel class]];
            ReadModel *obj = [[[NotifyReadModel alloc]init]autorelease];
            obj.mid = model.mid;
            NSString *search = [NSString stringWithFormat:@"mid = %@",model.mid];
            NSMutableArray* arr = [NotifyReadModel searchWithWhere:search orderBy:nil offset:0 count:NSIntegerMax];
            if ([arr count]) {
                [cell.titleLabel setTextColor:[UIColor whiteColor]];
            }else
            {
                [cell.titleLabel setTextColor:[UIColor colorWithRed:255./255 green:244./255 blue:98./255 alpha:1]];
            }
            
            [cell.titleLabel setText:model.title];
            [cell.cxtLabel setText:model.time];
        }
    }
    
    return cell;
}

#pragma mark -
#pragma mark tableView Delegate -----------

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.arrayCurrent) {
        if ([self.arrayCurrent count]) {
            ListModel *model = [self.arrayCurrent objectAtIndex:indexPath.row];
            NSLog(@"%@",model.articleurl);
            
            LKDBHelper* globalHelper = [LKDBHelper getUsingLKDBHelper];
            [globalHelper createTableWithModelClass:[NotifyReadModel class]];
            ReadModel *data = [[[NotifyReadModel alloc]init]autorelease ];
            data.mid = model.mid;
            [globalHelper insertToDB:data];
            
            RbWebViewController *webViewController = [[NotifyWebViewController alloc] initWithURL:[NSURL URLWithString:[model.articleurl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
            webViewController.model = model;
            webViewController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:webViewController animated:YES];
            [webViewController release];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NotificationCellHeight;
}

#pragma mark -
#pragma mark datasource -----------

- (void)onGetData
{
    RbHttpClient *client = [RbHttpClient sharedInstance];
    NotifyHttpCmd *cmd = [[[NotifyHttpCmd alloc]init]autorelease];
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
    NotifyHttpCmd *httpcmd = (NotifyHttpCmd *)cmd;
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
        if (![msg isEqualToString: @"您尚未登录"]) {
            [YRDropdownView showDropdownInView:self.view
                                         title:@"提示！"
                                        detail:[NSString stringWithFormat:@"%@!",msg]
                                         image:[UIImage imageNamed:@"dropdown-alert"]
                                      animated:YES
                                     hideAfter:TipTime];
        }
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
