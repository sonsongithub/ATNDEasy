//
//  StaticMapViewCell.m
//  ATNDEasy
//
//  Created by sonson on 10/11/28.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "StaticMapViewCell.h"

#import "DownloadQueue.h"
#import <QuartzCore/QuartzCore.h>
#import "StaticMapDownloadOperation.h"
#import "NSString+digest.h"

#import "SQLiteDatabase+staticMapCache.h"

@implementation StaticMapViewCell

- (void)setLatitude:(float)latitude longitude:(float)longitude {
	[[DownloadQueue sharedInstance] removeQueuesForTarget:self];
	
	float scale = [[UIScreen mainScreen] scale];
	
	NSString *urlString = [StaticMapDownloadOperation googleMapURLStringWithLatitude:latitude longitude:longitude width:StaticMapViewCellWidth height:StaticMapViewCellHeight zoom:StaticMapViewCellZoom];
	NSString *hash = [urlString MD5DigestString];
	NSData *binary = nil;
	float imageScale = 0;
	
	[[SQLiteDatabase sharedInstance] selectStaticMapCache:&binary scale:&imageScale hash:hash];
	
	DNSLog(@"Hash = %@", [urlString MD5DigestString]);
	
	if (binary == nil || scale != imageScale) {
		if (scale == 2) {
			StaticMapDownloadOperation *op = [StaticMapDownloadOperation operationWithLatitude:latitude longitude:longitude width:(int)StaticMapViewCellWidth*scale height:(int)StaticMapViewCellHeight*scale zoom:StaticMapViewCellZoom+1];
			[op setScale:scale];
			[op setTarget:self];
			[[DownloadQueue sharedInstance] addQueue:op];
		}
		else {
			StaticMapDownloadOperation *op = [StaticMapDownloadOperation operationWithLatitude:latitude longitude:longitude width:StaticMapViewCellWidth height:StaticMapViewCellHeight zoom:StaticMapViewCellZoom];
			[op setScale:scale];
			[op setTarget:self];
			[[DownloadQueue sharedInstance] addQueue:op];
		}
		
		indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
		[self.contentView addSubview:indicator];
		[indicator release];
		[indicator startAnimating];
	}
	else {
		
		[[SQLiteDatabase sharedInstance] updateStaticMapCacheDateWithHash:hash];
		
		UIImage *image = nil;
		
		if (imageScale == 2) {
			UIImage *originalImage = [UIImage imageWithData:binary];
			image = [UIImage imageWithCGImage:[originalImage CGImage] scale:2 orientation:UIImageOrientationUp];
		}
		else {
			image = [UIImage imageWithData:binary];
		}
		if (image) {
			[mapImageView setImage:image];
		}
	}
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code.
		CGRect b = self.contentView.bounds;
		b.size.width -= 2;
		mapImageView = [[UIImageView alloc] initWithFrame:b];
		
		[self.contentView addSubview:mapImageView];
		[mapImageView setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
		[mapImageView setUserInteractionEnabled:NO];
		[mapImageView release];
		mapImageView.layer.cornerRadius = 9;
		[mapImageView.layer setMasksToBounds:YES];
		[self setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    return self;
}

- (void)didDownloadOperation:(DownloadOperation*)queue userInfo:(NSDictionary*)userInfo {
	UIImage *img = [userInfo objectForKey:@"image"];
	[mapImageView setImage:img];
	
	[indicator removeFromSuperview];
	indicator = nil;
}

- (void)failedDownloadOperation:(DownloadOperation*)queue {
	
	[indicator removeFromSuperview];
	indicator = nil;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];    
    // Configure the view for the selected state.
}

- (void)dealloc {
	[[DownloadQueue sharedInstance] removeQueuesForTarget:self];
    [super dealloc];
}


@end
