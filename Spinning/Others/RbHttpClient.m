//
//  RbHttpClient.m
//  Spinning
//
//  Created by Robin on 8/31/13.
//  Copyright (c) 2013 Robin. All rights reserved.
//

#import "RbHttpClient.h"

@implementation RbHttpClient

+(RbHttpClient *)sharedInstance {
    
    static RbHttpClient *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}


- (NSError*) onPostCmdAsync:(RbHttpCmd*) cmd
{
    ASIFormDataRequest* request = [self prepareExecuteApiCmd:cmd];
    NSError *error = [request error];
    [request setRequestMethod:@"POST"];
    [request startAsynchronous];
    if (nil != error) {
        cmd.isFromCache = YES;
    }
    return error;

}

- (NSError*) onPostCmdSync:(RbHttpCmd*) cmd
{
    ASIFormDataRequest* request = [self prepareExecuteApiCmd:cmd];
    NSError *error = [request error];
    [request setRequestMethod:@"POST"];
    [request startSynchronous];
    if (nil != error) {
        cmd.isFromCache = YES;
    }
    return error;
}

- (NSError*) onGetCmdAsync:(RbHttpCmd*) cmd
{
    ASIFormDataRequest* request = [self prepareExecuteApiCmd:cmd];
    NSError *error = [request error];
    [request setRequestMethod:@"GET"];
    [request startAsynchronous];
    if (nil != error) {
        cmd.isFromCache = YES;
    }
    return error;
}

- (NSError*) onGetCmdSync:(RbHttpCmd*) cmd
{
    ASIFormDataRequest* request = [self prepareExecuteApiCmd:cmd];
    NSError *error = [request error];
    [request setRequestMethod:@"GET"];
    [request startSynchronous];
    if (nil != error) {
        cmd.isFromCache = YES;
    }
    return error;
}

- (ASIFormDataRequest*) prepareExecuteApiCmd:(RbHttpCmd *) cmd{
    // prepare post data
    NSMutableDictionary* postDict = [cmd paramDict];
    // get suxffix url string
    
    NSString * _suffixUrlString = [cmd onSuffixUrl];
    
    // prepare http request
    NSURL *url = [NSURL URLWithString:[[NSString stringWithFormat:@"%@%@%@",[RbHttpConfig onApiRequestUrlPrefix],[RbHttpConfig onApiAppId],_suffixUrlString]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [cmd setHttpRequest:request];
    [request setDelegate:cmd];
    

    apiLogInfo(@"ApiRequestURL : [%@]", url);
    apiLogInfo(@"Request Param Count : [%d]", [postDict count]);

    
    // add all parameters to post data
    NSEnumerator *enumerator = [postDict keyEnumerator];
    id key;
    
    while ((key = [enumerator nextObject])) {
        
        id value = [postDict objectForKey:key];
        
        // set post data
        if ([value isKindOfClass:[NSString class]]) {
            [request setPostValue:value forKey:(NSString*)key];
        }else if ([value isKindOfClass:[NSData class]]){
            [request addData:value forKey:key];
        }
        apiLogInfo(@"Post Param : Key [%@] Value [%@]", (NSString*)key, value);

    }
    
    // save all result to a file
    if (!isEmpty([cmd cacheFilePath])) {
        [request setDownloadDestinationPath:[cmd cacheFilePath]];
        apiLogDebug(@"save api result to cache file [%@]",[cmd cacheFilePath]);
    }
    
    return request;
}

//[self parseHttpData:responseData];
//if (nil != _delegate) {
//    if ([_delegate respondsToSelector:@selector(httpResult:error:)]) {
//        [_delegate httpResult:self error:nil];
//    }
//}
- (void)dealloc
{
    RbSuperDealoc;
}
@end
