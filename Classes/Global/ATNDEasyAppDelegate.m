//
//  ATNDEasyAppDelegate.m
//  ATNDEasy
//
//  Created by sonson on 10/11/06.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ATNDEasyAppDelegate.h"

#import "MyEventViewController.h"
#import "SearchViewController.h"
#import "WatchViewController.h"
#import "NotifyViewController.h"
#import "ConfirmEventViewController.h"
#import "BookmarkViewController.h"

#import "ATND.h"
#import "SQLiteDatabase+search.h"
#import "SQLiteDatabase+event.h"
#import "SQLiteDatabase+ImageCache.h"
#import "LocalNotificationController.h"
#import "WatchList.h"
#import "SKManager.h"

@implementation ATNDEasyAppDelegate

@synthesize window;
@synthesize tabBarController;

#pragma mark -
#pragma mark Instance method

- (void)openConfirmViewOnViewController:(UIViewController*)viewController notification:(UILocalNotification*)notification animated:(BOOL)animated {
	ATNDEvent *event = [ATNDEvent eventFromUserInfo:[notification.userInfo objectForKey:@"event"]];
	UINavigationController *con = [ConfirmEventViewController controller];
	ConfirmEventViewController *confirm = (ConfirmEventViewController *)[con topViewController];
	[confirm setEvent:event];
	[viewController presentModalViewController:con animated:animated];
}

- (void)didUpdatedNumberOfUnread:(NSNotification*)notification {
	DNSLogMethod
	
	UIViewController *con = [[tabBarController viewControllers] objectAtIndex:2];
	
	UITabBarItem *item = [con tabBarItem];
	NSString *value = [[notification userInfo] objectForKey:@"WatchListNumberOfUnread"];
	if ([value intValue])
		[item setBadgeValue:value];
	else 
		[item setBadgeValue:nil];
}

- (void)deleteSurplusTwitterIconCache {
	// read from file
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *dir = [documentsDirectory stringByAppendingPathComponent:@"twitterIcon"];
	
	unsigned long long fileSizeSum = 0;
	
	for (NSString *subpath in [[NSFileManager defaultManager] subpathsAtPath:dir]) {
		NSString *path = [dir stringByAppendingPathComponent:subpath];
		NSDictionary *attribute = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil];
		fileSizeSum += [[attribute objectForKey:NSFileSize] longLongValue];
	}
	
	if (fileSizeSum < TWITTER_CACHE_LIMIT_SIZE)
		return;
	
	unsigned long long bytesToBeDeleted = fileSizeSum - TWITTER_CACHE_LIMIT_SIZE;
	unsigned long long count = 0;
	
	for (NSString *subpath in [[NSFileManager defaultManager] subpathsAtPath:dir]) {
		NSString *path = [dir stringByAppendingPathComponent:subpath];
		DNSLog(@"%@", path);
		NSDictionary *attribute = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil];
		NSDate *date = [attribute objectForKey:NSFileModificationDate];
		DNSLog(@"%@", date);
		
		count += [[attribute objectForKey:NSFileSize] longLongValue];

		
		[[NSFileManager defaultManager] removeItemAtPath:path error:nil];
		
		if (count > bytesToBeDeleted)
			break;
	}
}

#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	DNSLogMethod
	
	[[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didUpdatedNumberOfUnread:) name:kWatchListUpdatedNumberOfUnread object:nil];
	
	// myEventViewController is declaredd here in order to present modal view controller on MyEventViewController.
	myEventViewController = [MyEventViewController controller];
	[tabBarController setViewControllers:[NSArray arrayWithObjects:myEventViewController, [SearchViewController controller], [WatchViewController controller], [NotifyViewController controller], nil]];

    // Add the tab bar controller's view to the window and display.
    [self.window addSubview:tabBarController.view];
    [self.window makeKeyAndVisible];

	// management local notification
	UILocalNotification *notification = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    if (notification) {
		[self openConfirmViewOnViewController:myEventViewController notification:notification animated:NO];
    }
	
	[[WatchList sharedInstance] updateNumberOfUnread];
	
    return YES;
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
	DNSLogMethod
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
	
	[[SQLiteDatabase sharedInstance] deleteSurplusOfExistingCache:@"staticMapCache"];
//	[[SQLiteDatabase sharedInstance] deleteSurplusOfExistingCache:@"twitterIconCache"];
	[self deleteSurplusTwitterIconCache];
}

- (void)applicationWillTerminate:(UIApplication *)application {
	
	[[SQLiteDatabase sharedInstance] deleteSurplusOfExistingCache:@"staticMapCache"];
//	[[SQLiteDatabase sharedInstance] deleteSurplusOfExistingCache:@"twitterIconCache"];
	[self deleteSurplusTwitterIconCache];
}

- (void)application:(UIApplication *)app didReceiveLocalNotification:(UILocalNotification *)notification {
	DNSLogMethod
	
	switch ([app applicationState]) {
		case UIApplicationStateActive:
			DNSLog(@"UIApplicationStateActive");
			NSString *message = [notification alertBody];
			UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Alarm", nil)
																message:message
															   delegate:self
													  cancelButtonTitle:NSLocalizedString(@"Discard", nil)
													  otherButtonTitles:NSLocalizedString(@"Open", nil), nil];
			[alertView show];
			[alertView release];
			backupNotification = [notification retain];
			break;
		case UIApplicationStateInactive:
			DNSLog(@"UIApplicationStateInactive");
			[self openConfirmViewOnViewController:[tabBarController selectedViewController] notification:notification animated:NO];
			break;
		default:
			break;
	}
}

#pragma mark -
#pragma mark UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
	DNSLogMethod
	if (buttonIndex == 0) {
		// push ignore
	}
	else if (buttonIndex == 1) {
		// push open
		[self openConfirmViewOnViewController:[tabBarController selectedViewController] notification:backupNotification animated:YES];
		[backupNotification release];
		backupNotification = nil;
	}
}

#pragma mark -
#pragma mark Memory warning

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
	DNSLogMethod
	id selected = (UINavigationController*)[tabBarController selectedViewController];
	for (id con in [tabBarController viewControllers]) {
		if (selected != con) {
			[con popToRootViewControllerAnimated:NO];
		}
	}
}

#pragma mark -
#pragma mark dealloc

- (void)dealloc {
    [tabBarController release];
    [window release];
    [super dealloc];
}

@end

