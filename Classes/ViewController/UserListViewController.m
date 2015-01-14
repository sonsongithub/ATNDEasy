//
//  UserListViewController.m
//  ATNDEasy
//
//  Created by sonson on 10/11/09.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "UserListViewController.h"

#import "DownloadQueue.h"
#import "UserViewController.h"
#import "UserCell.h"
#import "UIViewController+LongTitle.h"

@implementation UserListViewController

@synthesize event;

#pragma mark -
#pragma mark Initialization

- (id)init {
	self = [super initWithStyle:UITableViewStyleGrouped];
	if (self) {
		accepted = [[NSMutableArray array] retain];
		waiting = [[NSMutableArray array] retain];
	}
	return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	if ([accepted count] + [waiting count] == 0) {
		ATNDEventAttendance *op = [ATNDEventAttendance operationWithAttendanceEventID:event.event_id start:1];
		[op setTarget:self];
		[[DownloadQueue sharedInstance] addQueue:op];
	}
	[self setLongTitle:event.title];
	[self.navigationItem setBackBarButtonItem:[[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Back", nil) style:UIBarButtonItemStyleBordered target:nil action:nil] autorelease]];
}

- (void)viewWillDisappear:(BOOL)animated {
	[[DownloadQueue sharedInstance] removeAllQueue];
}

#pragma mark -
#pragma mark DownloadOperationDelegate

- (void)didDownloadOperation:(DownloadOperation*)queue userInfo:(NSDictionary*)userInfo {
	DNSLogMethod
	
	NSArray *users = [userInfo objectForKey:kATNDIncommingUser];
	
	for (ATNDUser *user in users) {
		if (user.status == ATNDUserAccepted) {
			[accepted addObject:user];
		}
		if (user.status == ATNDUserWaiting) {
			[waiting addObject:user];
		}
	}
	[self.tableView reloadData];
}

- (void)failedDownloadOperation:(DownloadOperation*)queue {
}

- (void)failedDownloadOperation:(DownloadOperation*)queue userInfo:(NSDictionary*)userInfo {
}

#pragma mark -
#pragma mark UITableViewDelegate, UITableViewDatasource

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	// Return the number of rows in the section.
	if (section == 0) {
		if ([accepted count]) {
			return NSLocalizedString(@"Accpeted", nil);
		}
		else
			return nil;
	}
	else if (section == 1) {
		if ([waiting count]) {
			return NSLocalizedString(@"Waiting", nil);
		}
		else
			return nil;
	}
	return @"";
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (section == 0)
		return [accepted count];
	if (section == 1)
		return [waiting count];
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UserCell *cell = (UserCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		[cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    
    // Configure the cell...
	if (indexPath.section == 0) {
		ATNDUser *user = [accepted objectAtIndex:indexPath.row];
		[cell setUser:user];
	}
	if (indexPath.section == 1) {
		ATNDUser *user = [waiting objectAtIndex:indexPath.row];
		[cell setUser:user];
	}
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	ATNDUser *user = nil;
	
	if (indexPath.section == 0) {
		user = [accepted objectAtIndex:indexPath.row];
	}
	else if (indexPath.section == 1) {
		user = [waiting objectAtIndex:indexPath.row];
	}
	
	UserViewController *controller = [[UserViewController alloc] init];
	[controller setUser:user];
	[self.navigationController pushViewController:controller animated:YES];
	[controller release];
	
}

#pragma mark -
#pragma mark dealloc

- (void)dealloc {
	[accepted release];
	[waiting release];
	[event release];
    [super dealloc];
}


@end

