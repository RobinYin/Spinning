//
//  CommentHttpCmd.m
//  Spinning
//
//  Created by Robin on 9/16/13.
//  Copyright (c) 2013 Robin. All rights reserved.
//

#import "CommentHttpCmd.h"
@implementation CommentModel
@synthesize commentid = _commentid;
@synthesize username = _username;
@synthesize commentip = _commentip;
@synthesize content = _content;
@synthesize time = _time;
- (id)init
{
    if (self = [super init]) {
        self.time = nil;
        self.username = nil;
        self.commentip = nil;
        self.commentid = nil;
        self.content = nil;
    }
    return self;
}

- (void) parseResultData:(NSDictionary*) dictionary{
    
    if (dictionary == nil) {
        return;
    }
    
    self.time = defaultEmptyString([dictionary objectForKey:kSpinningHttpKeyTime]);
    self.username = defaultEmptyString([dictionary objectForKey:kSpinningHttpRequestKeyUsername]);
    self.commentip = defaultEmptyString([dictionary objectForKey:kSpinningHttpKeyCommentip]);
    self.commentid = defaultEmptyString([dictionary objectForKey:kSpinningHttpKeyCommentid]);
    self.content = defaultEmptyString([dictionary objectForKey:kSpinningHttpKeyContent]);
    
}

- (void)dealloc
{
    RbSafeRelease(_username);
    RbSafeRelease(_commentid);
    RbSafeRelease(_commentip);
    RbSafeRelease(_time);
    RbSafeRelease(_content);
    RbSuperDealoc;
}


@end

@implementation CommentHttpCmd
@synthesize userId = _userId;
@synthesize lists = _lists;
@synthesize commentid = _commentid;
@synthesize mid = _mid;

- (id)init
{
    if (self = [super init]) {
        self.userId = nil;
        self.lists = [NSMutableArray array];
        self.commentid = [NSString stringWithFormat:@"0"];
        self.mid = [NSString stringWithFormat:@"0"];
    }
    return self;
}

- (NSString*)onSuffixUrl
{
    return kSpinningGetCommentList;
}

- (NSMutableDictionary *)paramDict
{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if (self.userId) {
        [dic setObject:self.userId forKey:kSpinningHttpRequestKeyUserid];
    }
    [dic setObject:self.mid forKey:kSpinningHttpRequestKeyId];
    [dic setObject:self.commentid forKey:kSpinningHttpKeyCommentid];
    
    return dic;
}

- (void) parseResultData:(NSDictionary*) dictionary{
    
    if (dictionary == nil) {
        return;
    }
    
    NSArray *array = defaultNilObject([dictionary objectForKey:kSpinningHttpKeyList]);
    
    if (array) {
        for (NSDictionary *dic in array) {
            CommentModel *model = [[CommentModel alloc]init];
            [model parseResultData:dic];
            [self.lists addObject:model];
            RbSafeRelease(model);
        }
    }
}

- (void)dealloc
{
    RbSafeRelease(_mid);
    RbSafeRelease(_commentid);
    RbSafeRelease(_lists);
    RbSafeRelease(_userId);
    RbSuperDealoc;
    
}

@end
