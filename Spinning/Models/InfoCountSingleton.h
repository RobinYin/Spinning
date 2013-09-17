//
//  InfoCountSingleton.h
//  Spinning
//
//  Created by Robin on 9/17/13.
//  Copyright (c) 2013 Robin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InfoCountSingleton : NSObject
@property (nonatomic, retain)NSString *notice;
@property (nonatomic, retain)NSString *topic;
+(InfoCountSingleton *)sharedInstance;
-(void)save;
@end
