//
//  QuerySuggestionViewController.m
//  ATNDEasy
//
//  Created by sonson on 10/11/15.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "QuerySuggestionViewController.h"

#import "SQLiteDatabase+search.h"

@implementation QuerySuggestionViewController

@synthesize delegate;

#pragma mark -
#pragma mark Initialization

- (id)init {
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
		queries = [[NSMutableArray array] retain];
		[self.tableView setAutoresizingMask:UIViewAutoresizingNone];
		[self.tableView setBackgroundColor:[UIColor colorWithRed:235.0/255.0 green:235.0/255.0 blue:235.0/255.0 alpha:1]];
    }
    return self;
}

- (void)setQuery:(NSString*)query {
	NSArray *incomming = [[SQLiteDatabase sharedInstance] candidatesWithQuery:query type:ATNDKeywordQuery];
	[queries removeAllObjects];
	[queries addObjectsFromArray:incomming];
	[self.tableView reloadData];
}

- (BOOL)shouldShow {
	return ([queries count] > 0);
}

#pragma mark -
#pragma mark UITableViewDelegate, UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [queries count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		[cell.contentView setBackgroundColor:[UIColor colorWithRed:235.0/255.0 green:235.0/255.0 blue:235.0/255.0 alpha:1]];
		[cell.textLabel setBackgroundColor:[UIColor colorWithRed:235.0/255.0 green:235.0/255.0 blue:235.0/255.0 alpha:1]];
    }
    
	[cell.textLabel setText:[queries objectAtIndex:indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSString *query = [queries objectAtIndex:indexPath.row];
	if ([delegate respondsToSelector:@selector(querySuggestionViewController:didSelectQuery:)]) {
		[delegate querySuggestionViewController:self didSelectQuery:query];
	}
}

#pragma mark -
#pragma mark dealloc

- (void)dealloc {
	[queries release];
    [super dealloc];
}

@end

