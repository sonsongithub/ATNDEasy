//
//  DropAnimation.h
//  ATNDEasy
//
//  Created by sonson on 10/11/21.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

CAAnimation* movingAnimationForView(UIView* targetView, float right);
CAAnimation* sizeAnimationForView(UIView *targetView);
CAAnimation* sizeAnimationForViewAndRatio(UIView *targetView, float width_ratio, float height_ratio);
CAAnimation* rotateAnimationForView(UIView *targetView);
CAAnimation* alphaAnimationForView(UIView *targetView);

@interface NSObject(CoreAnimationSupport)
- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag;
@end