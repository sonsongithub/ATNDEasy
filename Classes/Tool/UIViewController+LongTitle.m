//
//  UIViewController+LongTitle.m
//  ATNDEasy
//
//  Created by sonson on 10/11/11.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "UIViewController+LongTitle.h"


@implementation UIViewController(LongTitle)

- (void)setLongTitle:(NSString*)newTitle {
	CGSize s = [newTitle sizeWithFont:[UIFont boldSystemFontOfSize:18]];
	if (s.width < 240) {
		[self setTitle:newTitle];
	}
	else {
		UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
		[label setAutoresizingMask:UIViewAutoresizingNone];
		[label setNumberOfLines:2];
		[label setTextAlignment:UITextAlignmentCenter];
		[label setBackgroundColor:[UIColor clearColor]];
		label.font = [UIFont boldSystemFontOfSize:14];
		label.textColor = [UIColor whiteColor];
		label.shadowColor = [UIColor darkGrayColor];
		label.shadowOffset = CGSizeMake(0,-1);
		[label setText:newTitle];
		CGRect b =[label textRectForBounds:CGRectMake(0, 0, 240, 300) limitedToNumberOfLines:2];
		[label setBounds:b];
		[[self navigationItem] setTitleView:label];
		[label release];
	}
}

@end

