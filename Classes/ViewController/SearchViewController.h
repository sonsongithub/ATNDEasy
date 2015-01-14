//
//  SearchViewController.h
//  ATNDEasy
//
//  Created by sonson on 10/11/06.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MyTableViewController.h"
#import "DownloadOperation.h"
#import "QuerySuggestionViewController.h"

@interface SearchViewController : MyTableViewController <UISearchBarDelegate, DownloadOperationDelegate, QuerySuggestionViewDelegate> {
	UISearchBar						*searchBar;
	NSMutableArray					*events;
	QuerySuggestionViewController	*querySuggestionViewController;
}
+ (UINavigationController*)controller;
@end
