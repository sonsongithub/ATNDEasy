//
//  DropAnimation.m
//  ATNDEasy
//
//  Created by sonson on 10/11/21.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "DropAnimation.h"

@implementation NSObject(CoreAnimationSupport)

- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag {
	DNSLogMethod
	UIView *p = [theAnimation valueForKey:@"context"];\
	[p removeFromSuperview];
}

@end

CAAnimation* movingAnimationForView(UIView* targetView, float right) {
	CGRect iconRectOnMainWindow = [[targetView superview] convertRect:targetView.frame toView:[[UIApplication sharedApplication] keyWindow]];
	
	// position
	CGMutablePathRef thePath = CGPathCreateMutable();
	CGPathMoveToPoint(thePath, NULL, iconRectOnMainWindow.origin.x+targetView.bounds.size.width/2, iconRectOnMainWindow.origin.y+targetView.bounds.size.height/2);
	CGPathAddCurveToPoint(thePath,NULL,iconRectOnMainWindow.origin.x+targetView.bounds.size.width/2, -20+targetView.bounds.size.height/2, right-10, -20, right, 470);
	CAKeyframeAnimation * theAnimation =[CAKeyframeAnimation animationWithKeyPath:@"position"];
	theAnimation.path=thePath;
	CGFloat cx1 = 0.5;
	CGFloat cy1 = 0.5;
	CGFloat cx2 = 0.5;
	CGFloat cy2 = 0.25;
	theAnimation.timingFunction = [[[CAMediaTimingFunction alloc] initWithControlPoints:cx1 :cy1 :cx2 :cy2] autorelease];
	CFRelease(thePath);
	
	return theAnimation;
}

CAAnimation* sizeAnimationForView(UIView *targetView) {
	return sizeAnimationForViewAndRatio(targetView, 0.4, 0.4);
}

CAAnimation* sizeAnimationForViewAndRatio(UIView *targetView, float width_ratio, float height_ratio) {
	// size
	CAKeyframeAnimation *sizeAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];	
	sizeAnimation.values = [NSArray arrayWithObjects:
							[NSNumber numberWithFloat:1],
							[NSNumber numberWithFloat:1],
							[NSNumber numberWithFloat:width_ratio],
							nil];
	sizeAnimation.keyTimes = [NSArray arrayWithObjects:
							  [NSNumber numberWithFloat:0],
							  [NSNumber numberWithFloat:0.8],
							  [NSNumber numberWithFloat:1],
							  nil];
	return sizeAnimation;
}

CAAnimation* rotateAnimationForView(UIView *targetView) {
	
	// rotation
	CAKeyframeAnimation *rotateAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation"];
	rotateAnimation.values = [NSArray arrayWithObjects:
							  [NSNumber numberWithFloat:0],
							  [NSNumber numberWithFloat:0.1],
							  [NSNumber numberWithFloat:0.2],
							  nil];
	rotateAnimation.keyTimes = [NSArray arrayWithObjects:
								[NSNumber numberWithFloat:0],
								[NSNumber numberWithFloat:0.8],
								[NSNumber numberWithFloat:1],
								nil];
	return rotateAnimation;
}

CAAnimation* alphaAnimationForView(UIView *targetView) {
	// alpha
	CAKeyframeAnimation *alphaAnimation = [CAKeyframeAnimation	animationWithKeyPath:@"opacity"];
	alphaAnimation.values = [NSArray arrayWithObjects:
							 [NSNumber numberWithFloat:1],
							 [NSNumber numberWithFloat:1.0],
							 [NSNumber numberWithFloat:0.8],
							 nil];
	alphaAnimation.keyTimes = [NSArray arrayWithObjects:
							   [NSNumber numberWithFloat:0],
							   [NSNumber numberWithFloat:0.8],
							   [NSNumber numberWithFloat:1],
							   nil];
	return alphaAnimation;
}

