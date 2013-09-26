//
//  CommentViewController.m
//  Spinning
//
//  Created by Robin on 9/16/13.
//  Copyright (c) 2013 Robin. All rights reserved.
//

#import "CommentViewController.h"
#import "CommentHttpCmd.h"
#import "SpinningCommentCell.h"
#import "GrowingTextView.h"
#import "RemarkHttpCmd.h"
#import <QuartzCore/QuartzCore.h>

@interface CommentViewController ()<UITableViewDataSource,UITableViewDelegate,PullingRefreshTableViewDelegate,RbHttpDelegate,GrowingTextViewDelegate>
{
    float _keybordHeight;
    float _textFieldHeight;
}
@property (nonatomic, retain)PullingRefreshTableView *tableView;
@property (nonatomic, retain)NSMutableArray *arrayCurrent;
@property (nonatomic, retain)CommentHttpCmd *httpCmd;
@property (nonatomic, retain)NSString *cursor;

@property (nonatomic, retain)RemarkHttpCmd *remarkCmd;
@property (nonatomic, retain)UIImageView* toolBar;
@property (nonatomic, retain)GrowingTextView* textField;
@property (nonatomic, retain)NSString *suggestion;


@end

@implementation CommentViewController

@synthesize tableView = _tableView;
@synthesize arrayCurrent = _arrayCurrent;
@synthesize httpCmd = _httpCmd;
@synthesize cursor = _cursor;
@synthesize mid = _mid;
@synthesize toolBar = _toolBar;
@synthesize textField = _textField;
@synthesize remarkCmd = _remarkCmd;
@synthesize suggestion = _suggestion;

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
    [self configureOtherView];
}

- (void)configureOtherView
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasHidden:) name:UIKeyboardWillHideNotification object:nil];
    [self configureToolBar];
}

- (void)configureToolBar{
    _toolBar = [[UIImageView alloc]initWithFrame:CGRectMake(0, ScreenHeight - StatusBarHeight - NavigationHeight, ScreenWidth, NavigationHeight)];
    _toolBar.backgroundColor = [UIColor orangeColor];
    _toolBar.image = [UIImage imageNamed:@"nav_bg"];
    _toolBar.userInteractionEnabled = YES;
    
    _textField = [[GrowingTextView alloc]initWithFrame:CGRectMake(5, 5.f,254, 31)];
    _textFieldHeight = 31;
    _textField.backgroundColor = [UIColor clearColor];
    _textField.textColor = [UIColor blackColor];
    _textField.delegate = self;
    _textField.font = [UIFont systemFontOfSize:14];
    _textField.minNumberOfLines = 1;
    _textField.maxNumberOfLines = 5;
    [_textField.layer setBorderWidth:1];
    [_textField.layer setCornerRadius:5];
    [_textField.layer setMasksToBounds:YES];
    [_toolBar addSubview:_textField];
    
    UIButton* okButton = [[UIButton alloc]initWithFrame:CGRectMake(264, 0, 55, 40)];
    
    [okButton setBackgroundImage:[UIImage imageNamed:@"ok_Btn.png"] forState:UIControlStateNormal];
    [okButton addTarget:self action:@selector(okButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [_toolBar addSubview:okButton];
    RbSafeRelease(okButton);
    [self.view addSubview:_toolBar];
    
}

- (void)okButtonPressed:(id)sender{
    [_textField.internalTextView resignFirstResponder];
    [self onRemarkData];
}


#pragma mark-- Keyboard Nitification

- (BOOL)growingTextViewShouldBeginEditing:(GrowingTextView *)growingTextView
{
    return YES;
}
- (void)growingTextView:(GrowingTextView *)growingTextView didChangeHeight:(float)height{
    _textFieldHeight = height;
    if (height == 31||height==34) {
        _toolBar.frame=CGRectMake(0,  ScreenHeight - StatusBarHeight - NavigationHeight - _keybordHeight, ScreenWidth, NavigationHeight);
    }
    else {
        _toolBar.frame = CGRectMake(0, ScreenHeight - StatusBarHeight - NavigationHeight-_keybordHeight-height + 34, ScreenWidth, height + 13);
    }
}


- (void) keyboardWasShown:(NSNotification *) notif{
    NSDictionary *info = [notif userInfo];
    NSValue *value = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    _keybordHeight =[value CGRectValue].size.height;
    if (_textFieldHeight == 31 || _textFieldHeight == 34) {
        _toolBar.frame = CGRectMake(0,  ScreenHeight - StatusBarHeight - NavigationHeight-_keybordHeight, ScreenWidth, NavigationHeight)  ;
        _toolBar.image = [UIImage imageNamed:@"nav_bg"];
        
    }else
    {
        _textField.frame =CGRectMake(5, 5, 244, _textFieldHeight);
        _toolBar.frame = CGRectMake(0,  ScreenHeight - StatusBarHeight - NavigationHeight+34-_textFieldHeight - _keybordHeight, ScreenWidth, _textFieldHeight + 13);
        UIImage * firstImage = [UIImage imageNamed:@"nav_bg"];
        UIImage* currentImage = [firstImage stretchableImageWithLeftCapWidth:0 topCapHeight:30];
        _toolBar.image = currentImage;
    }
    
    
}

- (void) keyboardWasHidden:(NSNotification *) notif{
    _keybordHeight = 0;
    _textFieldHeight = 31;
    _textField.frame =CGRectMake(5, 5, 244, _textFieldHeight);
    NSString *string = [NSString stringWithString:_textField.text];
    self.suggestion = string;
    _textField.text = nil;
    _toolBar.frame = CGRectMake(0,  ScreenHeight - StatusBarHeight - NavigationHeight, ScreenWidth, NavigationHeight);
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.01];
	[UIView setAnimationDelegate:self];
    _toolBar.frame = CGRectMake(0, ScreenHeight - StatusBarHeight - NavigationHeight, ScreenWidth, NavigationHeight);
	[UIView commitAnimations];
    [_textField resignFirstResponder];
}



- (void)configureNavigationView
{
    [super configureNavigationView];
    [self.headerImageView setImage:[UIImage imageNamed:@"title_bght"]];
    
    [self.leftBtn setBackgroundImage:[UIImage imageNamed:@"title_btn_return_nomal"] forState:UIControlStateNormal];
    [self.leftBtn setBackgroundImage:[UIImage imageNamed:@"title_btn_return_pressed"] forState:UIControlStateHighlighted];
    [self.leftBtn setBackgroundImage:[UIImage imageNamed:@"title_btn_return_pressed"] forState:UIControlStateSelected];
}

- (void)onLeftBtn:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)onRightBtn:(id)sender
{
    
}


