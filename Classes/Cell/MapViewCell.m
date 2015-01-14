//
//  MapViewCell.m
//  ATNDEasy
//
//  Created by sonson on 10/11/08.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MapViewCell.h"
#import <QuartzCore/QuartzCore.h>

#pragma mark -
#pragma mark dummy class for MKAnnotation

@interface SimpleAnnoation : NSObject <MKAnnotation> {
	CLLocationCoordinate2D coordinate;
}
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@end

@implementation SimpleAnnoation
@synthesize coordinate;
@end

@implementation MapViewCell

#pragma mark -
#pragma mark Instance method

- (void)setLatitude:(float)latitude longitude:(float)longitude {
	MKCoordinateRegion r = {latitude, longitude, 0.001, 0.001};
	[mapView setRegion:r];
	
	SimpleAnnoation *annotation = [[SimpleAnnoation alloc] init];
	CLLocationCoordinate2D p = {latitude, longitude};
	[annotation setCoordinate:p];
	[mapView addAnnotation:annotation];
	[annotation release];
}

#pragma mark -
#pragma mark Override

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code.
		CGRect b = self.contentView.bounds;
		b.size.width -= 2;
		mapView = [[MKMapView alloc] initWithFrame:b];
		[self.contentView addSubview:mapView];
		[mapView setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
		[mapView setUserInteractionEnabled:NO];
		[mapView release];
		mapView.layer.cornerRadius = 9;
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
