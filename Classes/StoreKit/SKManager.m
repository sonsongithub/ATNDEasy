//
//  SKManager.m
//  ATNDEasy
//
//  Created by sonson on 10/11/25.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SKManager.h"

#import "HUDView.h"
#import "SKProduct+Help.h"

SKManager *sharedSKManager = nil;

NSString *kSKManagerStatusUpdated = @"kSKManagerStatusUpdated";
NSString *kSKManagerProductPurchased = @"kSKManagerProductPurchased";

@interface SKManager(Private)
- (void)setupProductWithIdentifier:(NSString*)identifier;
- (void)completeTransaction:(SKPaymentTransaction*)transaction;
- (void)restoreTransaction:(SKPaymentTransaction*)transaction;
- (void)failedTransaction:(SKPaymentTransaction*)transaction;
@end

@implementation SKManager(Private)

- (void)setupProductWithIdentifier:(NSString*)identifier {
	if ([identifier isEqualToString:HIDE_ADV_IDENTIFIER]) {
		[[NSUserDefaults standardUserDefaults] setBool:YES forKey:identifier];
		[[NSUserDefaults standardUserDefaults] synchronize];
	}
}

- (void)completeTransaction: (SKPaymentTransaction *)transaction {
	[self setupProductWithIdentifier:transaction.payment.productIdentifier];
	[[NSNotificationCenter defaultCenter] postNotificationName:kSKManagerStatusUpdated object:nil userInfo:nil];
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}

- (void)restoreTransaction:(SKPaymentTransaction *)transaction {
	[self setupProductWithIdentifier:transaction.payment.productIdentifier];
	[[NSNotificationCenter defaultCenter] postNotificationName:kSKManagerStatusUpdated object:nil userInfo:nil];
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}

- (void)failedTransaction: (SKPaymentTransaction *)transaction {
    if (transaction.error.code != SKErrorPaymentCancelled) {
        // Optionally, display an error here.
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil)
														message:[[transaction error] localizedDescription]
													   delegate:nil
											  cancelButtonTitle:nil
											  otherButtonTitles:NSLocalizedString(@"OK", nil), nil];
		[alert show];
		[alert release];
    }
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}

@end

@implementation SKManager

@synthesize validItems;

#pragma mark -
#pragma mark Class method

+ (SKManager*)sharedInstance {
	if (sharedSKManager == nil) {
		sharedSKManager = [[SKManager alloc] init];
	}
	return sharedSKManager;
}

#pragma mark -
#pragma mark Instance method

- (void)startToPurchaseProductWithIdentifier:(NSString*)identifier {
	DNSLogMethod
	
	[hud release];
	hud = [HUDView showHUDViewWithMessage:NSLocalizedString(@"Loading...", nil)];
	
	SKPayment *payment = [SKPayment paymentWithProductIdentifier:identifier];
	[[SKPaymentQueue defaultQueue] addPayment:payment];
}

- (BOOL)isPurchasedProductIdentifier:(NSString*)identifier {
	return [[NSUserDefaults standardUserDefaults] boolForKey:identifier];
}

- (void)confirmValidItems {
	NSSet *set = [NSSet setWithObjects:HIDE_ADV_IDENTIFIER, nil];
	SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:set];
	[request setDelegate:self];
	[request start];
	[request release];
}

#pragma mark -
#pragma mark SKPaymentTransactionObserver

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions {
	DNSLogMethod
    for (SKPaymentTransaction *transaction in transactions) {
		DNSLog(@"%@", transaction.payment.productIdentifier);
        switch (transaction.transactionState) {
            case SKPaymentTransactionStatePurchasing:
				DNSLog(@"SKPaymentTransactionStatePurchasing");
                break;
            case SKPaymentTransactionStatePurchased:
				DNSLog(@"SKPaymentTransactionStatePurchased");
				[self completeTransaction:transaction];
				[hud dismiss];
				hud = nil;
                break;
            case SKPaymentTransactionStateFailed:
				DNSLog(@"SKPaymentTransactionStateFailed");
				[self failedTransaction:transaction];
				[hud dismiss];
				hud = nil;
                break;
            case SKPaymentTransactionStateRestored:
				DNSLog(@"SKPaymentTransactionStateRestored");
                [self restoreTransaction:transaction];
				[hud dismiss];
				hud = nil;
            default:
                break;
        }
    }
}

#pragma mark -
#pragma mark SKProductsRequestDelegate

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
	DNSLogMethod
	
	for (NSString *invalid in [response invalidProductIdentifiers]) {
		DNSLog(@"%@ is invalued.", invalid);
	}
	
	for (SKProduct *product in [response products]) {
		DNSLog(@"%@", [product productIdentifier]);
		DNSLog(@"%@", [product localizedTitle]);
		DNSLog(@"%@", [product formattedPriceString]);
		DNSLog(@"%@", [product localizedDescription]);
	}
	
	[validItems release];
	if ([[response products] count]) {
		validItems = [[NSArray arrayWithArray:[response products]] retain];
	}
	else {
		validItems = nil;
	}
	
	[[NSNotificationCenter defaultCenter] postNotificationName:kSKManagerStatusUpdated object:nil userInfo:[NSDictionary dictionaryWithObject:self forKey:@"SKManager"]];
}

#pragma mark -
#pragma mark Override

- (id) init {
	self = [super init];
	if (self != nil) {
		validItems = [[NSArray array] retain];
		[[SKPaymentQueue defaultQueue] addTransactionObserver:self];
	}
	return self;
}

#pragma mark -
#pragma mark Singleton design pattern

- (id)retain {
	return self;
}

- (void)release {
}

#pragma mark -
#pragma mark dealloc

- (void) dealloc {
	[validItems release];
	[super dealloc];
}

@end
