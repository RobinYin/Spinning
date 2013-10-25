//
//  PHViewController.m
//  Spinning
//
//  Created by Robin on 7/28/13.
//  Copyright (c) 2013 Robin. All rights reserved.
//

#import "PHViewController.h"
#import "SpinningPHCell.h"
#import "PullingRefreshTableView.h"
#import "PHValueHttpCmd.h"
#import "PHReadModel.h"
#import "ReadModel.h"
#import "PHWebViewController.h"

@interface PHViewController ()<UITableViewDataSource,UITableViewDelegate,PullingRefreshTableViewDelegate,RbHttpDelegate>

@property (nonatomic, retain)PullingRefreshTableView *tableView;
@property (nonatomic, retain)NSMutableArray *arrayCurrent;
@property (nonatomic, retain)PHValueHttpCmd *httpCmd;
@property (nonatomic, retain)NSString *cursor;

@end

@implementation PHViewController

@synthesize tableView = _tableView;
@synthesize arrayCurrent = _arrayCurrent;
@synthesize httpCmd = _httpCmd;
@synthesize cursor = _cursor;

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
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"ph_bg"]]];
    [self configureNavigationView];
    [self configureTableView];
}

- (void)configureNavigationView
{
    [super configureNavigationView];
    [self.headerImageView setImage:[UIImage imageNamed:@"title_bgph"]];
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
    SpinningPHCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [[[SpinningPHCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier]autorelease];
    }
    
    if (self.arrayCurrent) {
        if ([self.arrayCurrent count]) {
            ListModel *model = [self.arrayCurrent objectAtIndex:indexPath.row];
            
            
            LKDBHelper* globalHelper = [LKDBHelper getUsingLKDBHelper];
            [globalHelper createTableWithModelClass:[PHReadModel class]];
            ReadModel *obj = [[[PHReadModel alloc]init]autorelease];
            obj.mid = model.mid;
            NSString *search = [NSString stringWithFormat:@"mid = %@",model.mid];
            NSMutableArray* arr = [PHReadModel searchWithWhere:search orderBy:nil offset:0 count:NSIntegerMax];
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
            
            LKDBHelper* globalHelper = [LKDBHelper getUsingLKDBHelper];
            [globalHelper createTableWithModelClass:[PHReadModel class]];
            ReadModel *data = [[[PHReadModel alloc]init]autorelease ];
            data.mid = model.mid;
            [globalHelper insertToDB:data];
            
            NSLog(@"%@",model.articleurl);
            RbWebViewController *webViewController = [[PHWebViewController alloc] initWithURL:[NSURL URLWithString:[model.articleurl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
            webViewController.model = model;
            webViewController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:webViewController animated:YES];
            [webViewController release];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return PHCellHeight;
}

#pragma mark -
#pragma mark datasource -----------

- (void)onGetData
{
    RbHttpClient *client = [RbHttpClient sharedInstance];
    PHValueHttpCmd *cmd = [[[PHValueHttpCmd alloc]init]autorelease];
    self.httpCmd = cmd;
    cmd.delegate = self;
    cmd.cursor = self.cursor;
    [client onPostCmdAsync:cmd];
}

#pragma mark -
#pragma mark http delegate

- (void) httpResult:(id)cmd  error:(NSError*)error
{
    NSLog(@"%@",NSStringFromClass([cmd class]));
    PHValueHttpCmd *httpcmd = (PHValueHttpCmd *)cmd;
    
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
    RbSafeRelease(_cursor);
    RbSafeRelease(_httpCmd);
    RbSafeRelease(_tableView);
    RbSafeRelease(_arrayCurrent);
    RbSuperDealoc;
}


#pragma mark test


//- (ASIFormDataRequest*) prepareExecuteApiCmd:(NSMutableDictionary *) dic{
//
//    NSURL *url = [NSURL URLWithString:[[NSString stringWithFormat:@"http://192.168.60.205:8080/ckiasrv/registeruser"]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
//    
//    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
//    
//    NSEnumerator *enumerator = [dic keyEnumerator];
//    id key;
//    
//    while ((key = [enumerator nextObject])) {
//        id value = [dic objectForKey:key];
//        if ([value isKindOfClass:[NSString class]]) {
//            [request setPostValue:value forKey:(NSString*)key];
//        }else if ([value isKindOfClass:[NSData class]]){
//            [request addData:value forKey:key];
//        }
//    }
//    
//    
//    return request;
//}
//- (void)sendRequest
//{
//    NSString *psd = [NSString stringWithFormat:@"123456"];
//    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
//    [dic setObject:@"测试" forKey:@"username"];
//    [dic setObject:md5(psd) forKey:@"password"];
//    [dic setObject:@"test" forKey:@"realname"];
//    [dic setObject:@"test" forKey:@"address"];
//    [dic setObject:@"test@test.com" forKey:@"email"];
//    [dic setObject:@"test" forKey:@"company"];
//    [dic setObject:@"test" forKey:@"position"];
//    [dic setObject:@"15000000000" forKey:@"usercell"];
////    [dic setObject:@"0" forKey:@"id"];
////    [dic setObject:@"1" forKey:@"typeid"];
//    ASIFormDataRequest *request = [self prepareExecuteApiCmd: dic];
//    [request setDelegate:self];
//    [request setDefaultResponseEncoding:NSUTF8StringEncoding];
//    [request setDidFailSelector:@selector(registRequestDidFail:)];
//    [request setDidFinishSelector:@selector(registRequestDiFinish:)];
//    [request startAsynchronous];
//}
//
//- (void)registRequestDidFail:(ASIHTTPRequest *)request
//{
//    NSString *responseString = [request responseString];
//
//}
//
//- (void)registRequestDiFinish:(ASIHTTPRequest *)request
//{
//    NSString *responseString = [request responseString];
//    SBJSON *json = [[SBJSON alloc]init];
//    NSDictionary *resultDic = [json objectWithString:responseString error:nil];
//    [json release];
//
//}


@end
