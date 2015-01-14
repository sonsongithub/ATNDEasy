//
//  QuerySuggestionViewController.h
//  ATNDEasy
//
//  Created by sonson on 10/11/15.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MyTableViewController.h"

@class QuerySuggestionViewController;

@protocol QuerySuggestionViewDelegate <NSObject>
- (void)querySuggestionViewController:(QuerySuggestionViewController*)con didSelectQuery:(NSString*)query;
@end

@interface QuerySuggestionViewController : MyTableViewController {
	NSMutableArray *queries;
	id <QuerySuggestionViewDelegate> delegate;
}
@property (nonatomic, assign) id <QuerySuggestionViewDelegate> delegate;
- (void)setQuery:(NSString*)query;
- (BOOL)shouldShow;
@end
