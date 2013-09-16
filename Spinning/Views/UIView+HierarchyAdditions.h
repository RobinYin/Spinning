#import <Foundation/Foundation.h>

typedef void (^VisitSubviewBlock)(UIView *subview );

@interface UIView(HierarchyAdditions)

-(NSArray *) allSubviews;

-(void) visitAllSubviewsWithBlock: (VisitSubviewBlock) visitSubviewBlock;

@end
