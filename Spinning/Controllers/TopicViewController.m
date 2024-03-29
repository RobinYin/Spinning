//
//  TopicViewController.m
//  Spinning
//
//  Created by Robin on 7/28/13.
//  Copyright (c) 2013 Robin. All rights reserved.
//

#import "TopicViewController.h"
#import "SpinningTopicCell.h"
#import "TopicHttpCmd.h"
#import "TopicWebViewController.h"
#import "ReadModel.h"
#import "TopicReadModel.h"
#import "CommentcountHttpCmd.h"

@interface TopicViewController ()<UITableViewDataSource,UITableViewDelegate,PullingRefreshTableViewDelegate,RbHttpDelegate>

@property (nonatomic, retain)PullingRefreshTableView *tableView;
@property (nonatomic, retain)NSMutableArray *arrayCurrent;
@property (nonatomic, retain)TopicHttpCmd *httpCmd;
@property (nonatomic, retain)NSString *cursor;
@property (nonatomic, retain)CommentcountHttpCmd *countHttpCmd;

@end

@implementation TopicViewController

@synthesize tableView = _tableView;
@synthesize arrayCurrent = _arrayCurrent;
@synthesize httpCmd = _httpCmd;
@synthesize cursor = _cursor;
@synthesize countHttpCmd = _countHttpCmd;

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
    [self onGetCount];
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

