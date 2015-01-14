//
//  InfoViewController.m
//  2tch
//
//  Created by sonson on 09/07/21.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "InfoViewController.h"
#import "NSBundle+2tch.h"
#import "LicenseViewController.h"
#import "AppSettingsNavigationController.h"
#import "SQLiteDatabase+history.h"
#import "SQLiteDatabase+search.h"
#import "SKManager.h"
#import "HUDView.h"
#import "SKProduct+Help.h"
#import "Reachability.h"
#import "WatchList.h"

NSString *kInfoViewTableUpdate = @"kInfoViewTableUpdate";

#define InfoViewControllerActionSheetContact			0
#define InfoViewControllerActionSheetDeleteHistory		1
#define InfoViewControllerActionSheetDeleteQuery		2

@implementation InfoViewController

#pragma mark -
#pragma mark Class method

+ (UINavigationController*)controllerWithNavigationController {
	InfoViewController* con = [[InfoViewController alloc] initWithStyle:UITableViewStyleGrouped];
	UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:con];
	[con release];
	return [nav autorelease];
}

#pragma mark -
#pragma mark Instance method

- (void)SKManagerStatusUpdated:(NSNotification*)notification {
	status = InfoViewSKOnline;
	[self.tableView reloadData];
}

- (void)deleteIconCache {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *dir = [documentsDirectory stringByAppendingPathComponent:@"twitterIcon"];
	
	for (NSString *subpath in [[NSFileManager defaultManager] subpathsAtPath:dir]) {
		NSString *pathToBeDeleted = [dir stringByAppendingPathComponent:subpath];
		DNSLog(@"%@", pathToBeDeleted);
		[[NSFileManager defaultManager] removeItemAtPath:pathToBeDeleted error:nil];
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView obtainCellForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSString *CellIdentifier = nil;
	UITableViewCellStyle style = UITableViewCellStyleDefault;
	UITextAlignment alignment = UITextAlignmentLeft;
	UITableViewCellSelectionStyle selectionStyle = UITableViewCellSelectionStyleBlue;
	UIColor *textColor = [UIColor blackColor];
	
	if (indexPath.section == 0) {
		if (indexPath.row < 3) {
			CellIdentifier = @"Attribute";
			style = UITableViewCellStyleValue1;
			alignment = UITextAlignmentLeft;
		}
		else {
			CellIdentifier = @"Centered";
			style = UITableViewCellStyleDefault;
			alignment = UITextAlignmentCenter;
		}
	}
	else if (indexPath.section == 1) {
		if (status == InfoViewSKOnline) {
			CellIdentifier = @"Attribute";
			style = UITableViewCellStyleValue1;
			alignment = UITextAlignmentLeft;
			selectionStyle = UITableViewCellSelectionStyleBlue;
		}
		else if (status == InfoViewSKLoading) {
			CellIdentifier = @"Loading";
			style = UITableViewCellStyleValue1;
			alignment = UITextAlignmentLeft;
			selectionStyle = UITableViewCellSelectionStyleBlue;
		}
		else {
			CellIdentifier = @"Centered";
			style = UITableViewCellStyleDefault;
			alignment = UITextAlignmentCenter;
			selectionStyle = UITableViewCellSelectionStyleNone;
		}
	}
	else if (indexPath.section == 2) {
		CellIdentifier = @"Centered";
		style = UITableViewCellStyleDefault;
		alignment = UITextAlignmentCenter;
		selectionStyle = UITableViewCellSelectionStyleBlue;
	}
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:style reuseIdentifier:CellIdentifier] autorelease];
		if ([CellIdentifier isEqualToString:@"Loading"]) {
			UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
			[cell.contentView addSubview:indicator];
			CGRect frame = indicator.frame;
			frame.origin.x = (int)(cell.contentView.frame.size.width - frame.size.width)/2;
			frame.origin.y = (int)(cell.contentView.frame.size.height - frame.size.height)/2;
			[indicator setFrame:frame];
			
			[indicator startAnimating];
			[indicator release];
		}
	}
	
	cell.textLabel.textAlignment = alignment;
	[cell.textLabel setTextColor:textColor];
	[cell setSelectionStyle:selectionStyle];
	return cell;
}

