//
//  EventBaseCell.m
//  ATNDEasy
//
//  Created by sonson on 10/11/12.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "EventBaseCell.h"

@implementation EventBaseContent

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
		[self setContentMode:UIViewContentModeLeft];
		[self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

- (void)setHighlighted:(BOOL)newValue {
	// dummy implementation
}

- (void)setEvent:(ATNDEvent*)newValue {
	event = newValue;
	[self setNeedsDisplay];
}

- (void)setFrame:(CGRect)rect {
	[super setFrame:rect];
	[self setNeedsDisplay];
}

@end

@implementation EventBaseCell

#pragma mark -
#pragma mark Class method

+ (float)height {
	return 60;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code.
		[self setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    return self;
}

- (void)setEvent:(ATNDEvent*)newValue {
	[content setEvent:newValue];
}

@end
