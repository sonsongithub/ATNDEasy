//
//  DownloadOperation.h
//  ATNDEasy
//
//  Created by sonson on 10/11/06.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
	DownloadQueueDone = 0,
	DownloadQueueCancelled = 1,
	DownloadQueueError = 2
}DownloadManagerResult;

@class DownloadOperation;

@protocol DownloadOperationDelegate <NSObject>
@required
- (void)didDownloadOperation:(DownloadOperation*)queue userInfo:(NSDictionary*)userInfo;
- (void)failedDownloadOperation:(DownloadOperation*)queue;
@optional
- (void)failedDownloadOperation:(DownloadOperation*)queue userInfo:(NSDictionary*)userInfo;
@end


@interface DownloadOperation : NSObject {
	id						target;
	NSURLRequest			*request;
	NSURLResponse			*response;
	DownloadManagerResult	result;
	NSError					*resultError;
	int						contentLength;
	BOOL					needsOfflineError;
	BOOL					needsDifferentError;
}

@property (nonatomic, retain) id<DownloadOperationDelegate>target;
@property (nonatomic, readonly) NSURL *url;
@property (nonatomic, retain) NSURLResponse *response;
@property (nonatomic, retain) NSURLRequest *request;
@property (nonatomic, assign) DownloadManagerResult result;
@property (nonatomic, retain) NSError *resultError;
@property (nonatomic, assign) int contentLength;
@property (nonatomic, assign) BOOL needsOfflineError;
@property (nonatomic, assign) BOOL needsDifferentError;

+ (id)operationFromURL:(NSURL*)URL;
+ (id)operationFromURLRequest:(NSURLRequest*)URLRequest;

- (void)doTaskAfterDownloadingData:(NSData*)data;
- (void)doTaskAfterReturnedDifferentURL;
- (void)doTaskAfterFailedDownload:(NSError*)error;

@end

