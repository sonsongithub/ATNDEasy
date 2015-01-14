//
//  MyTableViewController.m
//  ATNDEasy
//
//  Created by ; on 10/11/15.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MyTableViewController.h"

#import "YieldMakerView.h"
#import "SKManager.h"

#import <Accelerate/Accelerate.h>

@implementation MyTableViewController

- (void)setAdMakerAdToHeaderView {
	if ([[NSUserDefaults standardUserDefaults] boolForKey:HIDE_ADV_IDENTIFIER]) {
		[self.tableView setTableHeaderView:nil];
	}
	else {
		if (self.tableView.tableHeaderView == nil) {
			YieldMakerView *lwebview = [[YieldMakerView alloc]initWithFrame:CGRectMake(0,410,320,50)];
			[lwebview setUrl:@"http://images.ad-maker.info/apps/i3ir3kmvxg1n.html"];
			[lwebview start];
			[self.tableView setTableHeaderView:lwebview];
			[lwebview release];
		}
	}
}

- (void)showLoadingMessage {
	
	// hide previous message
	[self hideLoadingMessage];
	
	float fontSize = 18;
	float margin = 5;
	
	// view
	loadingView = [[UIView alloc] initWithFrame:CGRectZero];
	CGRect rect = CGRectZero;
	
	// indicator
	UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
	CGRect indicRect = indicator.frame;
	[loadingView addSubview:indicator];
	[indicator startAnimating];
	[indicator release];
	
	// label
	UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
	[label setText:NSLocalizedString(@"Loading...", nil)];
	[label setBackgroundColor:[UIColor clearColor]];
	[label setFont:[UIFont boldSystemFontOfSize:fontSize]];
	[label setTextColor:[UIColor colorWithRed:76.0/255.0 green:86.0/255.0 blue:108.0/255.0 alpha:1]];
	[label setShadowColor:[UIColor whiteColor]];
	[label setShadowOffset:CGSizeMake(0, 1)];
	CGRect labelRect = [label textRectForBounds:CGRectMake(0, 0, 200, fontSize*1.5) limitedToNumberOfLines:1];
	[loadingView addSubview:label];
	[label release];
	
	// view
	rect.size.width = indicRect.size.width + margin + labelRect.size.width;
	rect.size.height = indicRect.size.height > labelRect.size.height ? indicator.frame.size.height : labelRect.size.height;
	rect.origin.x = (int)(self.tableView.frame.size.width - rect.size.width)/2;
	rect.origin.y = (int)(self.tableView.frame.size.height - rect.size.height)/2;
	[loadingView setFrame:rect];
	
	// indicator
	indicRect.origin.x = 0;
	indicRect.origin.y = (int)(rect.size.height - indicRect.size.height)/2 + 1;
	[indicator setFrame:indicRect];
	
	// label
	labelRect.origin.x = indicRect.size.width + margin;
	labelRect.origin.y = (int)(rect.size.height - labelRect.size.height)/2;
	[label setFrame:labelRect];
	
	[self.tableView addSubview:loadingView];
	[loadingView release];
	
	[self.tableView setScrollEnabled:NO];
}

- (void)hideLoadingMessage {
	[loadingView removeFromSuperview];
	loadingView = nil;
	[self.tableView setScrollEnabled:YES];
}

- (id)initWithStyle:(UITableViewStyle)style {
	self = [super initWithStyle:style];
	if (self) {
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setAdMakerAdToHeaderView) name:kSKManagerProductPurchased object:nil];
	}
	return self;
}

- (id)init {
	self = [super initWithStyle:UITableViewStyleGrouped];
	if (self) {
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setAdMakerAdToHeaderView) name:kSKManagerProductPurchased object:nil];
	}
	return self;
}

@end

