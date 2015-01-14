//
//  ConfirmEventViewController.m
//  ATNDEasy
//
//  Created by sonson on 10/11/18.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ConfirmEventViewController.h"
#import "UIViewController+LongTitle.h"
#import "LocalNotificationController.h"

@implementation ConfirmEventViewController


#pragma mark -
#pragma mark Class method

+ (UINavigationController*)controller {
	ConfirmEventViewController *con = [[ConfirmEventViewController alloc] init];
	UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:con];
	[con release];
	return [nav autorelease];
}

#pragma mark -
#pragma mark Instance method

- (void)notify:(id)sender {
}

- (void)done:(id)sender {
	[self dismissModalViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark UITableViewDelegate, UITableviewDatasource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
	[cell setAccessoryType:UITableViewCellAccessoryNone];
	
	if (indexPath.section == memberSection) {
		[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
	}
	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	if (indexPath.section == descriptionSection) {
		if (indexPath.row == 1) {
			isExpandedDescription = !isExpandedDescription;
			[self.tableView reloadData];
		}
	}
	if (indexPath.section == safariSection) {
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:event.event_url]];
	}
}

#pragma mark -
#pragma mark Override

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	
	[self setLongTitle:event.title];
	[self.navigationItem setRightBarButtonItem:[[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Done", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(done:)] autorelease]];
//	[self.navigationItem setLeftBarButtonItem:[[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Notify", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(notify:)] autorelease]];
}

- (void)dealloc {
    [super dealloc];
}

@end

