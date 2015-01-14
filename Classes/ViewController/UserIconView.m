//
//  UserIconView.m
//  ATNDEasy
//
//  Created by sonson on 10/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "UserIconView.h"

#import "NSString+digest.h"
#import "DownloadQueue.h"
#import "UIImage+OptimizedPNG.h"

#import "TwitterIconDownloadOperation.h"
#import "SQLiteDatabase+twitterIconCache.h"

@implementation UserIconView

@synthesize user, cornerRadius;

#pragma mark -
#pragma mark Instance method

- (void)roundCornerPath:(CGRect)rect radius:(float)radius {
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	// get points
	CGFloat minx = CGRectGetMinX( rect ), midx = CGRectGetMidX( rect ), maxx = CGRectGetMaxX( rect );
	CGFloat miny = CGRectGetMinY( rect ), midy = CGRectGetMidY( rect ), maxy = CGRectGetMaxY( rect );
	
	CGContextMoveToPoint(context, minx, midy);
	CGContextAddArcToPoint(context, minx, miny, midx, miny, radius);
	CGContextAddArcToPoint(context, maxx, miny, maxx, midy, radius);
	CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius);
	CGContextAddArcToPoint(context, minx, maxy, minx, midy, radius);
	CGContextClosePath(context);
}

- (void)reloadIcon {
	if ([user.twitter_img length]) {

#define _USE_SQLITE_TWITTER_ICON_DATEUPDATE
		
#ifdef _USE_SQLITE_TWITTER_ICON
		NSString *hash = [user.twitter_img MD5DigestString];
		NSData *binary = nil;
		float scale = 0;
		
		DNSLog(@"load====================>%@", hash);
		
		[[SQLiteDatabase sharedInstance] selectTwitterIconCache:&binary scale:&scale hash:hash];
		
#else
		// read from file
		NSString *imgFileName = [user.twitter_img MD5DigestString];
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *documentsDirectory = [paths objectAtIndex:0];
		NSString *dir = [documentsDirectory stringByAppendingPathComponent:@"twitterIcon"];
		NSString *path = [dir stringByAppendingPathComponent:imgFileName];
		NSData *binary = [NSData dataWithContentsOfFile:path];
#endif
		if (binary) {
#ifdef _USE_SQLITE_TWITTER_ICON
	#ifdef _USE_SQLITE_TWITTER_ICON_DATEUPDATE
	 		[[SQLiteDatabase sharedInstance] updateTwitterIconCacheDateWithHash:hash];
	#endif
#endif
			UIImage *image = [UIImage imageWithData:binary];
			[user setTwitterIcon:image];
			[indicator setHidden:YES];
			[indicator stopAnimating];
		}
		else {
			TwitterIconDownloadOperation *op = [TwitterIconDownloadOperation operationFromURL:[NSURL URLWithString:user.twitter_img]];
			[op setTarget:self];
			[[DownloadQueue sharedInstance] addQueue:op];
			[indicator setHidden:NO];
			[indicator startAnimating];
		}
	}
	else {
		[indicator setHidden:YES];
		[indicator stopAnimating];
	}
}

- (void)setUser:(ATNDUser *)newValue {
	if ([user twitterIcon] == nil && [[user twitter_img] length]) {
		[[DownloadQueue sharedInstance] removeQueuesForTarget:self];
	}
	if (user != newValue) {
		[user release];
		user = [newValue retain];
		[self reloadIcon];
		[self setNeedsDisplay];
	}
}

#pragma mark -
#pragma mark DownloadOperationDelegate

- (void)didDownloadOperation:(DownloadOperation*)queue userInfo:(NSDictionary*)userInfo {
	DNSLogMethod
	
	[indicator setHidden:YES];
	[indicator stopAnimating];
#ifdef _USE_SQLITE_TWITTER_ICON
	NSData *data = [userInfo objectForKey:kTwitterIconOptimizedImage];
	NSURL *url = [userInfo objectForKey:kTwitterIconURL];
	NSString *hash = [[url absoluteString] MD5DigestString];
	float scale = 1;
	
	DNSLog(@"write====================>%@", hash);
	
	[[SQLiteDatabase sharedInstance] insertTwitterIconCache:data scale:scale hash:hash];

#else
	// save into file
	NSData *data = [userInfo objectForKey:kTwitterIconOptimizedImage];
	NSURL *url = [userInfo objectForKey:kTwitterIconURL];
	
	NSString *imgFileName = [[url absoluteString] MD5DigestString];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *dir = [documentsDirectory stringByAppendingPathComponent:@"twitterIcon"];
	NSString *path = [dir stringByAppendingPathComponent:imgFileName];
	
	
	// save image file
	[[NSFileManager defaultManager] createDirectoryAtPath:dir withIntermediateDirectories:YES attributes:nil error:nil];
	[data writeToFile:path atomically:NO];
#endif	
	
	UIImage *image = [UIImage imageWithData:data];
	[user setTwitterIcon:image];

	[self setNeedsDisplay];
}

- (void)failedDownloadOperation:(DownloadOperation*)queue {
	[indicator setHidden:YES];
	[indicator stopAnimating];
}

- (void)failedDownloadOperation:(DownloadOperation*)queue userInfo:(NSDictionary*)userInfo {
	[indicator setHidden:YES];
	[indicator stopAnimating];
}

#pragma mark -
#pragma mark Override

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
		[self setBackgroundColor:[UIColor clearColor]];
		indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		[self addSubview:indicator];
		CGRect b = indicator.bounds;
		b.origin.x = (int)(self.bounds.size.width - indicator.bounds.size.width)/2;
		b.origin.y = (int)(self.bounds.size.height - indicator.bounds.size.height)/2;
		[indicator setFrame:b];
		[indicator release];
		[indicator setHidden:YES];
		
		cornerRadius = 10;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	if ([user.twitter_img length]) {
		
		if (user.twitterIcon) {
			CGContextSaveGState(context);
			[self roundCornerPath:rect radius:cornerRadius];
			CGContextClosePath(context);
			CGContextClip(context);
			[user.twitterIcon drawInRect:rect];
			CGContextRestoreGState(context);
		}
		else {
			CGContextSaveGState(context);
			CGContextSetRGBFillColor(context, 1, 1, 1, 1);
			[self roundCornerPath:rect radius:cornerRadius];
			CGContextClosePath(context);
			CGContextFillPath(context);
			CGContextRestoreGState(context);
		}
		[[UIColor lightGrayColor] setStroke];
		CGContextSetLineWidth(context, 1);
		[self roundCornerPath:rect radius:cornerRadius];
		CGContextDrawPath(context, kCGPathStroke);
	}
	else {
		CGContextSaveGState(context);
		[self roundCornerPath:rect radius:cornerRadius];
		CGContextClosePath(context);
		CGContextClip(context);
		[[UIImage imageNamed:@"noPicture@2x.png"] drawInRect:rect];
		CGContextRestoreGState(context);
		
		[[UIColor lightGrayColor] setStroke];
		[self roundCornerPath:rect radius:cornerRadius];
		CGContextSetLineWidth(context, 1);
		CGContextDrawPath(context, kCGPathStroke);
	}
}

#pragma mark -
#pragma mark dealloc

- (void)dealloc {
	DNSLogMethod
	[[DownloadQueue sharedInstance] removeQueuesForTarget:self];
	[user release];
    [super dealloc];
}


@end
