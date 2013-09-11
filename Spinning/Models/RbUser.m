//
//  RbUser.m
//  Spinning
//
//  Created by Robin on 7/28/13.
//  Copyright (c) 2013 Robin. All rights reserved.
//

#import "RbUser.h"

@implementation RbUser

+(RbUser *)sharedInstance {
    
    static RbUser *sharedInstance = nil;
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

- (void) parseResultData:(NSDictionary*) dictionary{
    
}

- (void)dealloc
{
    RbSuperDealoc;
}


@end
