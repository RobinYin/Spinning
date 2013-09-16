//
//  SharedHttpCmd.m
//  Spinning
//
//  Created by Robin on 9/14/13.
//  Copyright (c) 2013 Robin. All rights reserved.
//

#import "SharedHttpCmd.h"

@implementation SharedHttpCmd
+(SharedHttpCmd *)sharedInstance {
    
    static SharedHttpCmd *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (id)init
{
    if (self = [super init]) {
    }
    return self;
}

- (void)dealloc
{
    RbSuperDealoc;
}
@end
