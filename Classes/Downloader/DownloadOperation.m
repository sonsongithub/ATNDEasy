//
//  DownloadOperation.m
//  ATNDEasy
//
//  Created by sonson on 10/11/06.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "DownloadOperation.h"


@implementation DownloadOperation

@synthesize target;

@synthesize request;
@synthesize response;
@synthesize result;
@synthesize resultError;
@synthesize contentLength;
@synthesize needsOfflineError;
@synthesize needsDifferentError;

#pragma mark -
#pragma mark 

+ (id)operationFromURLRequest:(NSURLRequest*)URLRequest {
	DownloadOperation *queue = [[self alloc] init];
	queue.request = URLRequest;
	return [queue autorelease];
}

+ (id)operationFromURL:(NSURL*)url {
	DownloadOperation *queue = [[self alloc] init];
	NSURLRequest *request = [NSURLRequest requestWithURL:url];
	[queue setRequest:request];
	return [queue autorelease];
}

#pragma mark -
#pragma mark  Accessor

- (NSURL*)url {
	return [request URL];
}

#pragma mark -
#pragma mark 

- (id)init {
	if (self = [super init]) {
		needsOfflineError = YES;
		needsDifferentError = YES;
	}
	return self;
}

- (void)doTaskAfterDownloadingData:(NSData*)data {
	DNSLogMethod
	DNSLog(@"URL:%@", [self.url absoluteString]);
	DNSLog(@"Bytes:%d", [data length]);
}

- (void)doTaskAfterFailedDownload:(NSError*)error {
	DNSLogMethod
	DNSLog(@"URL:%@", [self.url absoluteString]);
	DNSLog(@"Error:%@", [error description]);
}

- (void)doTaskAfterReturnedDifferentURL {
	DNSLogMethod
	// Show network error alert message
	if (needsDifferentError) {
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil)
															message:NSLocalizedString(@"Different URL is returned. Maybe, data has been dropped.", nil)
														   delegate:nil 
												  cancelButtonTitle:nil 
												  otherButtonTitles:NSLocalizedString(@"OK", nil), nil];
		[alertView show];
		[alertView release];
	}
	
}

#pragma mark -
#pragma mark dealloc

- (void)dealloc {
	[response release];
	[target release];
	[request release];
	[resultError release];
	[super dealloc];
}

@end
