//
//  ReadModel.m
//  Spinning
//
//  Created by Robin on 9/26/13.
//  Copyright (c) 2013 Robin. All rights reserved.
//

#import "ReadModel.h"
#import "LKDBHelper.h"
#import "NSObject+LKDBHelper.h"

@implementation ReadModel
@synthesize mid = _mid;
- (id)init
{
    if (self = [super init]) {
        self.mid = nil;
    }
    return self;
}

+(void)dbWillInsert:(NSObject *)entity
{
    LKLog(@"will insert : %@",NSStringFromClass(self));
}

+(void)dbDidInserted:(NSObject *)entity result:(BOOL)result
{
    LKLog(@"did insert : %@",NSStringFromClass(self));
}


+(NSString *)getPrimaryKey
{
    return @"mid";
}

+(NSString *)getTableName
{
    return @"ReadModel";
}

+(int)getTableVersion
{
    return 3;
}

- (void)dealloc
{
    RbSafeRelease(_mid);
    RbSuperDealoc;
}
@end
