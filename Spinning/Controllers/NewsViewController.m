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
#import "ReadModel.h"
#import "NewsReadModel0.h"
#import "NewsReadModel1.h"
#import "NewsReadModel2.h"
#import "NewsReadModel3.h"
#import "NewsReadModel4.h"
#import "NewsReadModel5.h"
#import "NewsReadModel6.h"
#import "NewsReadModel7.h"
#import "NewsWebViewController.h"

@interface NewsViewController ()<UITableViewDataSource,UITableViewDelegate,PullingRefreshTableViewDelegate,RbHttpDelegate>

@property (nonatomic, retain)PullingRefreshTableView *tableView;
@property (nonatomic, retain)NSMutableArray *arrayContainer;
@property (nonatomic, retain)NSMutableArray *arrayCurrent;
@property (nonatomic, retain)NSMutableArray *arrayCursor;
@property (nonatomic, retain)NSMutableArray *arrayTables;
@property (nonatomic, retain)RbHttpCmd *httpCmd;
@property (nonatomic, retain)UIScrollView *pageScrollView;
@property (nonatomic, retain)RbScorllSecletView *selectScrollView;
@property (nonatomic, assign)NSInteger cursorId;

@end

@implementation NewsViewController

@synthesize tableView = _tableView;
@synthesize arrayContainer = _arrayContainer;
@synthesize arrayCurrent = _arrayCurrent;
@synthesize arrayCursor = _arrayCursor;
@synthesize arrayTables = _arrayTables;
@synthesize httpCmd = _httpCmd;
@synthesize pageScrollView = _pageScrollView;
@synthesize selectScrollView = _selectScrollView;
@synthesize cursorId = _cursorId;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
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
    RbScorllSecletView *selectView = [[RbScorllSecletView alloc]initWithFrame:CGRectMake(0, NavigationHeight + StatusHeaderHight, ScrollSelectWidth, ScrollSelectHeight)];
    [selectView setSelectDelegate:self];
    [selectView setTitles:@[@"行业动态",@"企业追踪",@"跨界观察",@"领袖故事",@"专栏评论",@"技术前沿",@"数说商业",@"CKIA数据"]];
    [self.view addSubview:selectView];
    self.selectScrollView = selectView;
    RbSafeRelease(selectView);
    
    UIView *arrowView = [[UIView alloc]initWithFrame:CGRectMake(ScrollSelectWidth, NavigationHeight+ StatusHeaderHight, ScrollSelectOtherWidth, ScrollSelectHeight)];
    [arrowView setBackgroundColor:[UIColor colorWithRed:0./255. green:55./255 blue:110./255 alpha:1]];
    
    UIImageView *arrowImageView = [[UIImageView alloc]initWithFrame:CGRectMake(4, 6.5, 12, 12)];
    [arrowImageView setImage:[UIImage imageNamed:@"arrow-forward-icon"]];
    
    [arrowView addSubview:arrowImageView];
    [arrowImageView release];
    
    [self.view addSubview:arrowView];
    [arrowView release];
    
}

- (void)configureTableView{
    
    UIScrollView *mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, NavigationHeight + ScrollSelectHeight +StatusHeaderHight , ScreenWidth,ScreenHeight - StatusBarHeight - NavigationHeight - TabBarHeight - ScrollSelectHeight - StatusHeaderHight)];
    mainScrollView.contentSize = CGSizeMake(320*8, 0);
    mainScrollView.showsHorizontalScrollIndicator = NO;
    mainScrollView.pagingEnabled = YES;
    mainScrollView.delegate = self;
    self.pageScrollView = mainScrollView;
    [self.view addSubview:mainScrollView];
    RbSafeRelease(mainScrollView);
    
    for (int i = 0; i < 8; i ++) {
        PullingRefreshTableView* tmpTable = [[PullingRefreshTableView alloc]initWithFrame:CGRectMake(320*i, 0 , ScreenWidth,self.pageScrollView.frame.size.height)];
        tmpTable.separatorColor = [UIColor clearColor];
        tmpTable.delegate = self;
        tmpTable.dataSource = self;
        tmpTable.pullingDelegate = self;
        tmpTable.backgroundColor = [UIColor clearColor];
        [self.pageScrollView addSubview:tmpTable];
        [self.arrayTables addObject:tmpTable];
        RbSafeRelease(tmpTable);
    }
    self.tableView =[self.arrayTables objectAtIndex:0];
