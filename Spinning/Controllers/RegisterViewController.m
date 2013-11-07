//
//  RegisterViewController.m
//  Spinning
//
//  Created by Robin on 9/15/13.
//  Copyright (c) 2013 Robin. All rights reserved.
//

#import "RegisterViewController.h"
#import "RbEditCell.h"
#import "UITableView+RbEditTextTableView.h"
#import "RegisterHttpCmd.h"

enum { kAccountRow=0, kPasswordRow, kNameRow,kPositionRow, kCompanyRow, kAddressRow, kPhoneRow,kEmailRow};

@interface RegisterViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,RbHttpDelegate>
@property (nonatomic, retain)UITableView *tableView;
@property (nonatomic, retain)NSMutableArray *arrayCurrent;
@property (nonatomic, retain)RbHttpCmd *httpCmd;

@property (nonatomic, retain) NSString *username;
@property (nonatomic, retain) NSString *password;
@property (nonatomic, retain) NSString *realname;
@property (nonatomic, retain) NSString *address;
@property (nonatomic, retain) NSString *email;
@property (nonatomic, retain) NSString *company;
@property (nonatomic, retain) NSString *position;
@property (nonatomic, retain) NSString *usercell;

@property (nonatomic, assign) int curIndex;

@end

@implementation RegisterViewController
@synthesize httpCmd = _httpCmd;
@synthesize tableView = _tableView;
@synthesize arrayCurrent = _arrayCurrent;
@synthesize username = _username;
@synthesize password = _password;
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
    
    UITableView* tmpTable = [[UITableView alloc]initWithFrame:CGRectMake(0, NavigationHeight + StatusHeaderHight , ScreenWidth,ScreenHeight - StatusBarHeight - NavigationHeight - StatusHeaderHight) style:UITableViewStyleGrouped];
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
    [self.tableView reloadData];
}
- (void)configureOriginData
{
    NSMutableArray *subArray = [NSMutableArray array];
    self.arrayCurrent = subArray;
    
    _curIndex = -1;
}


- (NSMutableArray *)onRegisterListJson{
    
    NSString* path = [[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"RegisterListTemplate"] ofType:@"json"];
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
        if (indexPath.row ==1) {
            [cell.textField setSecureTextEntry:YES];
        }else
        {
            [cell.textField setSecureTextEntry:NO];
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
    
    switch (indexPath.row) {
        case 0:
        {
            [cell.textField setText:self.username];
        }
            break;
        case 1:
        {
            [cell.textField setText:self.password];
        }
            break;
        case 2:
        {
            [cell.textField setText:self.realname];
        }
            break;
        case 3:
        {
            [cell.textField setText:self.position];
        }
            break;
        case 4:
        {
            [cell.textField setText:self.company];
        }
            break;
        case 5:
        {
            [cell.textField setText:self.address];
        }
            break;
        case 6:
        {
            [cell.textField setText:self.usercell];
        }
            break;
        case 7:
        {
            [cell.textField setText:self.email];
        }
            break;
            
        default:
            break;
    }

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
    [nextBtn setTitle:@"注册" forState:UIControlStateNormal];
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
                NSLog(@"%@",subView);
                if ([subView isKindOfClass:[RbEditCell class]]) {
                    RbEditCell *subcell = (RbEditCell *)subView;
                    [subcell.textField resignFirstResponder];
                }
            }
        }
        
    }
    if ([self canSignup]) {
        [self onRegisterData];
    }else
    {
        
        [YRDropdownView showDropdownInView:self.view
                                     title:@"提示！"
                                    detail:@"输入的注册信息不全！"
                                     image:[UIImage imageNamed:@"dropdown-alert"]
                                  animated:YES
                                 hideAfter:TipTime];
        
    }
}
#pragma mark-
#pragma mark UITextFieldDelegate -----------
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSIndexPath *indexPath = [[self tableView] indexPathForFirstResponder];
    
	if( [indexPath row] == kAccountRow )
	{
        _curIndex =kAccountRow;
	}
	else if( [indexPath row] == kPasswordRow )
	{
        _curIndex =kPasswordRow;
	}
	else if( [indexPath row] == kNameRow )
	{
        _curIndex =kNameRow;
	}
	else if( [indexPath row] == kPositionRow )
	{
        _curIndex =kPositionRow;
	}
    else if( [indexPath row] == kCompanyRow )
	{
        _curIndex =kCompanyRow;
	}
    else if( [indexPath row] == kAddressRow )
	{
        _curIndex =kAddressRow;
	}
    else if( [indexPath row] == kPhoneRow )
	{
        _curIndex =kPhoneRow;
	}
    else if( [indexPath row] == kEmailRow )
	{
        _curIndex =kEmailRow;
	}
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSString *text =[textField text];
	if( _curIndex == kAccountRow )
	{
        self.username = text;
	}
	else if( _curIndex == kPasswordRow )
	{
        self.password = text;
	}
	else if( _curIndex == kNameRow )
	{
        self.realname = text;
	}
	else if( _curIndex == kPositionRow )
	{
	    self.position = text;
	}
    else if( _curIndex == kCompanyRow )
	{
        self.company = text;
	}
    else if( _curIndex == kAddressRow )
	{
        self.address = text;
	}
    else if( _curIndex == kPhoneRow )
	{
            self.usercell = text;
	}
    else if( _curIndex == kEmailRow )
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
        if ([self canSignup]) {
            [self onRegisterData];
        }else
        {
            [YRDropdownView showDropdownInView:self.view
                                         title:@"提示！"
                                        detail:@"输入的注册信息不全！"
                                         image:[UIImage imageNamed:@"dropdown-alert"]
                                      animated:YES
                                     hideAfter:TipTime];
        }
    }else
    {
        [[self tableView] makeNextCellWithTextFieldFirstResponder];
    }
	return YES;
}

