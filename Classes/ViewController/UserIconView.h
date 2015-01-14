//
//  UserIconView.h
//  ATNDEasy
//
//  Created by sonson on 10/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DownloadOperation.h"
#import "ATND.h"

@interface UserIconView : UIView <DownloadOperationDelegate> {
	ATNDUser					*user;
	UIActivityIndicatorView		*indicator;
	int							cornerRadius;
}
@property (nonatomic, retain) ATNDUser* user;
@property (nonatomic, assign) int cornerRadius;
@end
