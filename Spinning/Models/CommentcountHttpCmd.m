//
//  CommentcountHttpCmd.m
//  Spinning
//
//  Created by Robin on 10/4/13.
//  Copyright (c) 2013 Robin. All rights reserved.
//

#import "CommentcountHttpCmd.h"
@implementation CommentcountModel
@synthesize count = _count;
@synthesize mid = _mid;

- (id)init
{
    if (self = [super init]) {
        self.mid = nil;
        self.count = nil;
    }
    return self;
}


- (void) parseResultData:(NSDictionary*) dictionary{
    
    if (dictionary == nil) {
        return;
    }
    [super parseResultData:dictionary];
    self.count = defaultEmptyString([dictionary objectForKey:kSpinningHttpKeyCount]);
    
}


+(void)dbWillInsert:(NSObject *)entity
{
    LKLog(@"will insert : %@",NSStringFromClass(self));
}

+(void)dbDidInserted:(NSObject *)entity result:(BOOL)result
{
    LKLog(@"did insert : %@",NSStringFromClass(self));
}


+(void)columeAttributeWithProperty:(LKDBProperty *)property
{
}


+(NSString *)getPrimaryKey
{
    return @"mid";
}
+(NSArray *)getPrimaryKeyUnionArray
{
    return @[@"mid"];
}

+(NSString *)getTableName
{
    return NSStringFromClass([self class]);
}

+(int)getTableVersion
{
    return 3;
}

- (void)dealloc
{
    RbSafeRelease(_count);
    RbSuperDealoc;
}

@end
@implementation CommentcountHttpCmd

-(id)init{
    self = [super init];
    if (self) {
    }
    return self;
}

- (NSString*)onSuffixUrl
{
    return kSpinningGetCommentcount;
}

- (NSMutableDictionary *)paramDict
{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    self.userId = [RbUser sharedInstance].userid;
    if (self.userId) {
        [dic setObject:self.userId forKey:kSpinningHttpRequestKeyUserid];
    }
    return dic;
}

- (void) parseResultData:(NSDictionary*) dictionary{
    
    if (dictionary == nil) {
        return;
    }
    
    NSArray *array = defaultNilObject([dictionary objectForKey:kSpinningHttpKeyList]);
    
    if (array) {
        for (NSDictionary *dic in array) {
            ListModel *model = [[CommentcountModel alloc]init];
            [model parseResultData:dic];
            [self.lists addObject:model];
            RbSafeRelease(model);
        }
    }
}

- (void)dealloc
{
    RbSuperDealoc;
}

@end
