//
//  DownloadQueue.h
//  ATNDEasy
//
//  Created by sonson on 10/11/06.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DownloadOperation;

@interface DownloadQueue : NSObject {	
	NSMutableArray	*queueStack;
	NSURLConnection	*downloader;
	NSMutableData	*downloadData;
}
@property (nonatomic, retain) NSMutableArray* queueStack;
@property (nonatomic, retain) NSMutableData* downloadData;
@property (nonatomic, retain) NSURLConnection* downloader;

+ (DownloadQueue*)sharedInstance;
- (void)addQueue:(DownloadOperation*)queue;
- (void)addToTailQueue:(DownloadOperation*)queue;
- (void)removeAllQueue;
- (void)removeQueuesForTarget:(id)target;

@end