-(BOOL) canSignup
{
	return [[self username] length] && [[self password] length] && [[self realname] length] && [[self address] length]&& [[self email] length]&& [[self company] length]&& [[self position] length]&& [[self usercell] length];
}

- (void)onRegisterData
{
    RbHttpClient *client = [RbHttpClient sharedInstance];
    RegisterHttpCmd *cmd = [[[RegisterHttpCmd alloc]init]autorelease];
    self.httpCmd = cmd;
    cmd.username = self.username;
    cmd.password = md5(self.password);
    cmd.realname = self.realname;
    cmd.address = self.address;
    cmd.email = self.email;
    cmd.company = self.company;
    cmd.position = self.position;
    cmd.usercell = self.usercell;
    cmd.delegate = self;
    NSLog(@"%@",cmd);
    [client onPostCmdAsync:self.httpCmd];
}


- (void) httpResult:(id)cmd  error:(NSError*)error
{
    NSLog(@"%@",NSStringFromClass([cmd class]));
    NSString *msg = nil;
    RegisterHttpCmd *httpcmd = (RegisterHttpCmd *)cmd;
    if (error) {
        msg = [NSString stringWithFormat:@"网络错误"];
    }else
    {
        if ([httpcmd.model.code isEqualToString:kSpinningHttpKeyOk]) {
            [self.navigationController popViewControllerAnimated:YES];
            msg = [NSString stringWithFormat:@"您已经注册成功！"];
        }else
        {
            msg = httpcmd.model.msg;
        }
    }
    [YRDropdownView showDropdownInView: [msg isEqualToString:@"您已经注册成功！"] ?[UIApplication sharedApplication].delegate.window : self.view
                                 title:@"提示！"
                                detail:[NSString stringWithFormat:@"%@!",msg]
                                 image:[UIImage imageNamed:@"dropdown-alert"]
                              animated:YES
                             hideAfter:TipTime];
    
}

- (void)dealloc
{
    [[self tableView]endWatchingForKeyboardStateChanges];
    RbSafeRelease(_tableView);
    RbSafeRelease(_arrayCurrent);
    RbSafeRelease(_httpCmd);
    RbSafeRelease(_username);
    RbSafeRelease(_password);
    RbSafeRelease(_realname);
    RbSafeRelease(_address);
    RbSafeRelease(_email);
    RbSafeRelease(_company);
    RbSafeRelease(_position);
    RbSafeRelease(_usercell);
    RbSuperDealoc;
}

@end