#pragma mark -
#pragma mark Button callback

- (void)doneButton:(id)sender {
	[self dismissModalViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark Reachability Notification

- (void)reachabilityChanged:(NSNotification*)note {
	DNSLogMethod
	
	Reachability* curReach = [note object];
	NetworkStatus networkStatus = [curReach currentReachabilityStatus];
	
	if (networkStatus != NotReachable) {
		[[SKManager sharedInstance] confirmValidItems];
	}
	else {
		status = InfoViewSKOffline;
	}
	[self.tableView reloadData];
}

#pragma mark -
#pragma mark Override

- (id)initWithStyle:(UITableViewStyle)style {
    if (self = [super initWithStyle:style]) {
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SKManagerStatusUpdated:) name:kSKManagerStatusUpdated object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SKManagerStatusUpdated:) name:kSKManagerProductPurchased object:nil];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
	DNSLogMethod
    [super viewWillAppear:animated];
	
	[[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(reachabilityChanged:) name: kReachabilityChangedNotification object: nil];
	
	if (![SKPaymentQueue canMakePayments]) {
		status = InfoViewSKInavailable;
	}
	else {
		hostReach = [[Reachability reachabilityWithHostName: @"itunes.apple.com"] retain];
		[hostReach startNotifier];
		status = InfoViewSKLoading;
	}
	
	self.title = NSLocalizedString(@"Info", nil);
	
	UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Done", nil) style:UIBarButtonItemStyleDone target:self action:@selector(doneButton:)];
	self.navigationItem.rightBarButtonItem = doneButton;
	[doneButton release];
	
	[self.tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

#pragma mark -
#pragma mark UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
	DNSLogMethod
	
	if (actionSheet.tag == InfoViewControllerActionSheetContact) {
		if (buttonIndex == 0) {
			// Push mail button
			DNSLog(@"Compose new mail");
			//
			// Mail composer
			//
			MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
			picker.mailComposeDelegate = self;
			
			//
			// Attach an image to the email
			//
			[picker setSubject:NSLocalizedString(@"[ATNDEasy contact] ", nil)];
			[picker setToRecipients:[NSArray arrayWithObject:NSLocalizedString(@"SupportMailAddress", nil)]];
			
			/*
			NSMutableString *body = [NSMutableString string];
			[body appendFormat:@"This is your iPhone's conditon and a private information. If you'd like to send your message without this information, remove the following system information."];
			[body appendFormat:@"\n\n%@ %@(r%@)\n", [NSBundle infoValueFromMainBundleForKey:@"CFBundleDisplayName"], [NSBundle infoValueFromMainBundleForKey:@"CFBundleVersion"], [NSBundle infoValueFromMainBundleForKey:@"CFBundleRevision"]];
			[body appendFormat:@"%@\n%@ %@", [[UIDevice currentDevice] model], [[UIDevice currentDevice] systemName], [[UIDevice currentDevice] systemVersion]];
			[picker setMessageBody:body isHTML:NO];
			*/
			[self presentModalViewController:picker animated:YES];
			[picker release];
		}
		else if (buttonIndex == 1) {
			// Push "open safari" button
			DNSLog(@"Open support site");
			NSURL *URL = [NSURL URLWithString:NSLocalizedString(@"WebSiteURL", nil)];
			[[UIApplication sharedApplication] openURL:URL];
		}
	}
	if (actionSheet.tag == InfoViewControllerActionSheetDeleteHistory) {
		DNSLog(@"%d", buttonIndex);
		if (buttonIndex == 0) {
			[[SQLiteDatabase sharedInstance] deleteAllHistory];
			[[WatchList sharedInstance] updateNumberOfUnread];
		}
	}
	if (actionSheet.tag == InfoViewControllerActionSheetDeleteQuery) {
		DNSLog(@"%d", buttonIndex);
		if (buttonIndex == 0) {
			[[SQLiteDatabase sharedInstance] deleteAllHistoryOfQuery];
		}
	}
}

#pragma mark -
#pragma mark MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error  {
	[self dismissModalViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark Table view methods

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	if (section == 0) {
		return NSLocalizedString(@"Application", nil);
	}
	if (section == 1) {
		if (status == InfoViewSKInavailable) {
			return NSLocalizedString( @"Add-on(Inavailable)", nil );
		}
		else
			return NSLocalizedString( @"Add-on", nil );
	}
	if (section == 2) {
		return NSLocalizedString( @"Setting", nil );
	}
	if (section == 3) {
		return NSLocalizedString( @"History", nil );
	}
	return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 4;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (section == 0) {
		return 5;
	}
	if (section == 1) {
		if (status == InfoViewSKLoading)
			return 1;
		if (status == InfoViewSKOffline)
			return 1;
		if (status == InfoViewSKOnline)
			return [[[SKManager sharedInstance] validItems] count];
	}
	if (section == 2) {
		return 1;
	}
	if (section == 3) {
		return 2;
	}
	return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self tableView:tableView obtainCellForRowAtIndexPath:indexPath];
    
	if (indexPath.section == 0) {
		if (indexPath.row == 0) {
			cell.textLabel.text = NSLocalizedString(@"Name", nil);
			cell.detailTextLabel.text = [NSBundle infoValueFromMainBundleForKey:@"CFBundleDisplayName"];
			cell.accessoryType = UITableViewCellAccessoryNone;
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
		}
		if (indexPath.row == 1) {
			cell.textLabel.text = NSLocalizedString(@"Version", nil);
#ifdef _DEBUG
			NSString *str = [NSString stringWithFormat:@"%@(r%@) Debug", [NSBundle infoValueFromMainBundleForKey:@"CFBundleVersion"], [NSBundle infoValueFromMainBundleForKey:@"CFBundleRevision"]];
#else
			NSString *str = [NSString stringWithFormat:@"%@(r%@)", [NSBundle infoValueFromMainBundleForKey:@"CFBundleVersion"], [NSBundle infoValueFromMainBundleForKey:@"CFBundleRevision"]];
#endif
			cell.detailTextLabel.text = str;
			cell.accessoryType = UITableViewCellAccessoryNone;
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
		}
		if (indexPath.row == 2) {
			cell.textLabel.text = NSLocalizedString(@"Copyright", nil);
			cell.detailTextLabel.text = NSLocalizedString(@"sonson", nil);
			cell.accessoryType = UITableViewCellAccessoryNone;
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
		}
		if (indexPath.row == 3) {
			cell.textLabel.text = NSLocalizedString(@"License", nil);
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		}
		
		if (indexPath.row == 4) {
			cell.textLabel.text = NSLocalizedString(@"Contact", nil);
			cell.accessoryType = UITableViewCellAccessoryNone;
		}
	}
	else if (indexPath.section == 1) {
		if (status == InfoViewSKOnline) {
			SKProduct *product = [[[SKManager sharedInstance] validItems] objectAtIndex:indexPath.row];
			if ([[SKManager sharedInstance] isPurchasedProductIdentifier:product.productIdentifier]) {
				[cell.textLabel setText:[product localizedTitle]];
				[cell.detailTextLabel setText:NSLocalizedString(@"already purchased", nil)];
				[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
			}
			else {
				[cell.textLabel setText:[product localizedTitle]];
				[cell.detailTextLabel setText:[product formattedPriceString]];
			}
		}
		else if (status == InfoViewSKLoading) {
		}
		else {
			[cell.textLabel setText:NSLocalizedString(@"Cannot connect AppStore", nil)];
			[cell.textLabel setTextColor:[UIColor lightGrayColor]];
		}
	}
	else if (indexPath.section == 2) {
		if (indexPath.row == 0) {
			cell.textLabel.text = NSLocalizedString( @"Open", nil );
			[cell.textLabel setTextAlignment:UITextAlignmentCenter];
			cell.accessoryType = UITableViewCellAccessoryNone;
		}
	}
	else if (indexPath.section == 3) {
		if (indexPath.row == 0) {
			cell.textLabel.text = NSLocalizedString( @"Delete history", nil );
			[cell.textLabel setTextAlignment:UITextAlignmentCenter];
			cell.accessoryType = UITableViewCellAccessoryNone;
		}
		if (indexPath.row == 1) {
			cell.textLabel.text = NSLocalizedString( @"Delete history of query", nil );
			[cell.textLabel setTextAlignment:UITextAlignmentCenter];
			cell.accessoryType = UITableViewCellAccessoryNone;
		}
	}
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:NO];
	
	if (indexPath.section == 0) {
		if (indexPath.row == 3) {
			// Clicked "License"
			LicenseViewController *controller = [LicenseViewController defaultController];
			[self.navigationController pushViewController:controller animated:YES];
		}
		if (indexPath.row == 4) {
			// Clicked "Contact"
			UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"Contact, please send unknown bugs or your feedback.", nil) 
															   delegate:self
													  cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
												 destructiveButtonTitle:nil
													  otherButtonTitles:NSLocalizedString(@"Mail with Mail.app", nil), NSLocalizedString(@"Open Site with Safari", nil), nil];
			[sheet showFromToolbar:self.navigationController.toolbar];
			[sheet release];
			sheet.tag = InfoViewControllerActionSheetContact;
		}
	}
	else if (indexPath.section == 1) {
		if (status == InfoViewSKOnline) {
			SKProduct *product = [[[SKManager sharedInstance] validItems] objectAtIndex:indexPath.row];
			if (![[SKManager sharedInstance] isPurchasedProductIdentifier:product.productIdentifier]) {
				[[SKManager sharedInstance] startToPurchaseProductWithIdentifier:product.productIdentifier];
			}
		}
	}
	else if (indexPath.section == 2) {
		if (indexPath.row == 0) {
			DNSLogMethod
			UINavigationController *nav = [AppSettingsNavigationController defaultController];
			[self presentModalViewController:nav animated:YES];
		}
	}
	else if (indexPath.section == 3) {
		if (indexPath.row == 0) {
			// deleting history
			UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"Are you sure to delete history", nil) 
															   delegate:self
													  cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
												 destructiveButtonTitle:NSLocalizedString(@"Delete", nil)
													  otherButtonTitles:nil];
			[sheet showFromToolbar:self.navigationController.toolbar];
			[sheet release];
			sheet.tag = InfoViewControllerActionSheetDeleteHistory;
		}
		if (indexPath.row == 1) {
			// deleting history of query
			UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"Are you sure to delete history of query", nil) 
															   delegate:self
													  cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
												 destructiveButtonTitle:NSLocalizedString(@"Delete", nil)
													  otherButtonTitles:nil];
			[sheet showFromToolbar:self.navigationController.toolbar];
			[sheet release];
			sheet.tag = InfoViewControllerActionSheetDeleteQuery;
		}
	}
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
	if (section == 1 && status == InfoViewSKOnline) {
		UIView *dummy = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 60)] autorelease];
		[dummy setBackgroundColor:[UIColor clearColor]];
		
		UILabel *label = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
		//[label setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
		[label setNumberOfLines:3];
		[label setTextAlignment:UITextAlignmentCenter];
		[label setBackgroundColor:[UIColor clearColor]];
	
		label.font = [UIFont systemFontOfSize:14];
		label.textColor = [UIColor colorWithRed:76.0/255.0 green:86.0/255.0 blue:108.0/255.0 alpha:1.0];
		label.shadowColor = [UIColor whiteColor];
		label.shadowOffset = CGSizeMake(0, 1);
		[label setText:NSLocalizedString(@"Will not be charged immediately. Confirmation will be shown before charging.", nil)];
		CGRect b =[label textRectForBounds:CGRectMake(0, 0, 280, 300) limitedToNumberOfLines:4];
		b.origin.x = (int)(dummy.frame.size.width - b.size.width)/2;
		b.origin.y = (int)(dummy.frame.size.height - b.size.height)/2;
		[label setFrame:b];
		[dummy addSubview:label];
		return dummy;
	}
	return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
	if (section == 1 && status == InfoViewSKOnline) {
		return 60;
	}
	return 0;
}

#pragma mark -
#pragma mark dealloc

- (void)dealloc {
	DNSLogMethod
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[hostReach release];
	[[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

@end