//    PullingRefreshTableView* tmpTable = [[PullingRefreshTableView alloc]initWithFrame:CGRectMake(0, NavigationHeight + ScrollSelectHeight +StatusHeaderHight , ScreenWidth,ScreenHeight - StatusBarHeight - NavigationHeight - TabBarHeight - ScrollSelectHeight - StatusHeaderHight)];
//    tmpTable.separatorColor = [UIColor clearColor];
//    tmpTable.delegate = self;
//    tmpTable.dataSource = self;
//    tmpTable.pullingDelegate = self;
//    tmpTable.backgroundColor = [UIColor clearColor];
//    [self.view addSubview:tmpTable];
//    self.tableView = tmpTable;
//    RbSafeRelease(tmpTable);
    
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
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:8];
    NSMutableArray *cursor = [NSMutableArray arrayWithCapacity:8];
    for (int i = 0; i < 8; i ++) {
        NSMutableArray *subArray = [NSMutableArray array];
        NSMutableString *string = [NSMutableString stringWithFormat:@"0"];
        [cursor addObject:string];
        [array addObject:subArray];
    }
    self.arrayContainer = array;
    self.arrayCurrent = [array objectAtIndex:0];
    self.arrayCursor = cursor;
    
    self.cursorId = 0;
    
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:8];
    self.arrayTables = arr;
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
            
            
            NSString *string = [NSString stringWithFormat:@"NewsReadModel%d",[self.arrayContainer indexOfObject:self.arrayCurrent]];
            LKDBHelper* globalHelper = [LKDBHelper getUsingLKDBHelper];
            [globalHelper createTableWithModelClass:[NSClassFromString(string) class]];
            ReadModel *obj = [[[[NSClassFromString(string) class] alloc]init]autorelease];
            obj.mid = model.mid;
            NSString *search = [NSString stringWithFormat:@"mid = %@",model.mid];
            NSMutableArray* arr = [[NSClassFromString(string) class] searchWithWhere:search orderBy:nil offset:0 count:NSIntegerMax];
            if ([arr count]) {
                [cell.titleLabel setTextColor:[UIColor whiteColor]];
            }else
            {
                [cell.titleLabel setTextColor:[UIColor colorWithRed:255./255 green:244./255 blue:98./255 alpha:1]];
            }
            
            
            
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
            
            
            
            NSString *string = [NSString stringWithFormat:@"NewsReadModel%d",[self.arrayContainer indexOfObject:self.arrayCurrent]];
            LKDBHelper* globalHelper = [LKDBHelper getUsingLKDBHelper];
            [globalHelper createTableWithModelClass:[NSClassFromString(string) class]];
            ReadModel *data = [[[[NSClassFromString(string) class] alloc]init]autorelease ];
            data.mid = model.mid;
            [globalHelper insertToDB:data];
            
            RbWebViewController *webViewController = [[NewsWebViewController alloc] initWithURL:[NSURL URLWithString:[model.articleurl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
            webViewController.model = model;
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
    if ([self.arrayTables count]) {
        self.tableView = [self.arrayTables objectAtIndex:index];
        [self.pageScrollView setContentOffset:CGPointMake(ScreenWidth *index, 0) animated:YES];
    }
    [self onGetDataAtIndex:index];
}

- (void)onGetDataAtIndex:(NSInteger)index
{
    self.cursorId = index;
    
    if (![[self.arrayContainer objectAtIndex:index]count]) {
        RbHttpClient *client = [RbHttpClient sharedInstance];
        NewsHttpCmd *cmd = [[[NewsHttpCmd alloc]init]autorelease];
        self.httpCmd = cmd;
        cmd.delegate = self;
//        cmd.cursor = [NSString stringWithString:[self.arrayCursor objectAtIndex:[self.arrayContainer indexOfObject:self.arrayCurrent]]];
        cmd.cursor = [NSString stringWithString:[self.arrayCursor objectAtIndex:index]];
        cmd.userId = [RbUser sharedInstance].userid;
        cmd.typeId = [NSString stringWithFormat:@"%d",index +1];
        [client onPostCmdAsync:self.httpCmd];
    }else
    {
        self.arrayCurrent = [self.arrayContainer objectAtIndex:index];
        [self.tableView reloadData];
    }
    NSLog(@"%@",self.arrayContainer);
}

- (void)onUpdateAtIndex:(NSUInteger)index
{
    RbHttpClient *client = [RbHttpClient sharedInstance];
    NewsHttpCmd *cmd = [[[NewsHttpCmd alloc]init]autorelease];
    self.httpCmd = cmd;
    cmd.delegate = self;
    cmd.cursor = [NSString stringWithString:[self.arrayCursor objectAtIndex:index]];
//    cmd.cursor = [NSString stringWithString:[self.arrayCursor objectAtIndex:[self.arrayContainer indexOfObject:self.arrayCurrent]]];
    cmd.userId = [RbUser sharedInstance].userid;
    cmd.typeId = [NSString stringWithFormat:@"%d",index +1];
    [client onPostCmdAsync:self.httpCmd];
}
#pragma mark -
#pragma mark httpDelegate -----------
- (void) httpResult:(id)cmd  error:(NSError*)error
{
    NSLog(@"%@",NSStringFromClass([cmd class]));
    NewsHttpCmd *httpcmd = (NewsHttpCmd *)cmd;
    
    NSString *msg = nil;
    
    if (error) {
        msg = [NSString stringWithFormat:@"网络错误"];
    }else
    {
        if ([[httpcmd.errorDict objectForKey:kSpinningHttpKeyCode] isEqualToString:kSpinningHttpKeyOk]) {
            msg = nil;
        }else
        {
//            if ([[httpcmd.errorDict objectForKey:kSpinningHttpKeyCode] isEqualToString:kSpinningHttpKeyError4000]) {
//                msg = [NSString stringWithFormat:@"成为协会会员，才有权浏览!"];
//            }else
//            {
               msg = [httpcmd.errorDict objectForKey:kSpinningHttpKeyMsg];
//            }
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
    NSLog(@"%@",[self.arrayCursor objectAtIndex:[httpcmd.typeId intValue] -1]);
    if ([[self.arrayCursor objectAtIndex:[httpcmd.typeId intValue] -1] isEqualToString:@"0"]) {
        [self.arrayContainer replaceObjectAtIndex:[httpcmd.typeId intValue] -1 withObject:array];
    }else
    {
        [[self.arrayContainer objectAtIndex:[httpcmd.typeId intValue] -1]addObjectsFromArray:array];
    }
    self.arrayCurrent = [self.arrayContainer objectAtIndex:[httpcmd.typeId intValue] -1];
    NSLog(@"self.arrayCurrent = %@",self.arrayCurrent);
    if ([self.arrayCurrent count]) {
        ListModel *model = [self.arrayCurrent lastObject];
        if (model.mid) {
        NSMutableString *string =[NSMutableString stringWithFormat:@"%@", model.mid];
        [self.arrayCursor replaceObjectAtIndex:[httpcmd.typeId intValue] -1 withObject:string];
        }
        NSLog(@"%@",[self.arrayCursor objectAtIndex:[httpcmd.typeId intValue] -1]);
    }
    [self.tableView tableViewDidFinishedLoading];
    [self.tableView reloadData];
}

#pragma mark -
#pragma mark pullingTableViewDelegate -----------
- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView
{
    NSMutableString *string = [NSMutableString stringWithFormat:@"0"];
    [self.arrayCursor replaceObjectAtIndex:self.cursorId withObject:string];
    NSLog(@"%d",[self.arrayContainer indexOfObject:self.arrayCurrent]);
    [self onUpdateAtIndex:self.cursorId];
//    [self onUpdateAtIndex:[self.arrayContainer indexOfObject:self.arrayCurrent]];
}


- (void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView
{
    [self onUpdateAtIndex:self.cursorId];
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
    if ([scrollView isMemberOfClass:[PullingRefreshTableView class]]) {
       [self.tableView tableViewDidScroll:scrollView];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if ([scrollView isMemberOfClass:[PullingRefreshTableView class]]) {
        [self.tableView tableViewDidEndDragging:scrollView];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == self.pageScrollView) {
        NSInteger index = (NSInteger)scrollView.contentOffset.x/320;
        NSLog(@"%d",index);
        [self.selectScrollView scrollToIndex:index];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    RbSafeRelease(_httpCmd);
    RbSafeRelease(_arrayCursor);
    RbSafeRelease(_arrayCurrent);
    RbSafeRelease(_arrayContainer);
    RbSafeRelease(_arrayTables);
    RbSafeRelease(_tableView);
    RbSafeRelease(_pageScrollView);
    RbSuperDealoc;
}

@end
