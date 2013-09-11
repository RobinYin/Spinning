//
//  RbTabBarItem.h
//  Spinning
//
//  Created by Robin on 8/11/13.
//  Copyright (c) 2013 Robin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RbTabBarItem : NSObject
@property(nonatomic, retain) UIImage *image;
@property(nonatomic, retain) UIImage *selectedImage;
-(id)initWithImage:(UIImage*)image selectedImage:(UIImage*)selectedImage;
@end
