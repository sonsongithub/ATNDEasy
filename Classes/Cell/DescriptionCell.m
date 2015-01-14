//
//  DescriptionCell.m
//  ATNDEasy
//
//  Created by sonson on 10/11/09.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "DescriptionCell.h"

#import "ATND.h"

#import "UIColor+Help.h"

///////////////////////////////////////////////////////////////////////////////////////////////////////////
//
// Content view
//
///////////////////////////////////////////////////////////////////////////////////////////////////////////

@interface DescriptionCellContent : UIView {
	NSString*	description;
	BOOL		isExpanded;
}
- (void)setIsExpanded:(BOOL)expanded;
- (void)setDescription:(NSString*)str;
@end

@implementation DescriptionCellContent

#pragma mark -
#pragma mark Instance method

- (void)setIsExpanded:(BOOL)expanded {
	isExpanded = expanded;
	[self setNeedsDisplay];
}

- (void)setDescription:(NSString*)str {
	if (description != str) {
		description = [str retain];
	}
	[self setNeedsDisplay];
}

#pragma mark -
#pragma mark Override

- (id)initWithFrame:(CGRect)rect {
	self = [super initWithFrame:rect];
	if (self) {
		[self setBackgroundColor:[UIColor clearColor]];
	}
	return self;
}

- (void)drawRect:(CGRect)rect {
	[[UIColor systemBlueColor] setFill];
	if (isExpanded) {
		CGSize s = [description sizeWithFont:[ATNDEvent fontForDescription]
						   constrainedToSize:CGSizeMake([ATNDEvent widthForDescription], 10000)];
		[description drawInRect:CGRectMake(10, 10, s.width, s.height)
					   withFont:[ATNDEvent fontForDescription]
				  lineBreakMode:UILineBreakModeCharacterWrap];
	}
	else {
		CGSize s = [description sizeWithFont:[ATNDEvent fontForDescription] 
						   constrainedToSize:CGSizeMake([ATNDEvent widthForDescription], [ATNDEvent heightForTruncatedDescription]) 
							   lineBreakMode:UILineBreakModeTailTruncation];
		[description drawInRect:CGRectMake(10, 10, s.width, s.height)
					   withFont:[ATNDEvent fontForDescription]  lineBreakMode:UILineBreakModeTailTruncation];
	}
}

@end

///////////////////////////////////////////////////////////////////////////////////////////////////////////
//
// Cell implementation
//
///////////////////////////////////////////////////////////////////////////////////////////////////////////

@implementation DescriptionCell

#pragma mark -
#pragma mark Instance method

- (void)setDescription:(NSString*)str {
	[content setDescription:str];
}

- (void)setIsExpanded:(BOOL)expanded {
	[content setIsExpanded:expanded];
}

#pragma mark -
#pragma mark override

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code.
		content = [[DescriptionCellContent alloc] initWithFrame:self.contentView.bounds];
		[content setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
		[self.contentView addSubview:content];
		[content release];
		
		[self setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    return self;
}

#pragma mark -
#pragma mark dealloc

- (void)dealloc {
    [super dealloc];
}

@end
