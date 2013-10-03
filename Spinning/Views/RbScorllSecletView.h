//
//  RbScorllSecletView.h
//  Spinning
//
//  Created by Robin on 7/28/13.
//  Copyright (c) 2013 Robin. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ScrollSelectDelegate;
@interface RbScorllSecletView : UIScrollView<UIScrollViewDelegate>
{
    id<ScrollSelectDelegate> _selectDelegate;
}
@property (nonatomic, assign)id<ScrollSelectDelegate> selectDelegate;
- (void)setTitles:(NSArray*)array;
- (void)scrollToIndex:(NSInteger)index;
@end

@protocol ScrollSelectDelegate <NSObject>

@optional
- (void)scrollSelectAtIndex:(NSInteger)index;
@end