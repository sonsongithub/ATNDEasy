//
//  UserCell.m
//  ATNDEasy
//
//  Created by sonson on 10/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#define CIRCLED_NUMBER_RIGHT_MARGIN			5

#import "UserCell.h"

#import "UserIconView.h"
#import "CircledNumberView.h"
#import "UserNameView.h"

@implementation UserCell

- (void)setUser:(ATNDUser *)newValue {
	[iconView setUser:newValue];
	
	[nameView setUser:newValue];
	[numberView setNumber:newValue.numberOfUnread];

	[self setNeedsLayout];
}

- (void)layoutSubviews {
	[super layoutSubviews];
	
	CGRect numberViewRect = numberView.frame;
	numberViewRect.origin.x = self.contentView.frame.size.width - numberViewRect.size.width - CIRCLED_NUMBER_RIGHT_MARGIN;
	numberViewRect.origin.y = (int)(self.contentView.frame.size.height - numberViewRect.size.height)/2;
	[numberView setFrame:numberViewRect];
	
	CGRect nameViewRect = nameView.frame;
	nameViewRect.origin.x = 50;
	nameViewRect.origin.y = (int)(self.contentView.frame.size.height - nameViewRect.size.height)/2;
	nameViewRect.size.width = numberViewRect.origin.x - nameViewRect.origin.x;
	[nameView setFrame:nameViewRect];
}

#pragma mark -
#pragma mark Override

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code.
		[self.contentView setBackgroundColor:[UIColor clearColor]];
		
		numberView = [[CircledNumberView alloc] init];
		[self.contentView addSubview:numberView];
		
		nameView = [[UserNameView alloc] init];
		[self.contentView addSubview:nameView];
		
		iconView = [[UserIconView alloc] initWithFrame:CGRectMake(10, 5, 34, 34)];
		[iconView setCornerRadius:5];
		[self.contentView addSubview:iconView];
		[iconView release];
	}
    return self;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
	[super setHighlighted:highlighted animated:animated];
	[numberView setHighlighted:highlighted];
	[nameView setHighlighted:highlighted];
}

- (void)dealloc {
	[nameView release];
	[numberView release];
    [super dealloc];
}

@end
