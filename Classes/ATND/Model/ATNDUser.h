//
//  ATNDUser.h
//  ATNDEasy
//
//  Created by sonson on 10/11/08.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
	ATNDUserWaiting = 0,
	ATNDUserAccepted = 1,
}ATNDUserStatus;

@interface ATNDUser : NSObject {
	NSString			*nickname;
	NSString			*twitter_id;
	NSString			*twitter_img;
	
	ATNDUserStatus		status;
	int					user_id;
	
	UIImage				*twitterIcon;
	
	NSMutableArray		*events;
	NSMutableArray		*ownEvents;
	
	int					numberOfUnread;
}
@property (nonatomic, retain) NSString	*nickname;
@property (nonatomic, retain) NSString	*twitter_id;
@property (nonatomic, retain) NSString	*twitter_img;
@property (nonatomic, assign) ATNDUserStatus status;
@property (nonatomic, assign) int		user_id;
@property (nonatomic, retain) UIImage	*twitterIcon;
@property (nonatomic, retain) NSMutableArray *events;
@property (nonatomic, retain) NSMutableArray *ownEvents;
@property (nonatomic, assign) int numberOfUnread;
+ (ATNDUser*)userFromDictionary:(NSDictionary*)dictionary;
- (void)updateNumberOfUnreads;
@end
