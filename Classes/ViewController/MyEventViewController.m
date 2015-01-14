//
//  MyEventViewController.m
//  ATNDEasy
//
//  Created by sonson on 10/11/11.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MyEventViewController.h"
#import "InfoViewController.h"
#import "AppSettingsNavigationController.h"

@implementation MyEventViewController

#pragma mark -
#pragma mark Class method

+ (UINavigationController*)controller {
	MyEventViewController *con = [[MyEventViewController alloc] init];
	UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:con];
	[con release];
	return [nav autorelease];
}

#pragma mark -
#pragma mark Instance method

- (void)reload:(id)sender {
	NSString *nickname = [[NSUserDefaults standardUserDefaults] objectForKey:@"atnd_your_nickname"];
	
	[[DownloadQueue sharedInstance] removeAllQueue];
	
	if ([nickname length]) {
		{
			ATNDOwnerNicknameSearchOperation *op = [ATNDOwnerNicknameSearchOperation operationWithSearchNickname:nickname start:1];
			[op setTarget:self];
			[[DownloadQueue sharedInstance] addQueue:op];
		}
		{
			ATNDNicknameSearchOperation *op = [ATNDNicknameSearchOperation operationWithSearchNickname:nickname start:1];
			[op setTarget:self];
			[[DownloadQueue sharedInstance] addQueue:op];
		}
		[self showLoadingMessage];
	}
	else {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"MyEvent", nil)
														message:NSLocalizedString(@"Please fill in ATND nickname.", nil)
													   delegate:self
											  cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
											  otherButtonTitles:NSLocalizedString(@"OK", nil), nil];
		[alert show];
		[alert release];
	}
	
}

- (void)openInfo:(id)sender {
	UINavigationController *nav = [InfoViewController controllerWithNavigationController];
	[self presentModalViewController:nav animated:YES];
}

- (BOOL)saveCache {
	DNSLogMethod
	NSMutableData *data = [[NSMutableData alloc] init];
	NSKeyedArchiver *encoder = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
	
	[encoder encodeObject:events forKey:@"events"];
	[encoder encodeObject:ownerEvents forKey:@"ownerEvents"];
	[encoder finishEncoding];
	[encoder release];
	
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *dir = [documentsDirectory stringByAppendingPathComponent:@"cache"];
	NSString *plistPath = [dir stringByAppendingPathComponent:@"MyEventCache.plist"];
	
	[[NSFileManager defaultManager] createDirectoryAtPath:dir withIntermediateDirectories:YES attributes:nil error:nil];
	
	[data writeToFile:plistPath atomically:NO];
	[data release];
	
	return YES;
}

- (BOOL)loadCache {
	
	DNSLogMethod
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *dir = [documentsDirectory stringByAppendingPathComponent:@"cache"];
	NSString *plistPath = [dir stringByAppendingPathComponent:@"MyEventCache.plist"];
	
	
	if( [[NSFileManager defaultManager] fileExistsAtPath:plistPath] ) {
		NSData *data  = [NSData dataWithContentsOfFile:plistPath];
		NSKeyedUnarchiver *decoder = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
		
		NSArray *tmp1 = [decoder decodeObjectForKey:@"events"];
		NSArray *tmp2 = [decoder decodeObjectForKey:@"ownerEvents"];
		if (tmp1 != nil) {
			[events removeAllObjects];
			[events addObjectsFromArray:tmp1];
		}
		if (tmp2 != nil) {
			[ownerEvents removeAllObjects];
			[ownerEvents addObjectsFromArray:tmp2];
		}
		
		[decoder finishDecoding];
		[decoder release];
		return YES;
	}
	else {
		return NO;
	}
}

#pragma mark -
#pragma mark DownloadOperationDelegate

- (void)didDownloadOperation:(DownloadOperation*)queue userInfo:(NSDictionary*)userInfo {
	DNSLogMethod
	
	[events removeAllObjects];
	[ownerEvents removeAllObjects];
	
	[self appendNewEventsToBufferFromUserInfo:userInfo];
	
	[self rebuildTableInfo];
	[self saveCache];

	[self hideLoadingMessage];

	[self.tableView reloadData];	
}

#pragma mark -
#pragma mark Override

- (id)init {
	self = [super init];
	if (self) {
		[self setTitle:NSLocalizedString(@"MyEvent", nil)];
		UITabBarItem *item = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"MyEvent", nil) image:[UIImage imageNamed:@"you.png"] tag:0];
		[self setTabBarItem:item];
		[item release];
	}
	return self;
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
		
	[self setAdMakerAdToHeaderView];
	
	[self.navigationItem setBackBarButtonItem:[[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Back", nil) style:UIBarButtonItemStyleBordered target:nil action:nil] autorelease]];
	
	self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Info", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(openInfo:)] autorelease];
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(reload:)] autorelease];
	
	if (![self loadCache]) {
		[self reload:nil];
	}
	else {
		[self rebuildTableInfo];
		[self.tableView reloadData];
	}
}

#pragma mark -
#pragma mark UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
	if (buttonIndex == 1) {
		UINavigationController *nav = [AppSettingsNavigationController defaultController];
		[self presentModalViewController:nav animated:YES];
	}
}

@end

