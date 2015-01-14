//
//  TwitterIconDownloadOperation.m
//  ATNDEasy
//
//  Created by sonson on 10/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "TwitterIconDownloadOperation.h"

#import "UIImage+OptimizedPNG.h"

NSString *kTwitterIconOriginalImage = @"kTwitterIconOriginalImage";
NSString *kTwitterIconOptimizedImage = @"kTwitterIconOptimizedImage";
NSString *kTwitterIconURL = @"kTwitterIconURL";

@implementation TwitterIconDownloadOperation

- (void)doTaskAfterDownloadingData:(NSData*)data {
	NSData *optData = [data optimizedData];
	
	
	
	NSDictionary *info = [NSDictionary dictionaryWithObjectsAndKeys:
						  data,			kTwitterIconOriginalImage,
						  optData,		kTwitterIconOptimizedImage,
						  [request URL],kTwitterIconURL,
						  nil
						  ];
	
	[target didDownloadOperation:self userInfo:info];
}

@end
