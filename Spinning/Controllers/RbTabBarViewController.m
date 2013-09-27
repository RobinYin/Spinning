//
//  RbTabBarViewController.m
//  Spinning
//
//  Created by Robin on 7/28/13.
//  Copyright (c) 2013 Robin. All rights reserved.
//

#import "RbTabBarViewController.h"

@interface RbTabBarViewController ()

@end

@implementation RbTabBarViewController
@synthesize tabBarItemArray=_tabBarItemArray, buttonArray=_buttonArray,tabBarBadgesArray = _tabBarBadgesArray;

- (void)dealloc
{
    RbSafeRelease(_tabBarBadgesArray);
    RbSafeRelease(_buttonArray);
    RbSafeRelease(_tabBarItemArray);
    RbSuperDealoc;
}

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
}


-(void)addTabItems:(NSArray*)tabBarItemsArray backgroundImage:(UIImage*)bgImage{
        UIImageView *imageView = [[[UIImageView alloc]initWithFrame:CGRectMake(0,  0, ScreenWidth, TabBarHeight)]autorelease];
        if (bgImage == nil) {
            imageView.backgroundColor = [UIColor blackColor];
        } else {
            imageView.backgroundColor = [UIColor colorWithPatternImage:bgImage];
        }
        [self.tabBar addSubview:imageView];
        //Load all tabBarItems into local Array
        NSMutableArray *array = [NSMutableArray arrayWithArray:tabBarItemsArray];
        self.tabBarItemArray= array;
        
        //Alocate Array to hold the UIButtons created from the ABTabBarItems
        self.buttonArray = [NSMutableArray array];
        
        [self createTabs];
        [self loadDefaultView];
}

-(void) createTabs {
    
    //Calculate Tab Width
    int tabCount = self.tabBarItemArray.count;
    float tabWidth = ScreenWidth / tabCount;
    
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:tabCount];
    self.tabBarBadgesArray = array;
    
    int tabCounter = 0;
    
    for (RbTabBarItem *aTabBarItem in self.tabBarItemArray) {
        float buttonXValue = tabWidth*tabCounter;
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = tabCounter;
        button.frame = CGRectMake(buttonXValue, 0, tabWidth, TabBarHeight);
        
        //Set Images for different States
        [button setBackgroundImage:aTabBarItem.image forState:UIControlStateNormal];
        [button setBackgroundImage:aTabBarItem.selectedImage forState:UIControlStateHighlighted];
        [button setBackgroundImage:aTabBarItem.selectedImage forState:UIControlStateSelected];
        
        //Keep button from "darkening out" when selected twice
        [button setAdjustsImageWhenHighlighted:NO];
        
        [button addTarget:self action:@selector(tabTouchedDown:) forControlEvents:UIControlEventTouchDown];
        [button addTarget:self action:@selector(tabTouchedUp:) forControlEvents:UIControlEventTouchUpInside];
        [self.buttonArray addObject:button];
        [self.tabBar addSubview:button];
        
        
        RbBadgeView *badgeView = [[RbBadgeView alloc] initWithFrame:CGRectMake(buttonXValue+ tabWidth -30, 0,20, 20)];
        [badgeView setBadgeString:@""];
        [self.tabBar addSubview:badgeView];
        [self.tabBarBadgesArray addObject:badgeView];
        [badgeView release];
        
        
        tabCounter += 1;
    }
    
}

-(void)tabTouchedDown:(UIButton*)touchedTab {
    [touchedTab setSelected:YES];
}

-(void) tabTouchedUp:(UIButton*)touchedTab {
    //Set All other tabs unselected
    for (UIButton *button in self.buttonArray) {
        [button setSelected:NO];
    }
    //Set touched tab selected
    [touchedTab setSelected:YES];
    self.selectedIndex = touchedTab.tag;
}

-(void) loadDefaultView {
    [self tabTouchedDown:[self.buttonArray objectAtIndex:0]];
    [self tabTouchedUp:[self.buttonArray objectAtIndex:0]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
