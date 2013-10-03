//
//  AppDelegate.h
//  Spinning
//
//  Created by Robin on 7/27/13.
//  Copyright (c) 2013 Robin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InfoCountHttpCmd.h"
#import "InfoCountSingleton.h"
#import "EAIntroPage.h"
#import "EAIntroView.h"
#import "CommentcountHttpCmd.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,RbHttpDelegate,EAIntroDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, retain) InfoCountHttpCmd *httpCmd;
@property (nonatomic, strong) RbTabBarViewController *tabBarController;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, retain) CommentcountHttpCmd *countHttpCmd;
@end
