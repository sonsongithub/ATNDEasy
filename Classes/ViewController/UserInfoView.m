//
//  UserInfoView.m
//  ATNDEasy
//
//  Created by sonson on 10/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "UserInfoView.h"

#import "UserIconView.h"
#import "DropAnimation.h"
#import "WatchList.h"

@implementation UserInfoView

@synthesize delegate;

#pragma mark -
#pragma mark Instance method

- (void)setUser:(ATNDUser *)newValue {
	[iconView setUser:newValue];
	[watchButton setEnabled:![[WatchList sharedInstance] isAlreadyWatchingUser:newValue]];
}

- (void)pushWatch:(id)sender {
	DNSLogMethod
	
	if ([delegate respondsToSelector:@selector(didPushWatchButton:)]) {
		[delegate didPushWatchButton:self];
	}
	
	CGRect r = [self convertRect:iconView.frame toView:[[UIApplication sharedApplication] keyWindow]];
	
	UserIconView *movingIconView = [[UserIconView alloc] initWithFrame:r];
	[movingIconView setUser:iconView.user];
	[movingIconView setCornerRadius:10];
	[[[UIApplication sharedApplication] keyWindow] addSubview:movingIconView];
	[movingIconView release];
	
	CAAnimation *movingAnimation = movingAnimationForView(movingIconView, 200);
	CAAnimation *sizeAnimation = sizeAnimationForView(movingIconView);
	CAAnimation *rotateAnimation = rotateAnimationForView(movingIconView);
	CAAnimation *alphaAnimation = alphaAnimationForView(movingIconView);
	
	// make group
	CAAnimationGroup *group = [CAAnimationGroup animation];
	group.animations = [NSArray arrayWithObjects:movingAnimation, alphaAnimation, sizeAnimation, rotateAnimation, nil];
	group.duration = 0.8;
	group.removedOnCompletion = YES;
	group.fillMode = kCAFillModeForwards;
	group.delegate = self;
	
	// set context
	[group setValue:movingIconView forKey:@"context"];
	
	// commit animation
	[movingIconView.layer addAnimation:group forKey:@"hoge"];
	
	[watchButton setEnabled:![[WatchList sharedInstance] isAlreadyWatchingUser:iconView.user]];
}

#pragma mark -
#pragma mark Override

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
		[self setBackgroundColor:[UIColor clearColor]];
		iconView = [[UserIconView alloc] initWithFrame:CGRectMake(40, (int)(self.bounds.size.height-60)/2, 60, 60)];
		[iconView setCornerRadius:10];
		[self addSubview:iconView];
		[iconView release];
		
		UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		[button setFrame:CGRectMake(self.bounds.size.width - 150 - 40, (int)(self.bounds.size.height-44)/2, 150, 44)];
		[button.titleLabel setNumberOfLines:2];
		[button.titleLabel setTextAlignment:UITextAlignmentCenter];
		[button.titleLabel setLineBreakMode:UILineBreakModeWordWrap];
		[button setTitle:NSLocalizedString(@"Watch this user", nil) forState:UIControlStateNormal];
		[button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
		[button setTitle:NSLocalizedString(@"Already watching", nil) forState:UIControlStateDisabled];
		[self addSubview:button];
		watchButton = button;
		
		[button addTarget:self action:@selector(pushWatch:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

#pragma mark -
#pragma mark dealloc

- (void)dealloc {
    [super dealloc];
}

@end
