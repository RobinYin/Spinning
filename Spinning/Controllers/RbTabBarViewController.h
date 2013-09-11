//
//  RbTabBarViewController.h
//  Spinning
//
//  Created by Robin on 7/28/13.
//  Copyright (c) 2013 Robin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RbTabBarViewController : UITabBarController
@property (nonatomic, retain) NSMutableArray *tabBarItemArray;
@property (nonatomic, retain) NSMutableArray *buttonArray;
@property (nonatomic, retain) NSMutableArray *tabBarBadgesArray;
-(void)addTabItems:(NSArray*)tabBarItemsArray backgroundImage:(UIImage*)bgImage;
@end
