//
//  NewsViewController.m
//  Spinning
//
//  Created by Robin on 7/28/13.
//  Copyright (c) 2013 Robin. All rights reserved.
//

#import "NewsViewController.h"
#import "SpinningNewsCell.h"
#import "NewsHttpCmd.h"

@interface NewsViewController ()<UITableViewDataSource,UITableViewDelegate,PullingRefreshTableViewDelegate,RbHttpDelegate>

@property (nonatomic, retain)PullingRefreshTableView *tableView;
@property (nonatomic, retain)NSMutableArray *arrayContainer;
@property (nonatomic, retain)NSMutableArray *arrayCurrent;
@property (nonatomic, retain)RbHttpCmd *httpCmd;

@end

@implementation NewsViewController

@synthesize tableView = _tableView;
@synthesize arrayContainer = _arrayContainer;
@synthesize arrayCurrent = _arrayCurrent;
@synthesize httpCmd = _httpCmd;

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
    [self onGetDataAtIndex:0];
	// Do any additional setup after loading the view.
}

- (void)configureAllViews
{
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"news_bg"]]];
    [self configureNavigationView];
    [self configureOtherViews];
    [self configureTableView];
}

- (void)configureNavigationView
{
    [super configureNavigationView];
    [self.headerImageView setImage:[UIImage imageNamed:@"title_bgxw"]];
    [self.leftBtn setHidden:YES];
}

- (void)configureOtherViews
{
    RbScorllSecletView *selectView = [[RbScorllSecletView alloc]initWithFrame:CGRectMake(0, NavigationHeight, ScrollSelectWidth, ScrollSelectHeight)];
    [selectView setSelectDelegate:self];
    [selectView setTitles:@[@"行业动态",@"领袖观点",@"消费调查",@"技术前沿",@"跨界观察",@"专题聚焦",@"数据挖掘"]];
    
    [self.view addSubview:selectView];
    [selectView release];
    
    UIView *arrowView = [[UIView alloc]initWithFrame:CGRectMake(ScrollSelectWidth, NavigationHeight, ScrollSelectOtherWidth, ScrollSelectHeight)];
    [arrowView setBackgroundColor:[UIColor colorWithRed:0./255. green:55./255 blue:110./255 alpha:1]];
    
    UIImageView *arrowImageView = [[UIImageView alloc]initWithFrame:CGRectMake(4, 6.5, 12, 12)];
    [arrowImageView setImage:[UIImage imageNamed:@"arrow-forward-icon"]];
    
    [arrowView addSubview:arrowImageView];
    [arrowImageView release];
    
    [self.view addSubview:arrowView];
    [arrowView release];
    
}

- (void)configureTableView{
    
    PullingRefreshTableView* tmpTable = [[PullingRefreshTableView alloc]initWithFrame:CGRectMake(0, NavigationHeight + ScrollSelectHeight , ScreenWidth,ScreenHeight - StatusBarHeight - NavigationHeight - TabBarHeight - ScrollSelectHeight)];
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


- (NSDictionary *)onNewsListJson:(NSInteger)index{
    
    NSString* path = [[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"NewsListTemplate%d",index] ofType:@"json"];
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
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:7];
    for (int i = 0; i < 7; i ++) {
        NSMutableArray *subArray = [NSMutableArray array];
        [array addObject:subArray];
    }
    self.arrayContainer = array;
    self.arrayCurrent = [array objectAtIndex:0];
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
    SpinningNewsCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [[[SpinningNewsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier]autorelease];
    }
    
    if (self.arrayCurrent) {
        if ([self.arrayCurrent count]) {
            ListModel *model = [self.arrayCurrent objectAtIndex:indexPath.row];
            [cell.titleLabel setText:model.title];
            [cell.cxtLabel setText:model.content];
            [cell.cxtImgView setImageWithURL:[NSURL URLWithString:[model.icon stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:[UIImage imageNamed:@"img_defaul"]];
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
            RbWebViewController *webViewController = [[RbWebViewController alloc] initWithURL:[NSURL URLWithString:[model.articleurl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
            webViewController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:webViewController animated:YES];
            [webViewController release];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NewsCellHeight;
}

#pragma mark -
#pragma mark ScrollSelectDelegate -----------

- (void)scrollSelectAtIndex:(NSInteger)index
{
    [self onGetDataAtIndex:index];
}

- (void)onGetDataAtIndex:(NSInteger)index
{
    
    if (![[self.arrayContainer objectAtIndex:index]count]) {
        RbHttpClient *client = [RbHttpClient sharedInstance];
        NewsHttpCmd *cmd = [[[NewsHttpCmd alloc]init]autorelease];
        self.httpCmd = cmd;
        cmd.delegate = self;
        cmd.cursor = @"0";
        cmd.typeId = [NSString stringWithFormat:@"%d",index +1];
        [client onPostCmdAsync:self.httpCmd];
    }else
    {
        self.arrayCurrent = [self.arrayContainer objectAtIndex:index];
        [self.tableView reloadData];
    }
    NSLog(@"%@",self.arrayContainer);
}
#pragma mark -
#pragma mark httpDelegate -----------
- (void) httpResult:(id)cmd  error:(NSError*)error
{
    NSLog(@"%@",NSStringFromClass([cmd class]));
    NewsHttpCmd *httpcmd = (NewsHttpCmd *)cmd;
    NSLog(@"%@",httpcmd);
    NSLog(@"%@",httpcmd.lists);
    NSLog(@"%@",httpcmd.typeId);
    NSMutableArray *array = [NSMutableArray arrayWithArray:httpcmd.lists];
    [self.arrayContainer replaceObjectAtIndex:[httpcmd.typeId intValue] -1 withObject:array];
    self.arrayCurrent = array;
    
//    if (![[self.arrayContainer objectAtIndex:index]count]) {
//        NSDictionary *dic = [NSDictionary dictionaryWithDictionary:[self onNewsListJson:index]];
//        NSMutableArray *array = [NSMutableArray arrayWithArray:[dic objectForKey:@"list"]];
//        [self.arrayContainer replaceObjectAtIndex:index withObject:array];
//        self.arrayCurrent = array;
//    }else
//    {
//        self.arrayCurrent = [self.arrayContainer objectAtIndex:index];
//    }
    [self.tableView reloadData];
}

#pragma mark -
#pragma mark pullingTableViewDelegate -----------
- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView
{
    [self performSelector:@selector(loadData) withObject:nil afterDelay:1.f];
}


- (void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView
{
    [self performSelector:@selector(loadData) withObject:nil afterDelay:1.f];
}

- (NSDate *)pullingTableViewRefreshingFinishedDate
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init ];
    df.dateFormat = @"yyyy-MM-dd HH:mm";
    NSString *dateStr = [df stringFromDate:[NSDate date]];
    NSDate *date = [df dateFromString:dateStr];
    return date;
}


- (NSDate *)pullingTableViewLoadingFinishedDate
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init ];
    df.dateFormat = @"yyyy-MM-dd HH:mm";
    NSString *dateStr = [df stringFromDate:[NSDate date]];
    NSDate *date = [df dateFromString:dateStr];
    return date;
}

- (void)loadData
{
    [self.tableView tableViewDidFinishedLoading];
    self.tableView.reachedTheEnd  = NO;
    [self.tableView reloadData];
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
    RbSafeRelease(_httpCmd);
    RbSafeRelease(_arrayCurrent);
    RbSafeRelease(_arrayContainer);
    RbSafeRelease(_tableView);
    RbSuperDealoc;
}

@end