- (void)configureNavigationView
{
    [super configureNavigationView];
    [self.headerImageView setImage:[UIImage imageNamed:@"title_bght"]];
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
    SpinningTopicCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [[[SpinningTopicCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier]autorelease];
    }
    
    if (self.arrayCurrent) {
        if ([self.arrayCurrent count]) {
            ListModel *model = [self.arrayCurrent objectAtIndex:indexPath.row];
            
            
            LKDBHelper* globalHelper = [LKDBHelper getUsingLKDBHelper];
            [globalHelper createTableWithModelClass:[TopicReadModel class]];
            ReadModel *obj = [[[TopicReadModel alloc]init]autorelease];
            obj.mid = model.mid;
            NSString *search = [NSString stringWithFormat:@"mid = %@",model.mid];
            NSMutableArray* arr = [TopicReadModel searchWithWhere:search orderBy:nil offset:0 count:NSIntegerMax];
            if ([arr count]) {
                [cell.titleLabel setTextColor:[UIColor whiteColor]];
                [cell.subLabel setTextColor:[UIColor whiteColor]];
            }else
            {
                [cell.titleLabel setTextColor:[UIColor colorWithRed:255./255 green:244./255 blue:98./255 alpha:1]];
                [cell.subLabel setTextColor:[UIColor colorWithRed:255./255 green:244./255 blue:98./255 alpha:1]];
            }
            
            [cell.titleLabel setText:model.title];
            [cell.cxtLabel setText:model.content];
            [cell.cxtImgView setImageWithURL:[NSURL URLWithString:[model.icon stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:[UIImage imageNamed:@"img_defaul"]];
            [cell.subLabel setText:[NSString stringWithFormat:@"已有%@人参与评论",model.totalcount]];
//            [cell.badgeView setBadgeString:@""];
            NSLog(@"totalcount = %@",model.totalcount);
            
            
            [globalHelper createTableWithModelClass:[CommentcountModel class]];
            CommentcountModel *cmdl = [[[CommentcountModel alloc]init]autorelease];
            cmdl.mid = [NSString stringWithFormat:@"%@",model.mid];
//            cmdl.mid = model.mid;
            NSString *srch = [NSString stringWithFormat:@"mid = %@",cmdl.mid];
            NSMutableArray* arrc = [CommentcountModel searchWithWhere:srch orderBy:nil offset:0 count:NSIntegerMax];
            if ([arrc count]) {
                CommentcountModel *dbmodel = [arrc objectAtIndex:0];
                NSLog(@"dbmodle = %@",dbmodel.count);
                if ([dbmodel.count intValue] > [model.totalcount intValue]) {
                    [cell.badgeView setBadgeString:[NSString stringWithFormat:@"%d",[dbmodel.count intValue] - [model.totalcount intValue]]];
                    [cell.subLabel setText:[NSString stringWithFormat:@"已有%@人参与评论",dbmodel.count]];
                }else
                {
                    [cell.badgeView setBadgeString:@""];
                }
            }
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
            
            
            LKDBHelper* globalHelper = [LKDBHelper getUsingLKDBHelper];
            [globalHelper createTableWithModelClass:[TopicReadModel class]];
            ReadModel *data = [[[TopicReadModel alloc]init]autorelease ];
            data.mid = model.mid;
            [globalHelper insertToDB:data];
            
            
            [globalHelper createTableWithModelClass:[CommentcountModel class]];
            CommentcountModel *cmdl = [[[CommentcountModel alloc]init]autorelease];
            cmdl.mid = model.mid;
            NSString *srch = [NSString stringWithFormat:@"mid = %@",cmdl.mid];
            NSMutableArray* arrc = [CommentcountModel searchWithWhere:srch orderBy:nil offset:0 count:NSIntegerMax];
            if ([arrc count]) {
                CommentcountModel *dbmodel = [arrc objectAtIndex:0];
                model.totalcount = dbmodel.count;
            }
            
            NSLog(@"%@",model.articleurl);
            RbWebViewController *webViewController = [[TopicWebViewController alloc] initWithURL:[NSURL URLWithString:[model.articleurl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
            webViewController.mid = model.mid;
            webViewController.model = model;
            webViewController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:webViewController animated:YES];
            [webViewController release];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return TopicCellHeight;
}

#pragma mark -
#pragma mark datasource -----------
- (void)onGetCount
{
    RbHttpClient *client = [RbHttpClient sharedInstance];
    CommentcountHttpCmd *cmd = [[[CommentcountHttpCmd alloc]init]autorelease];
    self.countHttpCmd = cmd;
    cmd.delegate = self;
    [client onPostCmdAsync:self.countHttpCmd];
}
- (void)onGetData
{
    RbHttpClient *client = [RbHttpClient sharedInstance];
    TopicHttpCmd *cmd = [[[TopicHttpCmd alloc]init]autorelease];
    self.httpCmd = cmd;
    cmd.delegate = self;
    cmd.cursor = self.cursor;
    [client onPostCmdAsync:self.httpCmd];
}

#pragma mark -
#pragma mark httpDelegate -----------
- (void) httpResult:(id)cmd  error:(NSError*)error
{
    if ([cmd isMemberOfClass:[TopicHttpCmd class]]) {
        TopicHttpCmd *httpcmd = (TopicHttpCmd *)cmd;
        
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
                                     hideAfter:TipTime];
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
            }
            ListModel *info = [self.arrayCurrent objectAtIndex:0];
            if (info.mid) {
                [InfoCountSingleton sharedInstance].topic = info.mid;
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

    }
    if ([cmd isMemberOfClass:[CommentcountHttpCmd class]]) {
        CommentcountHttpCmd *httpcmd = (CommentcountHttpCmd *)cmd;
        
        NSMutableArray *array = [NSMutableArray arrayWithArray:httpcmd.lists];
        if ([array count]) {
            for (CommentcountModel *model in array) {
                LKDBHelper* globalHelper = [LKDBHelper getUsingLKDBHelper];
                [globalHelper createTableWithModelClass:[CommentcountModel class]];
                CommentcountModel *data = [[[CommentcountModel alloc]init]autorelease];
                data.mid = model.mid;
                data.count = model.count;
                [globalHelper insertToDB:data];
            }
        }
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
    RbSafeRelease(_tableView);
    RbSafeRelease(_arrayCurrent);
    RbSuperDealoc;
}
@end
