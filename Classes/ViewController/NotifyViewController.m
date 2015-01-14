//
//  NotifyViewController.m
//  ATNDEasy
//
//  Created by sonson on 10/11/18.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "NotifyViewController.h"

#import "EventCell.h"
#import "SQLiteDatabase+event.h"
#import "LocalNotificationController.h"
#import "EventDetailViewController.h"

@implementation NotifyViewController

#pragma mark -
#pragma mark Class method

+ (UINavigationController*)controller {
	NotifyViewController *con = [[NotifyViewController alloc] init];
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
		[self setTitle:NSLocalizedString(@"Notify", nil)];
		UITabBarItem *item = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"Notify", nil) image:[UIImage imageNamed:@"notify.png"] tag:0];
		[self setTabBarItem:item];
		[item release];
	}
	return self;
}


#pragma mark -
#pragma mark View lifecycle

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	[self setAdMakerAdToHeaderView];
	
	[events removeAllObjects];
	
	NSArray *incommingEvents = [[LocalNotificationController sharedInstance] scheduledEvents];
	[events addObjectsFromArray:incommingEvents];
	[events sortUsingFunction:startedAtSort context:NULL];
	[self.tableView reloadData];
	
	self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [events count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return [EventCell height];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"EventCell";
    
    EventCell *cell = (EventCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[EventCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		[cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
	
	ATNDEvent *event = [events objectAtIndex:indexPath.row];
	[cell setEvent:event];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source.
		ATNDEvent *event = [events objectAtIndex:indexPath.row];
		[[LocalNotificationController sharedInstance] cancelEvent:event];
		[events removeObject:event];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	ATNDEvent *event = nil;
	
	event = [events objectAtIndex:indexPath.row];
	
	EventDetailViewController *con = [[EventDetailViewController alloc] initWithStyle:UITableViewStyleGrouped];
	[con setEvent:event];
	[self.navigationController pushViewController:con animated:YES];
	[con release];
}

#pragma mark -
#pragma mark dealloc

- (void)dealloc {
	[events release];
    [super dealloc];
}

@end

