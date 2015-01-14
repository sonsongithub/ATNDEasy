//
//  SearchViewController.m
//  ATNDEasy
//
//  Created by sonson on 10/11/06.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SearchViewController.h"

#import "DownloadQueue.h"
#import "ATNDSearchOperation.h"
#import "ATNDEvent.h"
#import "EventDetailViewController.h"
#import "EventCell.h"
#import "QuerySuggestionViewController.h"
#import "SQLiteDatabase+search.h"

@implementation SearchViewController

#pragma mark -
#pragma mark Class method

+ (UINavigationController*)controller {
	SearchViewController *con = [[SearchViewController alloc] init];
	UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:con];
	[con release];
	return [nav autorelease];
}

#pragma mark -
#pragma mark Instance method

- (void)showQuerySuggestionView {
	if ([querySuggestionViewController shouldShow]) {
		
		DNSLogMethod
		[self.tableView setScrollEnabled:NO];
		[self.tableView setContentOffset:CGPointMake(0, 0)];
		[UIView beginAnimations:@"showQuerySuggestionView" context:nil];
		[querySuggestionViewController.tableView setAlpha:1];
		[UIView commitAnimations];
	}
}

- (void)hideQuerySuggestionView {
	[self.tableView setScrollEnabled:YES];
	[UIView beginAnimations:@"hideQuerySuggestionView" context:nil];
	[UIView setAnimationDidStopSelector:@selector(didHide)];
	[querySuggestionViewController.tableView setAlpha:0];
	[UIView commitAnimations];
}

- (void)search:(NSString*)query {
	[events removeAllObjects];
	[self.tableView reloadData];
	
	[[DownloadQueue sharedInstance] removeAllQueue];
	ATNDSearchOperation *op = [ATNDSearchOperation operationWithSearchKeyword:query start:1];
	[op setTarget:self];
	[[DownloadQueue sharedInstance] addQueue:op];
	[searchBar resignFirstResponder];
	[self hideQuerySuggestionView];
	[[SQLiteDatabase sharedInstance] insertOrUpdateWithQuery:query type:ATNDKeywordQuery];
	
	[self showLoadingMessage];
}

#pragma mark -
#pragma mark Override

- (id)init {
	self = [super initWithStyle:UITableViewStyleGrouped];
	if (self) {
		[self setTitle:NSLocalizedString(@"Search", nil)];
		searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
		[searchBar setDelegate:self];
		[searchBar setShowsCancelButton:YES];
		[searchBar setPlaceholder:NSLocalizedString(@"Search with keyword", nil)];
		events = [[NSMutableArray array] retain];
		
		UITabBarItem *item = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemSearch tag:0];
		[self setTabBarItem:item];
		[item release];
		
		querySuggestionViewController = [[QuerySuggestionViewController alloc] init];
		[querySuggestionViewController.tableView setAutoresizingMask:UIViewAutoresizingNone];
		[querySuggestionViewController.tableView setFrame:CGRectMake(0, 0, 320, 200)];
		[self.view addSubview:querySuggestionViewController.view];
		[querySuggestionViewController.tableView setAlpha:0];
		[querySuggestionViewController setDelegate:self];
		
	}
	return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	[self.navigationItem setTitleView:searchBar];
	[self.navigationItem setBackBarButtonItem:[[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Back", nil) style:UIBarButtonItemStyleBordered target:nil action:nil] autorelease]];
	
	if ([events count] == 0) {
		[searchBar becomeFirstResponder];
	}
}

- (void)viewWillDisppear:(BOOL)animated {
	[[DownloadQueue sharedInstance] removeAllQueue];
}

#pragma mark -
#pragma mark DownloadOperationDelegate

- (void)didDownloadOperation:(DownloadOperation*)queue userInfo:(NSDictionary*)userInfo {
	DNSLogMethod
	
	[events removeAllObjects];
	[events addObjectsFromArray:[userInfo objectForKey:kATNDIncommingEvent]];
	
	[self hideLoadingMessage];
	[events sortUsingFunction:startedAtSort context:NULL];
	[self.tableView reloadData];
}

- (void)failedDownloadOperation:(DownloadOperation*)queue {
	[self hideLoadingMessage];
}

- (void)failedDownloadOperation:(DownloadOperation*)queue userInfo:(NSDictionary*)userInfo {
	[self hideLoadingMessage];
}

#pragma mark -
#pragma mark QuerySuggestionViewDelegate

- (void)querySuggestionViewController:(QuerySuggestionViewController*)con didSelectQuery:(NSString*)query {
	[searchBar resignFirstResponder];
	[self hideQuerySuggestionView];
	[searchBar setText:query];
	
	[self search:query];
}

#pragma mark -
#pragma mark UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)asearchBar {
	DNSLogMethod
	
	[self search:asearchBar.text];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
	DNSLogMethod
	if ([searchText length]) {
		[querySuggestionViewController setQuery:searchText];
		[self showQuerySuggestionView];
	}
	else {
		[self hideQuerySuggestionView];
	}
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)asearchBar {
	DNSLogMethod
	[searchBar resignFirstResponder];
	[self hideQuerySuggestionView];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
	[searchBar resignFirstResponder];
}

#pragma mark -
#pragma mark UITableViewDelegate, UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return [EventCell height];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [events count];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	ATNDEvent *event = [events objectAtIndex:indexPath.row];
	
	EventDetailViewController *con = [[EventDetailViewController alloc] initWithStyle:UITableViewStyleGrouped];
	[event setUnread:NO];
	[con setEvent:event];
	[self.navigationController pushViewController:con animated:YES];
	[con release];
}

#pragma mark -
#pragma mark dealloc

- (void)dealloc {
	[querySuggestionViewController release];
	[events release];
	[searchBar release];
    [super dealloc];
}

@end

