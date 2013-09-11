//
//  RbUtility.m
//  Spinning
//
//  Created by Robin on 7/28/13.
//  Copyright (c) 2013 Robin. All rights reserved.
//

#import "RbUtility.h"
#import <CommonCrypto/CommonDigest.h>

@implementation RbUtility

void RbEvent(NSString *eventName,id data){
	[[NSNotificationCenter defaultCenter] postNotificationName:eventName object:data];
}

void RbListenEvent(NSString *eventName,id target,SEL method){
	[[NSNotificationCenter defaultCenter] addObserver:target selector:method name:eventName object:nil];
}

void RbForgetEvent(NSString *eventName,id target){
	[[NSNotificationCenter defaultCenter] removeObserver:target name:eventName object:nil];
}


UIImage* resizeImageWithImage(NSString* imageName, UIEdgeInsets capInsets, UIImageResizingMode resizingMode){
    CGFloat systemVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    UIImage *image = [UIImage imageNamed:imageName];
    
    if (systemVersion >= 6.0) {
        return [image resizableImageWithCapInsets:capInsets resizingMode:resizingMode];
        return [image resizableImageWithCapInsets:capInsets];;
    }
    
    if (systemVersion >= 5.0) {
        return [image resizableImageWithCapInsets:capInsets];;
    }
    return  [image stretchableImageWithLeftCapWidth:capInsets.left topCapHeight:capInsets.top];
}

UIColor *colorFromHexRGB(NSString *inColorString)
{
    UIColor *result = nil;
    unsigned int colorCode = 0;
    unsigned char redByte, greenByte, blueByte;
    
    if (nil != inColorString)
    {
        NSScanner *scanner = [NSScanner scannerWithString:inColorString];
        (void) [scanner scanHexInt:&colorCode]; // ignore error
    }
    redByte = (unsigned char) (colorCode >> 16);
    greenByte = (unsigned char) (colorCode >> 8);
    blueByte = (unsigned char) (colorCode); // masks off high bits
    result = [UIColor
              colorWithRed: (float)redByte / 0xff
              green: (float)greenByte/ 0xff
              blue: (float)blueByte / 0xff
              alpha:1.0];
    return result;
}

NSArray *rectsFromArray(NSArray *array, UIFont *font ,CGSize constrained ,CGFloat gap)
{
    CGRect rect = CGRectMake(gap, 0, 0, constrained.height);
    NSMutableArray *retArray = [NSMutableArray array];
    for (NSString *string in array) {
        CGSize size = [string sizeWithFont:font constrainedToSize:constrained lineBreakMode:NSLineBreakByCharWrapping];
        rect = CGRectMake(rect.origin.x+rect.size.width, rect.origin.y, size.width +gap,constrained.height);
        [retArray addObject:NSStringFromCGRect(rect)];
    }
    return [NSArray arrayWithArray:retArray];
}

NSString* md5(NSString* input)
{
    const char *cStr = [input UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, strlen(cStr), digest ); // This is the md5 call
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return  output;
    
}

NSString* trimString (NSString* input) {
    NSMutableString *mStr = [input mutableCopy];
    CFStringTrimWhitespace((CFMutableStringRef)mStr);
    NSString *result = [mStr copy];
    [mStr release];
    return [result autorelease];
}

BOOL isNull(id object) {
    return (nil == object || [object isKindOfClass:[NSNull class]]);
}

id defaultNilObject(id object) {
    
    if (isNull(object)) {
        return nil;
    }
    
    return object;
}

BOOL isEmpty(NSString* str) {
    
    if (isNull(str)) {
        return YES;
    }
    
    return [trimString(str) length] <= 0;
}

NSString* defaultEmptyString(id object) {
    
    if (isNull(object)) {
        return @"";
    }
    
    if ([object isKindOfClass:[NSString class]]) {
        return object;
    }
    
    if ([object respondsToSelector:@selector(stringValue)]) {
        return [object stringValue];
    }
    
    return @"";
}

NSNumber * parseNSNumberFromString(NSString * string){
    
    if (nil == string || [string isKindOfClass:[NSString class]]) {
        return nil;
    }
    NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
    [f setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumber * myNumber = [f numberFromString:string];
    [f release];
    
    return myNumber;
}

NSDate* parseDateFromNSNumber(NSNumber* number){
    
    if (nil == number || ![number isKindOfClass:[NSNumber class]]) {
        return nil;
    }
    
    return [NSDate dateWithTimeIntervalSince1970:[number longValue]];
}

BOOL parseBoolFromString(NSString* boolValue){
    
    if (nil == boolValue) {
        return NO;
    }
    
    static NSString* boolTrue = @"true";
    //static NSString* boolFalse = @"false";
    
    if (NSOrderedSame == [boolTrue caseInsensitiveCompare:boolValue]) {
        return YES;
    }
    
    return NO;
}


NSString* prepareStaticHttpPath(NSString* path){
    
    NSRange range = [path rangeOfString:@"http://"];
    
    // absolute path ,return directly
    if (range.length > 0) {
        return path;
    }
    
    // add static prefix
    return [[RbHttpConfig onApiRequestUrlPrefix] stringByAppendingFormat:@"%@",path];
}


NSString* extractFileNameFromPath(NSString* path){
    return [path lastPathComponent];
}


NSString* tmpDownloadFilePath(NSString* filePath){
    return [NSTemporaryDirectory() stringByAppendingPathComponent:extractFileNameFromPath(filePath)];
}

NSString* cacheFilePath(NSString* cacheKey){
    return [NSTemporaryDirectory() stringByAppendingPathComponent:cacheKey];
}


@end
