//
//  RbUtility.h
//  Spinning
//
//  Created by Robin on 7/28/13.
//  Copyright (c) 2013 Robin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RbUtility : NSObject

void RbEvent(NSString *eventName,id data);

void RbListenEvent(NSString *eventName,id target,SEL method);

void RbForgetEvent(NSString *eventName,id target);

UIImage* resizeImageWithImage(NSString* imageName, UIEdgeInsets capInsets, UIImageResizingMode resizingMode);

UIColor *colorFromHexRGB(NSString *inColorString);

NSArray *rectsFromArray(NSArray *array, UIFont *font ,CGSize constrained ,CGFloat gap);

NSString* md5(NSString* input);

NSString* trimString (NSString* input);

BOOL isNull(id object);

BOOL isEmpty(NSString* str);

id defaultNilObject(id object);

NSString* defaultEmptyString(id object);


NSNumber * parseNSNumberFromString(NSString * string);

extern NSDate* parseDateFromNSNumber(NSNumber* number);

extern BOOL parseBoolFromString(NSString* boolValue);

/**
 *  add a http static prefix path, it the path is not absolute path
 *
 *  such as  /static/img/123.jpg --->  http://staticprefix/static/img/123.jpg
 **/
NSString* prepareStaticHttpPath(NSString* path);


/**
 * extract the file name from path
 *
 **/
NSString* extractFileNameFromPath(NSString* path);

/**
 *  get the Tmp path of download file
 *
 ***/
NSString* tmpDownloadFilePath(NSString* filePath);

/**
 *  get cache file path
 ***/
NSString* cacheFilePath(NSString* cacheKey);

@end
