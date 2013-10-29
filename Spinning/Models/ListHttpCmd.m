//
//  ListHttpCmd.m
//  Spinning
//
//  Created by Robin on 9/1/13.
//  Copyright (c) 2013 Robin. All rights reserved.
//

#import "ListHttpCmd.h"
#import "LKDBHelper.h"
#import "NSObject+LKDBHelper.h"
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
    if([property.sqlColumeName isEqualToString:@"totalcount"])
    {
        property.defaultValue = @"0";
    }
}


+(NSString *)getPrimaryKey
{
    return @"mid";
}
+(NSArray *)getPrimaryKeyUnionArray
{
    return @[@"mid",@"time"];
}

+(NSString *)getTableName
{
    return @"ListModel";
}

+(int)getTableVersion
{
    return 3;
}

- (void) parseResultData:(NSDictionary*) dictionary{
    
    if (dictionary == nil) {
        return;
    }
    
    NSLog(@"%@",dictionary);
    
    self.time = defaultEmptyString([dictionary objectForKey:kSpinningHttpKeyTime]);
    self.title = defaultEmptyString([dictionary objectForKey:kSpinningHttpKeyTitle]);
    self.source = defaultEmptyString([dictionary objectForKey:kSpinningHttpKeySource]);
    self.icon = defaultEmptyString([dictionary objectForKey:kSpinningHttpKeyIcon]);
    self.content = defaultEmptyString([dictionary objectForKey:kSpinningHttpKeyContent]);
    
    if (self.content) {
        self.content = [self.content stringByReplacingOccurrencesOfString:@"&quot;" withString:@""];
        self.content = [self.content stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        self.content = [self filterHtmlTag:self.content];
    }
    
    self.mid = defaultEmptyString([dictionary objectForKey:kSpinningHttpKeyId]);
    self.articleurl = defaultEmptyString([dictionary objectForKey:kSpinningHttpKeyArticleurl]);
    self.totalcount = defaultEmptyString([dictionary objectForKey:kSpinningHttpKeyTotalcount]);
    
}

- (NSString *)filterHtmlTag:(NSString *)originHtmlStr{
    NSString *result = nil;
    NSRange arrowTagStartRange = [originHtmlStr rangeOfString:@"["];
    if (arrowTagStartRange.location != NSNotFound) {
        NSRange arrowTagEndRange = [originHtmlStr rangeOfString:@"]"];
        result = [originHtmlStr stringByReplacingCharactersInRange:NSMakeRange(arrowTagStartRange.location, arrowTagEndRange.location - arrowTagStartRange.location + 1) withString:@""];
        return [self filterHtmlTag:result];
    }else{
        result = [originHtmlStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        result = [originHtmlStr stringByReplacingOccurrencesOfString:@"&quot;" withString:@""];;
        result = [originHtmlStr stringByReplacingOccurrencesOfString:@"—" withString:@""];;
    }
    return result;
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
