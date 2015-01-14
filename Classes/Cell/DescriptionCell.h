//
//  DescriptionCell.h
//  ATNDEasy
//
//  Created by sonson on 10/11/09.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DescriptionCellContent;

@interface DescriptionCell : UITableViewCell {
	DescriptionCellContent *content;
}
- (void)setIsExpanded:(BOOL)expanded;
- (void)setDescription:(NSString*)str;
@end
