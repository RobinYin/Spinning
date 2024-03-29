//
//  CheckActionViewController.m
//  Spinning
//
//  Created by Robin on 8/30/13.
//  Copyright (c) 2013 Robin. All rights reserved.
//

#import "CheckActionViewController.h"
#import "RbEditCell.h"
#import "UITableView+RbEditTextTableView.h"
#import "CheckinHttpCmd.h"
#import "CheckDetailViewController.h"

enum {  kCheckinNameRow = 0,kCheckinPositionRow, kCheckinCompanyRow, kCheckinAddressRow, kCheckinPhoneRow,kCheckinEmailRow};
@interface CheckActionViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,RbHttpDelegate>
@property (nonatomic, retain)UITableView *tableView;
@property (nonatomic, retain)NSMutableArray *arrayCurrent;
@property (nonatomic, retain)NSMutableArray *userArray;
@property (nonatomic, retain)RbHttpCmd *httpCmd;

@property (nonatomic, retain) NSString *realname;
@property (nonatomic, retain) NSString *address;
@property (nonatomic, retain) NSString *email;
@property (nonatomic, retain) NSString *company;
@property (nonatomic, retain) NSString *position;
@property (nonatomic, retain) NSString *usercell;
@property (nonatomic, assign) int curIndex;
@end

@implementation CheckActionViewController

@synthesize tableView = _tableView;
@synthesize arrayCurrent = _arrayCurrent;
@synthesize userArray = _userArray;
@synthesize meetingcode = _meetingcode;
@synthesize httpCmd = _httpCmd;

@synthesize realname = _realname;
@synthesize address = _address;
@synthesize email = _email;
@synthesize company = _company;
@synthesize position = _position;
@synthesize usercell = _usercell;
@synthesize curIndex = _curIndex;

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
//    [self configureOriginData];
//    [self configureAllViews];
//    [self onGetData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureOriginData];
    [self configureAllViews];
    [self onGetData];
	// Do any additional setup after loading the view.
}

- (void)onLeftBtn:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)onRightBtn:(id)sender
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    [self.headerImageView setImage:[UIImage imageNamed:@"title_bggd"]];
    [self.leftBtn setBackgroundImage:[UIImage imageNamed:@"title_btn_return_nomal"] forState:UIControlStateNormal];
    [self.leftBtn setBackgroundImage:[UIImage imageNamed:@"title_btn_return_pressed"] forState:UIControlStateHighlighted];
    [self.leftBtn setBackgroundImage:[UIImage imageNamed:@"title_btn_return_pressed"] forState:UIControlStateSelected];
    
    
    [self.rightBtn setBackgroundImage:[UIImage imageNamed:@"nav_left_btn.png"] forState:UIControlStateNormal];
    [self.rightBtn setBackgroundImage:[UIImage imageNamed:@"nav_left_btn_sel.png"] forState:UIControlStateHighlighted];
    [self.rightBtn setBackgroundImage:[UIImage imageNamed:@"nav_left_btn_sel.png"] forState:UIControlStateSelected];
}

- (void)configureTableView{
    
    UITableView* tmpTable = [[UITableView alloc]initWithFrame:CGRectMake(0, NavigationHeight+ StatusHeaderHight, ScreenWidth,ScreenHeight - StatusBarHeight - NavigationHeight -StatusHeaderHight) style:UITableViewStyleGrouped];
    tmpTable.separatorColor = [UIColor grayColor];
    tmpTable.delegate = self;
    tmpTable.dataSource = self;
    tmpTable.backgroundColor = [UIColor clearColor];
    UIImageView *imageView = [[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"news_bg"]]autorelease];
    [tmpTable setBackgroundView:imageView];
    [self.view addSubview:tmpTable];
    self.tableView = tmpTable;
    RbSafeRelease(tmpTable);
    
    [[self tableView] beginWatchingForKeyboardStateChanges];
    
}

- (void)onGetData
{
    NSMutableArray *array = [NSMutableArray arrayWithArray:[self onRegisterListJson]];
    self.arrayCurrent = array;
    
    
    NSMutableArray *subArray = [NSMutableArray arrayWithObjects:[RbUser sharedInstance].realname,[RbUser sharedInstance].position,[RbUser sharedInstance].company,[RbUser sharedInstance].address,[RbUser sharedInstance].usercell,[RbUser sharedInstance].email, nil];
    self.userArray = subArray;
    
    self.realname =[RbUser sharedInstance].realname;
    self.position =[RbUser sharedInstance].position;
    self.company =[RbUser sharedInstance].company;
    self.address =[RbUser sharedInstance].address;
    self.usercell =[RbUser sharedInstance].usercell;
    self.email =[RbUser sharedInstance].email;
    [self.tableView reloadData];
}
- (void)configureOriginData
{
    NSMutableArray *subArray = [NSMutableArray array];
    self.arrayCurrent = subArray;
    
    NSMutableArray *array = [NSMutableArray array];
    self.userArray = array;
    
    _curIndex = -1;
}


