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

@interface PHViewController ()<UITableViewDataSource,UITableViewDelegate,PullingRefreshTableViewDelegate,RbHttpDelegate>

@property (nonatomic, retain)PullingRefreshTableView *tableView;
@property (nonatomic, retain)NSMutableArray *arrayCurrent;
@property (nonatomic, retain)PHValueHttpCmd *httpCmd;

@end

@implementation PHViewController

@synthesize tableView = _tableView;
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
    
    PullingRefreshTableView* tmpTable = [[PullingRefreshTableView alloc]initWithFrame:CGRectMake(0, NavigationHeight , ScreenWidth,ScreenHeight - StatusBarHeight - NavigationHeight - TabBarHeight)];
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
    cmd.cursor = @"0";
    [client onPostCmdAsync:cmd];
}

#pragma mark -
#pragma mark http delegate

- (void) httpResult:(id)cmd  error:(NSError*)error
{
    NSLog(@"%@",NSStringFromClass([cmd class]));
    PHValueHttpCmd *httpcmd = (PHValueHttpCmd *)cmd;
    NSLog(@"%@",httpcmd);
    NSLog(@"%@",httpcmd.lists);
    NSMutableArray *array = [NSMutableArray arrayWithArray:httpcmd.lists];
    self.arrayCurrent = array;
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
