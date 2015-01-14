//
//  HUDView.m
//  ATNDEasy
//
//  Created by sonson on 10/11/27.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "HUDView.h"

static void dropFractionOfRect(CGRect *rect) {
	rect->origin.x = (int)rect->origin.x;
	rect->origin.y = (int)rect->origin.y;
	rect->size.width = (int)rect->size.width;
	rect->size.height = (int)rect->size.height;
}

@interface HUDView(Private)

- (void)roundCornerPath:(CGRect)rect radius:(float)radius;
- (void) arrange:(CGRect)rect;
- (void)setupWithMessage:(NSString*)msg;

@end

@implementation HUDView(Private)

- (void)roundCornerPath:(CGRect)rect radius:(float)radius {
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	// get points
	CGFloat minx = CGRectGetMinX( rect ), midx = CGRectGetMidX( rect ), maxx = CGRectGetMaxX( rect );
	CGFloat miny = CGRectGetMinY( rect ), midy = CGRectGetMidY( rect ), maxy = CGRectGetMaxY( rect );
	
	CGContextMoveToPoint(context, minx, midy);
	CGContextAddArcToPoint(context, minx, miny, midx, miny, radius);
	CGContextAddArcToPoint(context, maxx, miny, maxx, midy, radius);
	CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius);
	CGContextAddArcToPoint(context, minx, maxy, minx, midy, radius);
	CGContextClosePath(context);
}

- (void) arrange:(CGRect)rect {
	CGRect superview_rect = rect;
	CGRect self_rect = self.frame;
	self_rect.origin.x = superview_rect.size.width /2 - self.frame.size.width /2;
	self_rect.origin.y = superview_rect.size.height /2 - self.frame.size.height /2;
	dropFractionOfRect(&self_rect);
	self.frame = self_rect;
}

- (void)setupWithMessage:(NSString*)msg {
	label.text = msg;
	CGRect label_rect = [label textRectForBounds:CGRectMake( 0,0,220,60) limitedToNumberOfLines:2];
	
	// parent view's size depend on label size.
	CGRect self_rect = CGRectMake( 0, 0, label_rect.size.width + 20, 150 );
	
	CGRect animation_item_rect;
	
	[indicator removeFromSuperview];
	
	// sett up activity indicator
	animation_item_rect = indicator.frame;
	animation_item_rect.origin.x = self_rect.size.width / 2 - animation_item_rect.size.width / 2 ;
	animation_item_rect.origin.y = 45 - animation_item_rect.size.height / 2 ;
	dropFractionOfRect(&animation_item_rect);
	indicator.frame = animation_item_rect;
	[self addSubview:indicator];
	[indicator startAnimating];
	
	label_rect.origin.y = animation_item_rect.origin.y + animation_item_rect.size.height/2 + 26;
	label_rect.origin.x = self_rect.size.width / 2 - label_rect.size.width / 2 ;
	dropFractionOfRect(&label_rect);
	label.frame = label_rect;
	
	self_rect.size.height = label_rect.origin.y +  + label_rect.size.height + 24;
	dropFractionOfRect(&self_rect);
	self.frame = self_rect;
	[self addSubview:label];
	
	[self arrange:[[self superview] frame]];
	
	[self setNeedsDisplay];
}

@end

@implementation HUDView

+ (HUDView*)showHUDViewWithMessage:(NSString*)msg {
	HUDView *hud = [[HUDView alloc] init];
	[[[UIApplication sharedApplication] keyWindow] addSubview:hud];
	[hud setupWithMessage:msg];
	[hud release];
	[[[UIApplication sharedApplication] keyWindow] setUserInteractionEnabled:NO];
	return hud;
}

- (void)dismiss {
	[self removeFromSuperview];
	[[[UIApplication sharedApplication] keyWindow] setUserInteractionEnabled:YES];
}

#pragma mark -
#pragma mark Override

- (id)init {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        // Initialization code.
		[self setBackgroundColor:[UIColor clearColor]];
		
		// setup label
		label = [[UILabel alloc] initWithFrame:CGRectZero];
		label.backgroundColor = [UIColor clearColor];
		UIFont *font = [UIFont boldSystemFontOfSize:24];
		label.textColor = [UIColor whiteColor];
		label.font = font;
		label.textAlignment = UITextAlignmentCenter;
		label.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
		label.lineBreakMode = UILineBreakModeCharacterWrap;
		label.numberOfLines = 2;
		
		// setup activity view
		indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
		[self addSubview:indicator];
		[indicator startAnimating];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
	CGContextRef context = UIGraphicsGetCurrentContext();
	[self roundCornerPath:rect radius:10];
	CGContextSetRGBFillColor(context, 0.2, 0.2, 0.2, 0.75);
	CGContextFillPath(context);
}

#pragma mark -
#pragma mark dealloc

- (void)dealloc {
	[indicator release];
	[label release];
    [super dealloc];
}


@end
