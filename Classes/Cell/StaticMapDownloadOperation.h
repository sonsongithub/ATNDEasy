//
//  StaticMapDownloadOperation.h
//  ATNDEasy
//
//  Created by sonson on 10/11/28.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DownloadOperation.h"

@interface StaticMapDownloadOperation : DownloadOperation {
	float scale;
	NSString *hash;
}
@property (nonatomic, assign) float scale;
@property (nonatomic, retain) NSString *hash;
+ (NSString*)googleMapURLStringWithLatitude:(float)latitude longitude:(float)longitude width:(int)width height:(int)height zoom:(int)zoom;
+ (StaticMapDownloadOperation*)operationWithLatitude:(float)latitude longitude:(float)longitude;
+ (StaticMapDownloadOperation*)operationWithLatitude:(float)latitude longitude:(float)longitude width:(int)width height:(int)height zoom:(int)zoom;
@end