- (void)configureTableView{
    
    PullingRefreshTableView* tmpTable = [[PullingRefreshTableView alloc]initWithFrame:CGRectMake(0, NavigationHeight +StatusHeaderHight , ScreenWidth,ScreenHeight - StatusBarHeight - NavigationHeight - NavigationHeight -StatusHeaderHight)];
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
    self.suggestion = nil;
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
    SpinningCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [[[SpinningCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier]autorelease];
    }
    
    if (self.arrayCurrent) {
        if ([self.arrayCurrent count]) {
            CommentModel *model = [self.arrayCurrent objectAtIndex:indexPath.row];
            [cell.titleLabel setText:model.username];
            [cell.cxtLabel setText:model.content];
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
    CommentHttpCmd *cmd = [[[CommentHttpCmd alloc]init]autorelease];
    self.httpCmd = cmd;
    cmd.mid = self.mid;
    cmd.commentid = self.cursor;
    cmd.delegate = self;
    NSLog(@"%@",[RbUser sharedInstance].userid);
    cmd.userId = [RbUser sharedInstance].userid;
    [client onPostCmdAsync:self.httpCmd];
}

- (void)onRemarkData
{
    RbHttpClient *client = [RbHttpClient sharedInstance];
    RemarkHttpCmd *cmd = [[[RemarkHttpCmd alloc]init]autorelease];
    self.remarkCmd = cmd;
    cmd.mid = self.mid;
    NSLog(@"%@",self.textField.text);
    cmd.suggestion = self.suggestion;
    cmd.delegate = self;
    NSLog(@"%@",[RbUser sharedInstance].userid);
    cmd.userId = [RbUser sharedInstance].userid;
    [client onPostCmdAsync:self.remarkCmd];
}

#pragma mark -
#pragma mark httpDelegate -----------
- (void) httpResult:(id)cmd  error:(NSError*)error
{
    if ([cmd isMemberOfClass:[CommentHttpCmd class]]) {
        NSLog(@"111");
    CommentHttpCmd *httpcmd = (CommentHttpCmd *)cmd;
    [self.view makeToast:[httpcmd.errorDict objectForKey:kSpinningHttpKeyMsg]];
    NSMutableArray *array = [NSMutableArray arrayWithArray:httpcmd.lists];
    if ([self.cursor isEqualToString:@"0"]) {
        self.arrayCurrent = array;
    }else
    {
        [self.arrayCurrent addObjectsFromArray:array];
    }
    if ([self.arrayCurrent count]) {
        CommentModel *model = [self.arrayCurrent lastObject];
        if (model.commentid) {
            self.cursor = model.commentid;
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
    }else
    {
        self.cursor = [NSString stringWithFormat:@"0"];
        [self onGetData];
        RemarkHttpCmd *httpcmd = (RemarkHttpCmd *)cmd;
        [self.view makeToast:[httpcmd.errorDict objectForKey:kSpinningHttpKeyMsg]];
    }
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
    RbSafeRelease(_suggestion);
    RbSafeRelease(_textField);
    RbSafeRelease(_toolBar);
    RbSafeRelease(_mid);
    RbSafeRelease(_cursor);
    RbSafeRelease(_httpCmd);
    RbSafeRelease(_tableView);
    RbSafeRelease(_arrayCurrent);
    RbSuperDealoc;
}


@end