- (NSMutableArray *)onRegisterListJson{
    
    NSString* path = [[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"CheckactionListTemplate"] ofType:@"json"];
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

- (void)onCheckinData
{
    RbHttpClient *client = [RbHttpClient sharedInstance];
    CheckinHttpCmd *cmd = [[[CheckinHttpCmd alloc]init]autorelease];
    self.httpCmd = cmd;
    cmd.meetingcode = self.meetingcode;
    if (self.realname) {
        cmd.realname = self.realname;
    }else
    {
        cmd.realname = [RbUser sharedInstance].realname;
    }
    if (self.address) {
        cmd.address = self.address;
    }else
    {
        cmd.address = [RbUser sharedInstance].address;
    }
    if (self.email) {
        cmd.email = self.email;
    }else
    {
        cmd.email = [RbUser sharedInstance].email;
    }
    if (self.company) {
        cmd.company = self.company;
    }else
    {
        cmd.company = [RbUser sharedInstance].company;
    }
    if (self.position) {
        cmd.position = self.position;
    }else
    {
        cmd.position = [RbUser sharedInstance].position;
    }
    if (self.usercell) {
        cmd.usercell = self.usercell;
    }else
    {
        cmd.usercell = [RbUser sharedInstance].usercell;
    }
    cmd.delegate = self;
    [client onPostCmdAsync:self.httpCmd];
}


- (void) httpResult:(id)cmd  error:(NSError*)error
{
    NSLog(@"%@",NSStringFromClass([cmd class]));
    NSString *msg = nil;
    CheckinHttpCmd *httpcmd = (CheckinHttpCmd *)cmd;
    if (error) {
        msg = [NSString stringWithFormat:@"网络错误"];
    }else
    {
        msg = httpcmd.model.msg;
        RbUser *user = [RbUser sharedInstance];
        user.realname = httpcmd.realname;
        user.address = httpcmd.address;
        user.email = httpcmd.email;
        user.company = httpcmd.company;
        user.position = httpcmd.position;
        user.usercell = httpcmd.usercell;
        [user save];
    }
    if ([httpcmd.model.msg isEqualToString:kSpinningHttpValueOk]) {

//        RbUser *user = [RbUser sharedInstance];
//        user.realname = httpcmd.realname;
//        user.address = httpcmd.address;
//        user.email = httpcmd.email;
//        user.company = httpcmd.company;
//        user.position = httpcmd.position;
//        user.usercell = httpcmd.usercell;
//        [user save];

        CheckinModel *model = (CheckinModel *)httpcmd.model;
        CheckDetailViewController *viewController = [[CheckDetailViewController new]autorelease];
        viewController.name = model.name;
        viewController.code = model.code;
        viewController.sponsor = model.sponsor;
        viewController.description = model.description;
        viewController.address = model.address;
        viewController.date = model.date;
        [self.navigationController pushViewController:viewController animated:YES];
    }else
    {
        [[self tableView]reloadData];
        [YRDropdownView showDropdownInView:self.view
                                     title:@"提示！"
                                    detail:[NSString stringWithFormat:@"%@!",msg]
                                     image:[UIImage imageNamed:@"dropdown-alert"]
                                  animated:YES
                                 hideAfter:TipTime];
    }
}


#pragma mark -
#pragma mark tableView Datasource -----------

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.arrayCurrent count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"CellIdentifier";
    RbEditCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [[[RbEditCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier]autorelease];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell.textLabel setTextColor:[UIColor blackColor]];
        [cell.textLabel setFont:[UIFont systemFontOfSize:15]];
    }
    if ([self.arrayCurrent count]) {
        cell.textLabel.text = [[self.arrayCurrent objectAtIndex:indexPath.row] objectForKey:kSpinningHttpKeyTitle];
        cell.textField.placeholder = [[self.arrayCurrent objectAtIndex:indexPath.row] objectForKey:kSpinningHttpKeyMsg];
        
        if ([self.userArray count]) {
        cell.textField.text = [self.userArray objectAtIndex:indexPath.row];
        }
    }
    cell.textField.delegate = self;
    if (indexPath.row == [self.arrayCurrent count] -1) {
        cell.textField.returnKeyType = UIReturnKeyDone;
    }else
    {
        cell.textField.returnKeyType = UIReturnKeyNext;
    }
    [cell.textField setFont:[UIFont systemFontOfSize:15]];
    cell.textField.keyboardType = UIKeyboardTypeEmailAddress;
    cell.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    cell.textField.autocorrectionType = UITextAutocorrectionTypeNo;
    
