//
//  AppDelegate.m
//  Spinning
//
//  Created by Robin on 7/27/13.
//  Copyright (c) 2013 Robin. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate
@synthesize tabBarController = _tabBarController;
- (void)dealloc
{
    
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

@end
