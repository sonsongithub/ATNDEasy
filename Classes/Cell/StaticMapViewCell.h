//
//  StaticMapViewCell.h
//  ATNDEasy
//
//  Created by sonson on 10/11/28.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DownloadOperation.h"

#define StaticMapViewCellWidth	300
#define StaticMapViewCellHeight 150
#define StaticMapViewCellZoom	14

@interface StaticMapViewCell : UITableViewCell <DownloadOperationDelegate> {
	UIImageView *mapImageView;
	UIActivityIndicatorView *indicator;
}
- (void)setLatitude:(float)latitude longitude:(float)longitude;
@end