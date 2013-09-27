//
//  BindViewController.m
//  Spinning
//
//  Created by Robin on 8/30/13.
//  Copyright (c) 2013 Robin. All rights reserved.
//

#import "BindViewController.h"
#import "RbEditCell.h"
#import "UITableView+RbEditTextTableView.h"

@interface BindViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
@property (nonatomic, retain)UITableView *tableView;
@property (nonatomic, retain)NSMutableArray *arrayCurrent;
@end

@implementation BindViewController
@synthesize tableView = _tableView;
@synthesize arrayCurrent = _arrayCurrent;

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
    
    UITableView* tmpTable = [[UITableView alloc]initWithFrame:CGRectMake(0, NavigationHeight + StatusHeaderHight , ScreenWidth,ScreenHeight - StatusBarHeight - NavigationHeight - TabBarHeight - StatusHeaderHight) style:UITableViewStyleGrouped];
    tmpTable.separatorColor = [UIColor grayColor];
    tmpTable.delegate = self;
    tmpTable.dataSource = self;
    tmpTable.backgroundColor = [UIColor clearColor];
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

#pragma mark-
#pragma mark UITextFieldDelegate -----------

-(BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
//	NSString *text = [[textField text] stringByReplacingCharactersInRange: range withString: string];
//	NSIndexPath *indexPath = [[self tableView] indexPathForFirstResponder];
	
//	if( [indexPath row] == kUsernameRow )
//	{
//		self.username = text;
//	}
//	else if( [indexPath row] == kAccountFirstNameRow )
//	{
//		self.firstName = text;
//	}
//	else if( [indexPath row] == kAccountLastNameRow )
//	{
//		self.lastName = text;
//	}
//	else if( [indexPath row] == kAccountPasswordRow )
//	{
//		self.password = text;
//	}
//	
//	[self setButtonStates];
	return YES;
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    if (textField.returnKeyType == UIReturnKeyDone ) {

    }else
    {
        [[self tableView] makeNextCellWithTextFieldFirstResponder];
    }
	return YES;
}



@end
