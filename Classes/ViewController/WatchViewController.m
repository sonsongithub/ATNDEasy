//
//  WatchViewController.m
//  ATNDEasy
//
//  Created by sonson on 10/11/06.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "WatchViewController.h"

#import "ATND.h"
#import "WatchList.h"
#import "UserCell.h"
#import "UserViewController.h"

@implementation WatchViewController

#pragma mark -
#pragma mark Class method

+ (UINavigationController*)controller {
	WatchViewController *con = [[WatchViewController alloc] init];
	UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:con];
	[con release];
	return [nav autorelease];
}

#pragma mark -
#pragma mark Instance method

- (void)reload:(id)sender {
	for (ATNDUser *user in [[WatchList sharedInstance] watchList]) {
		{
			ATNDOwnerIDSearchOperation *op = [ATNDOwnerIDSearchOperation operationWithOwnerIDSearch:user.user_id start:1];
			[op setTarget:self];
			[[DownloadQueue sharedInstance] addQueue:op];
		}
		{
			ATNDIDSearchOperation *op = [ATNDIDSearchOperation operationWithIDSearch:user.user_id start:1];
			[op setTarget:self];
			[[DownloadQueue sharedInstance] addQueue:op];
		}
	}
	UIView *dummy = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
	progress = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
	[progress setFrame:CGRectMake(0, 17, 320, 44)];
	[progress setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
	checkCounter = [[DownloadQueue sharedInstance].queueStack count];
	[self.navigationItem setTitleView:dummy];
	[dummy addSubview:progress];
	[progress release];
	[dummy release];
	[self.navigationItem setLeftBarButtonItem:[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)] autorelease]];
}

- (void)cancel:(id)sender {
	[self.navigationItem setTitleView:nil];
	[[DownloadQueue sharedInstance] removeAllQueue];
	[self setTitle:NSLocalizedString(@"Watch", nil)];
	[self.navigationItem setLeftBarButtonItem:[[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Check", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(reload:)] autorelease]];
}

#pragma mark -
#pragma mark Override

- (id)init {
	self = [super initWithStyle:UITableViewStyleGrouped];
	if (self) {
		[self setTitle:NSLocalizedString(@"Watch", nil)];
		UITabBarItem *item = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"Watch", nil) image:[UIImage imageNamed:@"watch.png"] tag:0];
		[self setTabBarItem:item];
		[item release];
	}
	return self;
}

- (void)viewWillAppear:(BOOL)animated {
	[self setAdMakerAdToHeaderView];
    [super viewWillAppear:animated];
	[[WatchList sharedInstance] updateNumberOfUnread];
	[self.navigationItem setRightBarButtonItem:self.editButtonItem];
	[self.tableView reloadData];
	[self.navigationItem setBackBarButtonItem:[[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Back", nil) style:UIBarButtonItemStyleBordered target:nil action:nil] autorelease]];
	[self.navigationItem setLeftBarButtonItem:[[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Check", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(reload:)] autorelease]];
}

- (void)viewWillDisappear:(BOOL)animated {
	[[DownloadQueue sharedInstance] removeAllQueue];
	[self.navigationItem setTitleView:nil];
	[self setTitle:NSLocalizedString(@"Watch", nil)];
	[self.navigationItem setLeftBarButtonItem:[[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Check", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(reload:)] autorelease]];
	checkCounter = 0;
}

- (void)checkIfCheckingHasFinished {
	if ([[DownloadQueue sharedInstance].queueStack count] == 1) {
		[self.navigationItem setTitleView:nil];
		[self setTitle:NSLocalizedString(@"Watch", nil)];
		[self.navigationItem setLeftBarButtonItem:[[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Check", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(reload:)] autorelease]];
		checkCounter = 0;
	}
	else {
		[progress setProgress:(float)(checkCounter - [[DownloadQueue sharedInstance].queueStack count])/checkCounter];
	}
}

#pragma mark -
#pragma mark DownloadOperationDelegate

- (void)didDownloadOperation:(DownloadOperation*)queue userInfo:(NSDictionary*)userInfo {
	DNSLogMethod
	
	if ([queue isKindOfClass:[ATNDIDSearchOperation class]]) {
		ATNDIDSearchOperation *p = (ATNDIDSearchOperation*)queue;
		
		for (ATNDUser *user in [[WatchList sharedInstance] watchList]) {
			if (user.user_id == p.userID) {
				NSString *className = [userInfo objectForKey:@"kATNDOperationClassName"];
				if ([className isEqualToString:@"ATNDIDSearchOperation"]) {
					[user.events removeAllObjects];
					[user.events addObjectsFromArray:[userInfo objectForKey:kATNDIncommingEvent]];
				}
				break;
			}
		}
	}
	[[WatchList sharedInstance] updateNumberOfUnread];
	[self.tableView reloadData];
	[self checkIfCheckingHasFinished];
}

- (void)failedDownloadOperation:(DownloadOperation*)queue {
	[self checkIfCheckingHasFinished];
}

- (void)failedDownloadOperation:(DownloadOperation*)queue userInfo:(NSDictionary*)userInfo {
	[self checkIfCheckingHasFinished];
}

#pragma mark -
#pragma mark UITableViewDelegate, UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[[WatchList sharedInstance] watchList] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UserCell *cell = (UserCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		[cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
	ATNDUser *user = [[[WatchList sharedInstance] watchList] objectAtIndex:indexPath.row];
	[cell setUser:user];
	
	return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
		[[[WatchList sharedInstance] watchList] removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
		[[WatchList sharedInstance] updateNumberOfUnread];
    }
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
	ATNDUser *user = [[[WatchList sharedInstance] watchList] objectAtIndex:fromIndexPath.row];
	[user retain];
	[[[WatchList sharedInstance] watchList] removeObjectAtIndex:fromIndexPath.row];
	[[[WatchList sharedInstance] watchList] insertObject:user atIndex:toIndexPath.row];
	[user release];
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	UserViewController *controller = [[UserViewController alloc] init];
	ATNDUser *user = [[[WatchList sharedInstance] watchList] objectAtIndex:indexPath.row];
	[controller setUser:user];
	[self.navigationController pushViewController:controller animated:YES];
	[controller release];
}

#pragma mark -
#pragma mark dealloc

- (void)dealloc {
    [super dealloc];
}

@end

