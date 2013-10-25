//
//  AppDelegate.m
//  Spinning
//
//  Created by Robin on 7/27/13.
//  Copyright (c) 2013 Robin. All rights reserved.
//

#import "AppDelegate.h"
#import "NewsHttpCmd.h"

#import "NewsReadModel0.h"
#import "NewsReadModel1.h"
#import "NewsReadModel2.h"
#import "NewsReadModel3.h"
#import "NewsReadModel4.h"
#import "NewsReadModel5.h"
#import "NewsReadModel6.h"
#import "NewsReadModel7.h"
#import "PHReadModel.h"
#import "TopicReadModel.h"
#import "NotifyReadModel.h"


@implementation AppDelegate

@synthesize tabBarController = _tabBarController;
@synthesize httpCmd = _httpCmd;
@synthesize timer = _timer;
@synthesize countHttpCmd = _countHttpCmd;
- (void)dealloc
{
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
    RbSafeRelease(_countHttpCmd);
    RbSafeRelease(_httpCmd);
    RbSafeRelease(_tabBarController);
    RbSafeRelease(_window);
    RbSuperDealoc;
    
}


- (void)configureTabBarController
{
    
    NSMutableArray *tabBarItemsArray = [NSMutableArray new];
    for (int i = 0; i<5; i++) {
        
        //Set Up ABTabBarItem
        UIImage *defaultTabImage = [UIImage imageNamed:[NSString stringWithFormat:@"tab_%d_normal.png",i]];
        UIImage *selectedTabImage = [UIImage imageNamed:[NSString stringWithFormat:@"tab_%d_pressed.png",i]];
        RbTabBarItem *tabBarItem = [[RbTabBarItem alloc] initWithImage:defaultTabImage selectedImage:selectedTabImage];
        [tabBarItemsArray addObject:tabBarItem];
        [tabBarItem release];
    }
    
    NewsViewController *newsViewController = [NewsViewController new];
    TopicViewController *topicViewController = [TopicViewController new];
    NotificationViewController *notificationViewController = [NotificationViewController new];
    PHViewController *phViewController = [PHViewController new];
    MoreViewController *moreViewController = [MoreViewController new];

    UINavigationController *newsNavigationController = [[UINavigationController alloc]initWithRootViewController:newsViewController];
    UINavigationController *topicNavigationController = [[UINavigationController alloc]initWithRootViewController:topicViewController];
    UINavigationController *notificationNavigationController = [[UINavigationController alloc]initWithRootViewController:notificationViewController];
    UINavigationController *phNavigationController = [[UINavigationController alloc]initWithRootViewController:phViewController];
    UINavigationController *moreNavigationController = [[UINavigationController alloc]initWithRootViewController:moreViewController];

    RbTabBarViewController *tmpTabBarController = [RbTabBarViewController new];
    self.tabBarController = tmpTabBarController;
    tmpTabBarController.viewControllers = [NSArray arrayWithObjects:newsNavigationController,topicNavigationController,phNavigationController,notificationNavigationController,moreNavigationController,nil];
    [tmpTabBarController addTabItems:tabBarItemsArray backgroundImage:[UIImage imageNamed:@"tab_bg"]];
    
    RbSafeRelease(newsViewController);
    RbSafeRelease(topicViewController);
    RbSafeRelease(notificationViewController);
    RbSafeRelease(phViewController);
    RbSafeRelease(moreViewController);

    RbSafeRelease(newsNavigationController);
    RbSafeRelease(topicNavigationController);
    RbSafeRelease(notificationNavigationController);
    RbSafeRelease(phNavigationController);
    RbSafeRelease(moreNavigationController);
    
    self.window.rootViewController = tmpTabBarController;
    RbSafeRelease(tmpTabBarController);
    
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    [self configureTabBarController];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    [self onGetData];
    [self database];
    [self handleInfo];
    [self umeng];
    [self guide];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
#pragma mark -
#pragma mark database-----------

- (void)database
{
    LKDBHelper* globalHelper = [LKDBHelper getUsingLKDBHelper];
    [globalHelper createTableWithModelClass:[ListModel class]];
    [globalHelper createTableWithModelClass:[NewsReadModel0 class]];
    [globalHelper createTableWithModelClass:[NewsReadModel1 class]];
    [globalHelper createTableWithModelClass:[NewsReadModel2 class]];
    [globalHelper createTableWithModelClass:[NewsReadModel3 class]];
    [globalHelper createTableWithModelClass:[NewsReadModel4 class]];
    [globalHelper createTableWithModelClass:[NewsReadModel5 class]];
    [globalHelper createTableWithModelClass:[NewsReadModel6 class]];
    [globalHelper createTableWithModelClass:[NewsReadModel7 class]];
    [globalHelper createTableWithModelClass:[PHReadModel class]];
    [globalHelper createTableWithModelClass:[TopicReadModel class]];
    [globalHelper createTableWithModelClass:[NotifyReadModel class]];
}

#pragma mark -
#pragma mark datasource -----------

- (void)handleInfo
{
    _timer = [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(onGetData) userInfo:nil repeats:YES];
}
- (void)onGetData
{
    [InfoCountSingleton sharedInstance];
    RbHttpClient *client = [RbHttpClient sharedInstance];
    InfoCountHttpCmd *cmd = [[[InfoCountHttpCmd alloc]init]autorelease];
    self.httpCmd = cmd;
    cmd.noticeid = [InfoCountSingleton sharedInstance].notice;
    cmd.topicid = [InfoCountSingleton sharedInstance].topic;
    cmd.delegate = self;
    [client onPostCmdAsync:self.httpCmd];
    
    CommentcountHttpCmd *chm = [[[CommentcountHttpCmd alloc]init]autorelease];
    self.countHttpCmd = chm;
    chm.delegate = self;
    [client onPostCmdAsync:self.countHttpCmd];

}

#pragma mark -
#pragma mark httpDelegate -----------
- (void) httpResult:(id)cmd  error:(NSError*)error
{
    if ([cmd isMemberOfClass:[InfoCountHttpCmd class]]) {
        InfoCountHttpCmd *httpcmd = (InfoCountHttpCmd *)cmd;
        InfoCountModel *model = (InfoCountModel *)httpcmd.model;
        
        RbBadgeView *topic = (RbBadgeView *)[self.tabBarController.tabBarBadgesArray objectAtIndex:1];
        if (model.topic) {
            if ([model.topic intValue]) {
                [topic setBadgeString:model.topic];
            }else
            {
                [topic setBadgeString:@""];
            }
        }
        
        RbBadgeView *notice = (RbBadgeView *)[self.tabBarController.tabBarBadgesArray objectAtIndex:3];
        if (model.notice) {
            if ([model.notice intValue]) {
                [notice setBadgeString:model.notice];
            }else
            {
                [notice setBadgeString:@""];
            }
        }
         NSLog(@"%@  ---  %@",model.topic,model.notice);
    }
    if ([cmd isMemberOfClass:[CommentcountHttpCmd class]]) {
        CommentcountHttpCmd *httpcmd = (CommentcountHttpCmd *)cmd;
        NSMutableArray *array = [NSMutableArray arrayWithArray:httpcmd.lists];
        NSLog(@"%@",array);
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
     
}


#pragma mark -
#pragma mark UMeng -----------
- (void)umeng
{
    [UMSocialData setAppKey:UmengAppkey];
    [UMSocialConfig setWXAppId:@"wxd9a39c7122aa6516" url:nil];
    [UMSocialConfig setSupportSinaSSO:YES];
    
}

#pragma mark -
#pragma mark UMeng -----------

- (void)guide
{
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"guideLaunch"]) {
        [self showIntroWithCrossDissolve];
    }
}
- (void)introDidFinish {
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"guideLaunch"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)showIntroWithCrossDissolve {
//    EAIntroPage *page1 = [EAIntroPage page];
//    page1.title = @"掌观中国针织";
//    page1.desc = @"中国针织工业协会主办的唯一官方网站.";
//    page1.bgImage = [UIImage imageNamed:@"tutorial_background_00@2x.jpg"];
//    page1.titleImage = nil;
//    
//    EAIntroPage *page2 = [EAIntroPage page];
//    page2.title = @"我们的定位";
//    page2.desc = @"定位于打造专业、即时、客观、准确，具有公信力的协会网络服务平台.";
//    page2.bgImage = [UIImage imageNamed:@"tutorial_background_01@2x.jpg"];
//    page2.titleImage = nil;
//    
//    EAIntroPage *page3 = [EAIntroPage page];
//    page3.title = @"我们的视角";
//    page3.desc = @"紧密围绕针织行业，以新闻聚合、独家专访、热点话题讨论为特色逐步向移动互联延伸，成为针织人每日必读的行业网站.";
//    page3.bgImage = [UIImage imageNamed:@"tutorial_background_02@2x.jpg"];
//    page3.titleImage = nil;
//    
//    EAIntroPage *page4 = [EAIntroPage page];
//    page4.title = @"我们的目标";
//    page4.desc = @"兼具行业协会的网络服务功能，不断完善与会员的远程互动.";
//    page4.bgImage = [UIImage imageNamed:@"tutorial_background_03@2x.jpg"];
//    page4.titleImage = nil;
//    
//    EAIntroPage *page5 = [EAIntroPage page];
//    page5.title = @"Welcome!";
//    page5.desc = @"开始掌观中国针织之旅。";
//    page5.bgImage = [UIImage imageNamed:@"tutorial_background_04@2x.jpg"];
//    page5.titleImage = nil;
//    
//    
//    EAIntroView *intro = [[[EAIntroView alloc] initWithFrame:self.window.bounds andPages:@[page1,page2,page3,page4,page5]]autorelease];
    
    EAIntroPage *page1 = [EAIntroPage page];
    page1.title = nil;
    page1.desc = nil;
    page1.bgImage = [UIImage imageNamed:@"help001.png"];
    page1.titleImage = nil;
    
    EAIntroPage *page2 = [EAIntroPage page];
    page2.title = nil;
    page2.desc = nil;
    page2.bgImage = [UIImage imageNamed:@"help002.png"];
    page2.titleImage = nil;
    
    EAIntroPage *page3 = [EAIntroPage page];
    page3.title = nil;
    page3.desc = nil;
    page3.bgImage = [UIImage imageNamed:@"help003.png"];
    page3.titleImage = nil;
    
    
    
    EAIntroView *intro = [[[EAIntroView alloc] initWithFrame:CGRectMake(0, 20, ScreenWidth, ScreenHeight) andPages:@[page1,page2,page3]]autorelease];
    
    [intro setDelegate:self];
    [intro showInView:self.window animateDuration:0.0];
}


@end
