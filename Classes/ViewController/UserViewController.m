//
//  UserViewController.m
//  ATNDEasy
//
//  Created by sonson on 10/11/08.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "UserViewController.h"
#import "EventDetailViewController.h"
#import "DownloadQueue.h"
#import "ATNDEvent.h"

#import "UserInfoView.h"
#import "UIViewController+LongTitle.h"
#import "EventCell.h"

#import "WatchList.h"

@implementation UserViewController

@synthesize user;

#pragma mark -
#pragma mark Initialization

+ (UINavigationController*)controller {
	UserViewController *con = [[UserViewController alloc] init];
	UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:con];
	[con release];
	return [nav autorelease];
}

#pragma mark -
#pragma mark Override

- (id)init {
	self = [super initWithStyle:UITableViewStyleGrouped];
	if (self) {
		events = [[NSMutableArray array] retain];
		ownerEvents = [[NSMutableArray array] retain];
		
		ownerSection = 0;
		eventSection = 1;
	}
	return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	
	[self.navigationItem setBackBarButtonItem:[[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Back", nil) style:UIBarButtonItemStyleBordered target:nil action:nil] autorelease]];
	
	if (user == nil)
		return;
	
	UserInfoView *infoView = [[UserInfoView alloc] initWithFrame:CGRectMake(0, 0, 320, 80)];
	[infoView setUser:user];
	[infoView setDelegate:self];
	[self.tableView setTableHeaderView:infoView];
	[infoView release];
	
	NSString *nickname = nil;
	int userID = user.user_id;
	
	if (userID == 0) {
		nickname = user.nickname;
	}
	
	if (userID != 0) {
		if ([ownerEvents count] == 0) {
			ATNDOwnerIDSearchOperation *op = [ATNDOwnerIDSearchOperation operationWithOwnerIDSearch:userID start:1];
			[op setTarget:self];
			[[DownloadQueue sharedInstance] addQueue:op];
		}
		if ([events count] == 0) {
			ATNDIDSearchOperation *op = [ATNDIDSearchOperation operationWithIDSearch:userID start:1];
			[op setTarget:self];
			[[DownloadQueue sharedInstance] addQueue:op];
		}
	}
	else if (nickname != nil) {
		if ([ownerEvents count] == 0) {
			ATNDOwnerNicknameSearchOperation *op = [ATNDOwnerNicknameSearchOperation operationWithSearchNickname:nickname start:1];
			[op setTarget:self];
			[[DownloadQueue sharedInstance] addQueue:op];
		}
		if ([events count] == 0) {
			ATNDNicknameSearchOperation *op = [ATNDNicknameSearchOperation operationWithSearchNickname:nickname start:1];
			[op setTarget:self];
			[[DownloadQueue sharedInstance] addQueue:op];
		}
	}
	
	if ([events count] == 0 && [ownerEvents count] == 0) {
		[self showLoadingMessage];
	}
	
	[self setLongTitle:user.nickname];
	
	[self.tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
	[[DownloadQueue sharedInstance] removeAllQueue];
}

#pragma mark -
#pragma mark Instance method

- (void)rebuildTableInfo {
	
	if ([events count] > 0 && [ownerEvents count] > 0) {
		sections = 2;
		ownerSection = 0;
		eventSection = 1;
	}
	if ([events count] > 0 && [ownerEvents count] == 0) {
		sections = 1;
		eventSection = 0;
		ownerSection = -1;
	}
	if ([events count] == 0 && [ownerEvents count] > 0) {
		sections = 1;
		eventSection = -1;
		ownerSection = 0;
	}
	if ([events count] == 0 && [ownerEvents count] == 0) {
		sections = 0;
	}
}

- (void)appendNewEventsToBufferFromUserInfo:(NSDictionary*)userInfo {
	DNSLogMethod
	
	NSString *className = [userInfo objectForKey:@"kATNDOperationClassName"];
	
	if ([className isEqualToString:@"ATNDNicknameSearchOperation"]) {
		[events addObjectsFromArray:[userInfo objectForKey:kATNDIncommingEvent]];
	}
	else if ([className isEqualToString:@"ATNDOwnerNicknameSearchOperation"]) {
		[ownerEvents addObjectsFromArray:[userInfo objectForKey:kATNDIncommingEvent]];
	}
	else if ([className isEqualToString:@"ATNDIDSearchOperation"]) {
		[events addObjectsFromArray:[userInfo objectForKey:kATNDIncommingEvent]];
	}
	else if ([className isEqualToString:@"ATNDOwnerIDSearchOperation"]) {
		[ownerEvents addObjectsFromArray:[userInfo objectForKey:kATNDIncommingEvent]];
	}
	
	for (ATNDEvent *event in [events reverseObjectEnumerator]) {
		for (ATNDEvent *own in ownerEvents) {
			if (event.event_id == own.event_id) {
				[events removeObject:event];
				break;
			}
		}
	}
	[events sortUsingFunction:startedAtSort context:NULL];
	[ownerEvents sortUsingFunction:startedAtSort context:NULL];
}

#pragma mark -
#pragma mark UserInfoViewDelegate

- (void)didPushWatchButton:(UserInfoView*)sender {
	DNSLogMethod
	[[WatchList sharedInstance] addUser:user events:events ownEvents:ownerEvents];
}

#pragma mark -
#pragma mark DownloadOperationDelegate

- (void)didDownloadOperation:(DownloadOperation*)queue userInfo:(NSDictionary*)userInfo {

	[self appendNewEventsToBufferFromUserInfo:userInfo];
	
	[self rebuildTableInfo];
	
	[self.tableView reloadData];
	
	[self hideLoadingMessage];
}

- (void)failedDownloadOperation:(DownloadOperation*)queue {
	[self hideLoadingMessage];
}

- (void)failedDownloadOperation:(DownloadOperation*)queue userInfo:(NSDictionary*)userInfo {
	[self hideLoadingMessage];
}

#pragma mark -
#pragma mark UITableViewDelegate, UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return [EventCell height];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	// Return the number of rows in the section.
	if (section == eventSection) {
		if ([events count]) {
			return NSLocalizedString(@"Event", nil);
		}
		else
			return nil;
	}
	else if (section == ownerSection) {
		if ([ownerEvents count]) {
			return NSLocalizedString(@"Own event", nil);
		}
		else
			return nil;
	}
	return @"";
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
	return sections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	if (section == eventSection) {
		return [events count];
	}
	else if (section == ownerSection) {
		return [ownerEvents count];
	}
	return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"EventCell";
    
    EventCell *cell = (EventCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[EventCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		[cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }

	if (indexPath.section == eventSection) {
		ATNDEvent *event = [events objectAtIndex:indexPath.row];
		[cell setEvent:event];
	}
	else if (indexPath.section == ownerSection) {
		ATNDEvent *event = [ownerEvents objectAtIndex:indexPath.row];
		[cell setEvent:event];
	}
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
    
	ATNDEvent *event = nil;
	
	if (indexPath.section == eventSection) {
		event = [events objectAtIndex:indexPath.row];
	}
	else if (indexPath.section == ownerSection) {
		event = [ownerEvents objectAtIndex:indexPath.row];
	}
	
	EventDetailViewController *con = [[EventDetailViewController alloc] initWithStyle:UITableViewStyleGrouped];
	[event setUnread:NO];
	[con setEvent:event];
	[self.navigationController pushViewController:con animated:YES];
	[con release];
}

#pragma mark -
#pragma mark dealloc

- (void)dealloc {
	[user release];
	[events release];
	[ownerEvents release];
    [super dealloc];
}

@end

