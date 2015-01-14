//
//  StaticMapDownloadOperation.m
//  ATNDEasy
//
//  Created by sonson on 10/11/28.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "StaticMapDownloadOperation.h"

#import "StaticMapViewCell.h"

#import "SQLiteDatabase+staticMapCache.h"

#import "NSString+digest.h"

#define GOOGLE_MAP_API @"http://maps.google.com/maps/api/staticmap?center=%3.6f,%3.6f&zoom=%d&size=%dx%d&sensor=false&markers=color:red|size:mid|%3.6f,%3.6f"

@implementation StaticMapDownloadOperation

@synthesize scale, hash;

+ (NSString*)googleMapURLStringWithLatitude:(float)latitude longitude:(float)longitude width:(int)width height:(int)height zoom:(int)zoom {
	NSString *url = [NSString stringWithFormat:GOOGLE_MAP_API, latitude, longitude, zoom, width, height, latitude, longitude];
	return [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

+ (StaticMapDownloadOperation*)operationWithLatitude:(float)latitude longitude:(float)longitude {
	DNSLog(@"%f,%f", latitude, longitude);
	NSString *url = [NSString stringWithFormat:GOOGLE_MAP_API, latitude, longitude, StaticMapViewCellZoom, StaticMapViewCellWidth, StaticMapViewCellHeight, latitude, longitude];
	NSString *urlEscaped = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	StaticMapDownloadOperation *op = [StaticMapDownloadOperation operationFromURL:[NSURL URLWithString:urlEscaped]];
	[op setHash:[[StaticMapDownloadOperation googleMapURLStringWithLatitude:latitude longitude:longitude width:StaticMapViewCellWidth height:StaticMapViewCellHeight zoom:StaticMapViewCellZoom] MD5DigestString]];
	
	DNSLog(@" = Hash = %@", [op hash]);
	return op;
}

+ (StaticMapDownloadOperation*)operationWithLatitude:(float)latitude longitude:(float)longitude width:(int)width height:(int)height zoom:(int)zoom {
	DNSLog(@"%f,%f", latitude, longitude);
	NSString *url = [NSString stringWithFormat:GOOGLE_MAP_API, latitude, longitude, zoom, width, height, latitude, longitude];
	NSString *urlEscaped = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	StaticMapDownloadOperation *op = [StaticMapDownloadOperation operationFromURL:[NSURL URLWithString:urlEscaped]];
	[op setHash:[[StaticMapDownloadOperation googleMapURLStringWithLatitude:latitude longitude:longitude width:StaticMapViewCellWidth height:StaticMapViewCellHeight zoom:StaticMapViewCellZoom] MD5DigestString]];
	return op;
}

- (void)doTaskAfterDownloadingData:(NSData*)data {
	UIImage *image = nil;
	
	[[SQLiteDatabase sharedInstance] insertStaticMapCache:data scale:scale hash:hash];
					  
	if (scale == 2) {
		UIImage *originalImage = [UIImage imageWithData:data];
		image = [UIImage imageWithCGImage:[originalImage CGImage] scale:2 orientation:UIImageOrientationUp];
	}
	else {
		image = [UIImage imageWithData:data];
	}
	if (image) {
		DNSLogSize(image.size);
		NSDictionary *info = [NSDictionary dictionaryWithObject:image forKey:@"image"];
		[target didDownloadOperation:self userInfo:info];
	}
}

- (void)doTaskAfterReturnedDifferentURL {
}

- (void)doTaskAfterFailedDownload:(NSError*)error {
}

- (void) dealloc {
	[hash release];
	[super dealloc];
}


@end
