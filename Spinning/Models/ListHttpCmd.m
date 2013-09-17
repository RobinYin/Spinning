//
//  ListHttpCmd.m
//  Spinning
//
//  Created by Robin on 9/1/13.
//  Copyright (c) 2013 Robin. All rights reserved.
//

#import "ListHttpCmd.h"

@implementation ListModel

@synthesize title = _title;
@synthesize time = _time;
@synthesize icon = _icon;
@synthesize source = _source;
@synthesize content = _content;
@synthesize mid = _mid;
@synthesize articleurl = _articleurl;
@synthesize totalcount = _totalcount;

- (id)init
{
    if (self = [super init]) {
        self.time = nil;
        self.title = nil;
        self.mid = nil;
        self.source = nil;
        self.content = nil;
        self.icon = nil;
        self.articleurl = nil;
        self.totalcount = nil;
    }
    return self;
}

- (void) parseResultData:(NSDictionary*) dictionary{
    
    if (dictionary == nil) {
        return;
    }
    
    self.time = defaultEmptyString([dictionary objectForKey:kSpinningHttpKeyTime]);
    self.title = defaultEmptyString([dictionary objectForKey:kSpinningHttpKeyTitle]);
    self.source = defaultEmptyString([dictionary objectForKey:kSpinningHttpKeySource]);
    self.icon = defaultEmptyString([dictionary objectForKey:kSpinningHttpKeyIcon]);
    self.content = defaultEmptyString([dictionary objectForKey:kSpinningHttpKeyContent]);
    self.mid = defaultEmptyString([dictionary objectForKey:kSpinningHttpKeyId]);
    self.articleurl = defaultEmptyString([dictionary objectForKey:kSpinningHttpKeyArticleurl]);
    self.totalcount = defaultEmptyString([dictionary objectForKey:kSpinningHttpKeyTotalcount]);
    
}

- (void)dealloc
{
    RbSafeRelease(_totalcount);
    RbSafeRelease(_mid);
    RbSafeRelease(_source);
    RbSafeRelease(_icon);
    RbSafeRelease(_title);
    RbSafeRelease(_time);
    RbSafeRelease(_content);
    RbSafeRelease(_articleurl);
    RbSuperDealoc;
}


@end



@implementation ListHttpCmd
@synthesize cursor = _cursor;
@synthesize userId = _userId;
@synthesize lists = _lists;

- (id)init
{
    if (self = [super init]) {
        self.cursor = [NSString stringWithFormat:@"0"];
        self.userId = nil;
        self.lists = [NSMutableArray array];
    }
    return self;
}


- (void) parseResultData:(NSDictionary*) dictionary{
    
    if (dictionary == nil) {
        return;
    }
    
    NSArray *array = defaultNilObject([dictionary objectForKey:kSpinningHttpKeyList]);
    
    if (array) {
        for (NSDictionary *dic in array) {
            ListModel *model = [[ListModel alloc]init];
            [model parseResultData:dic];
            [self.lists addObject:model];
            RbSafeRelease(model);
        }
    }
}

- (void)dealloc
{
    
    RbSafeRelease(_lists);
    RbSafeRelease(_userId);
    RbSafeRelease(_cursor);
    RbSuperDealoc;
    
}
@end
