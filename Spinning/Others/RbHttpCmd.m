//
//  RbHttpCmd.m
//  Spinning
//
//  Created by Robin on 8/31/13.
//  Copyright (c) 2013 Robin. All rights reserved.
//

#import "RbHttpCmd.h"
@interface RbHttpCmd()
@property (nonatomic, retain)ASIFormDataRequest *request;
@property (nonatomic, retain)NSDictionary* resultDict;
- (void) parseHttpData:(NSData*) data;
- (NSString*) cacheKey;

@end

@implementation RbHttpCmd

@synthesize resultDict = _resultDict;
@synthesize errorDict = _errorDict;
@synthesize isFromCache = _isFromCache;
@synthesize delegate = _delegate;
@synthesize request = _request;

- (id)init
{
    
    self = [super init];
    if (self) {
        _resultDict = nil;
        _isFromCache = NO;
        _errorDict = nil;
    }
    
    return self;
}

- (NSString *)onSuffixUrl
{
    return nil;
}

- (BOOL) hasError {
    
    if (self.errorDict) {
        NSLog(@"%@",self.errorDict);
        if ([defaultEmptyString([self.errorDict objectForKey:kSpinningHttpKeyCode]) isEqualToString:@"200"]) {
            return NO;
        }
    }
    return YES;
    
}

- (void) parseApiError:(NSDictionary*) dictionary {

    self.errorDict = nil;
    
    NSDictionary *header = nil;
    NSString *code = nil;
    NSString *msg = nil;
    
    if ([dictionary isKindOfClass:[NSDictionary class]]) {
        header =defaultNilObject([dictionary objectForKey:kSpinningHttpKeyHeader]);
        if (header) {
            code = defaultEmptyString([header objectForKey:kSpinningHttpKeyCode]);
            msg = defaultEmptyString([header objectForKey:kSpinningHttpKeyMsg]);
        }else
        {
            code = nil;
            msg = nil;
        }
    }else {
        code = nil;
        msg = nil;
        
        return ;
    }
    
    if (nil == code || nil == msg) {
        // no error
        return;
    }
    NSMutableDictionary *dic =  [NSMutableDictionary dictionary];
    self.errorDict =  dic;
    [_errorDict setObject:code forKey:kSpinningHttpKeyCode];
    [_errorDict setObject:msg forKey:kSpinningHttpKeyMsg];
    NSLog(@"%@,%@",_errorDict,self.errorDict);
    
}

- (void) parseHttpData:(NSData*) data
{
    [self parseJson:data];
    
    if (nil == self.resultDict) {
        return;
    }
    [self parseApiError:self.resultDict];
    
//    if (![self hasError]) {
        [self parseResultData:self.resultDict];
//    }
    
}

- (void) parseResultData:(NSDictionary*) dictionary{

}

- (void) parseJson:(NSData*) data
{
    if (nil == data) {
        return;
    }
    
    NSString* jsonString = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
    if (nil == jsonString) {
        
        apiLogError(@"can not parse NSData to string");
        return;
    }
    
    apiLogInfo(@"****Return Json String:\n%@", jsonString);
    
    NSDictionary* tmpDict = [jsonString JSONValue];
    
    if (nil == tmpDict) {
        apiLogError(@"can not parse json string to NSDictionary");
    }
    
    // set the dict value
    self.resultDict = tmpDict;
    
    
}

- (NSString*) cacheFilePath {
    
    if (isEmpty([self cacheKey])) {
        return nil;
    }
    
    return cacheFilePath([self cacheKey]);
}

- (NSMutableDictionary*) paramDict{
    return [NSMutableDictionary dictionaryWithCapacity:1];
}

- (NSString*) cacheKey {
    
    NSMutableString* cacheKey = [[[NSMutableString alloc] initWithCapacity:30] autorelease];
    
    // generate cache key from parameters
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[self paramDict]];
    [dic setObject:NSStringFromClass([self class]) forKey:kSpinningHttpKeyExcutecmd];
    NSDictionary* paramDict = [NSDictionary dictionaryWithDictionary:dic];
    
    // add all keys into array
    NSMutableArray* paramArray = [[[NSMutableArray alloc] initWithCapacity:[paramDict count]] autorelease];
    
    NSEnumerator *enumerator = [paramDict keyEnumerator];
    NSString* key;
    
    while ((key = [enumerator nextObject])) {
        [paramArray addObject:key];
    }
    
    // sort the param array
    [paramArray sortUsingComparator:^(id obj1, id obj2){
        NSString* str1 = obj1;
        NSString* str2 = obj2;
        return [str1 compare:str2];
    }];
    
    for (NSInteger index = 0; index < [paramArray count]; index++) {
        NSString* key = [paramArray objectAtIndex:index];
        id tmpId = [paramDict objectForKey:key];
        
        NSString* strValue =  @"";
        
        if ([tmpId isKindOfClass:[NSString class]]) {
            strValue = tmpId;
        }else if([tmpId isKindOfClass:[NSNumber class]]){
            strValue = [tmpId stringValue];
        }else{
            strValue =  @"";
        }
        
        [cacheKey appendFormat:@"_%@_%@_", key, strValue];
    }
    
    
    if (isEmpty(cacheKey)) {
        return nil;
    }
    
    return cacheKey;
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSData *responseData = [NSData dataWithContentsOfFile:[self cacheFilePath]];
    [self parseHttpData:responseData];
    if (nil != _delegate) {
        if ([_delegate respondsToSelector:@selector(httpResult:error:)]) {
            [_delegate httpResult:self error:nil];
        }
    }
    
}

/**
 *  ASIHttp callback fail
 **/
- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    NSData * responseData;
    
    if (error != nil) {
        apiLogDebug(@"request failed error %@",[error description]);
    }
    
    if ([request responseString].length) {
        responseData = [request responseData];
    }else
        responseData = nil;
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:[self cacheFilePath]]) {
        
        apiLogDebug(@"network error, read from cache file [%@]",[self cacheFilePath]);
        
        responseData = [NSData dataWithContentsOfFile:[self cacheFilePath]];
        [self parseHttpData:responseData];
    }
    
    if (nil != responseData) {
        _isFromCache = YES;
    }
    
    if (nil != _delegate) {
        if ([_delegate respondsToSelector:@selector(httpResult:error:)]) {
            [_delegate httpResult:self error:error];
        }
    }
}

- (void)setHttpRequest:(ASIFormDataRequest *)req
{
    if (_request != req) {
        if (_request) {
            [_request clearDelegatesAndCancel];
        }
        self.request = req;
    }
}

- (void)dealloc
{
    if (_request) {
        [_request clearDelegatesAndCancel];
    }
    RbSafeRelease(_request);
    RbSafeRelease(_resultDict);
    RbSafeRelease(_errorDict);
    RbSuperDealoc;
}
@end