//    if (_curIndex !=-1) {
        switch (indexPath.row) {
            case 0:
            {
                [cell.textField setText:self.realname];
            }
                break;
            case 1:
            {
                [cell.textField setText:self.position];
            }
                break;
            case 2:
            {
                [cell.textField setText:self.company];
            }
                break;
            case 3:
            {
                [cell.textField setText:self.address];
            }
                break;
            case 4:
            {
                [cell.textField setText:self.usercell];
            }
                break;
            case 5:
            {
                [cell.textField setText:self.email];
            }
                break;
                
            default:
                break;
        }

//    }
//
    [cell groundToCellInTableView:tableView atIndexPath:indexPath];
    return cell;
}

#pragma mark -
#pragma mark tableView Delegate -----------

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath: indexPath animated: YES];
	[[self tableView] makeFirstResponderForIndexPath: indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return BindCellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 54;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *tmpView = [[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 44)]autorelease];
    [tmpView setBackgroundColor:[UIColor clearColor]];
    
    UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextBtn setFrame:CGRectMake(92.25, 13.5, 135.5, 27)];
    [nextBtn setBackgroundImage:[UIImage imageNamed:@"btn_normal"] forState:UIControlStateNormal];
    [nextBtn setTitle:@"签到" forState:UIControlStateNormal];
    [nextBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [nextBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [nextBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -30, 0, 0)];
    [nextBtn addTarget:self action:@selector(next:) forControlEvents:UIControlEventTouchUpInside];
    [tmpView addSubview:nextBtn];
    
    return tmpView;
}

- (void)next:(id)sender
{
    for (UIView *view in [[self tableView]subviews]){
        if (([[[UIDevice currentDevice] systemVersion] floatValue] < 7) ) {
            if ([view isKindOfClass:[RbEditCell class]]) {
                RbEditCell *cell = (RbEditCell *)view;
                [cell.textField resignFirstResponder];
            }
        }else
        {
            for (UIView *subView in [view subviews])
            {
                if ([subView isKindOfClass:[RbEditCell class]]) {
                    RbEditCell *subcell = (RbEditCell *)subView;
                    [subcell.textField resignFirstResponder];
                }
            }
        }
        
    }
    [self onCheckinData];
}


#pragma mark-
#pragma mark UITextFieldDelegate -----------
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSIndexPath *indexPath = [[self tableView] indexPathForFirstResponder];
    
    NSLog(@"%d",indexPath.row);
    
    if( [indexPath row] == kCheckinNameRow )
	{
        _curIndex =kCheckinNameRow;
        //		self.realname = text;
	}
	else if( [indexPath row] == kCheckinPositionRow )
	{
        _curIndex = kCheckinPositionRow;
        //		self.position = text;
	}
    else if( [indexPath row] == kCheckinCompanyRow )
	{
        _curIndex =kCheckinCompanyRow;
        //		self.company = text;
	}
    else if( [indexPath row] == kCheckinAddressRow )
	{
        _curIndex =kCheckinAddressRow;
        //		self.address = text;
	}
    else if( [indexPath row] == kCheckinPhoneRow )
	{
        _curIndex =kCheckinPhoneRow;
        //		self.usercell = text;
	}
    else if( [indexPath row] == kCheckinEmailRow )
	{
        _curIndex =kCheckinEmailRow;
        //		self.email = text;
	}

}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSString *text = [textField text];
    if( _curIndex == kCheckinNameRow )
	{
		self.realname = text;
	}
	else if( _curIndex == kCheckinPositionRow )
	{
		self.position = text;
	}
    else if( _curIndex == kCheckinCompanyRow )
	{
		self.company = text;
	}
    else if( _curIndex == kCheckinAddressRow )
	{
		self.address = text;
	}
    else if( _curIndex == kCheckinPhoneRow )
	{
		self.usercell = text;
	}
    else if( _curIndex == kCheckinEmailRow )
	{
		self.email = text;
	}
}
-(BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
	return YES;
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    if (textField.returnKeyType == UIReturnKeyDone ) {
        [textField resignFirstResponder];
        [self onCheckinData];
    }else
    {
        [[self tableView] makeNextCellWithTextFieldFirstResponder];
    }
	return YES;
}

- (void)dealloc
{
    [[self tableView]endWatchingForKeyboardStateChanges];
    RbSafeRelease(_tableView);
    RbSafeRelease(_arrayCurrent);
    RbSafeRelease(_httpCmd);
    RbSafeRelease(_realname);
    RbSafeRelease(_address);
    RbSafeRelease(_email);
    RbSafeRelease(_company);
    RbSafeRelease(_position);
    RbSafeRelease(_usercell);
    RbSafeRelease(_meetingcode);
    RbSuperDealoc;
}

@end
