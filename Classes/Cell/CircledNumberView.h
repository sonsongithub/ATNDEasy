//
//  CircledNumberView.h
//  ATNDEasy
//
//  Created by sonson on 10/11/22.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CircledNumberView : UIView {
	int			number;
	NSString	*numberString;
	BOOL		highlighted;
}
@property (nonatomic, assign) int number;
- (id)init;
- (void)setHighlighted:(BOOL)newValue;
@end
