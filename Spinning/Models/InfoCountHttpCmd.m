//
//  InfoCountHttpCmd.m
//  Spinning
//
//  Created by Robin on 9/14/13.
//  Copyright (c) 2013 Robin. All rights reserved.
//

#import "InfoCountHttpCmd.h"

@implementation InfoCountModel
@synthesize notice = _notice;
@synthesize topic = _topic;

- (id)init
{
    if (self = [super init]) {
        self.notice = [NSString stringWithFormat:@"0"];
        self.topic = [NSString stringWithFormat:@"0"];
    }
    return self;
}

- (void) parseResultData:(NSDictionary*) dictionary{
    
    if (dictionary == nil) {
        return;
    }
    [super parseResultData:dictionary];
    self.topic = defaultEmptyString([dictionary objectForKey:kSpinningHttpKeyTopic]);
    self.notice = defaultEmptyString([dictionary objectForKey:kSpinningHttpKeyNotice]);
}

- (void)dealloc
{
    RbSuperDealoc;
}
@end

@implementation InfoCountHttpCmd

@synthesize noticeid = _noticeid;
@synthesize topicid = _topicid;

-(id)init{
    self = [super init];
    if (self) {
        self.noticeid = [NSString stringWithFormat:@"0"];
        self.topicid = [NSString stringWithFormat:@"0"];
    }
    return self;
}

- (NSString*)onSuffixUrl
{
    return kSpinningGetInfoCount;
}

- (NSMutableDictionary *)paramDict
{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if (self.userId) {
        [dic setObject:self.userId forKey:kSpinningHttpRequestKeyUserid];
    }
    [dic setObject:self.noticeid forKey:kSpinningHttpRequestKeyNoticeid];
    [dic setObject:self.topicid forKey:kSpinningHttpRequestKeyTopicid];
    
    return dic;
}

- (void) parseResultData:(NSDictionary*) dictionary{
    
    if (dictionary == nil) {
        return;
    }
    
    NSDictionary *header = defaultNilObject([dictionary objectForKey:kSpinningHttpKeyHeader]);
    
    NSDictionary *body = defaultNilObject([dictionary objectForKey:kSpinningHttpKeyData]);
    NSMutableDictionary *mutableDic = [NSMutableDictionary dictionaryWithDictionary:header];
    if (body) {
        [mutableDic addEntriesFromDictionary:body];
    }
    
    NSDictionary *dic = [NSDictionary dictionaryWithDictionary:mutableDic];
    
    if (dic) {
        SingleModel *tmpModel = [[InfoCountModel alloc]init];
        [tmpModel parseResultData:dic];
        self.model = tmpModel;
        RbSafeRelease(tmpModel);
    }
}


- (void)dealloc
{
    RbSafeRelease(_noticeid);
    RbSafeRelease(_topicid);
    RbSuperDealoc;
}

@end
