//
//  MapViewCell.h
//  ATNDEasy
//
//  Created by sonson on 10/11/08.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface MapViewCell : UITableViewCell {
	MKMapView *mapView;
}
- (void)setLatitude:(float)latitude longitude:(float)longitude;
@end
