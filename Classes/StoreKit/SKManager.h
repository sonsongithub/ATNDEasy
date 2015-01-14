//
//  SKManager.h
//  ATNDEasy
//
//  Created by sonson on 10/11/25.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

#define	HIDE_ADV_IDENTIFIER @"com.sonson.ATNDEasy.hideAdv"

extern NSString* kSKManagerStatusUpdated;
extern NSString* kSKManagerProductPurchased;

@class HUDView;

@interface SKManager : NSObject <SKProductsRequestDelegate, SKPaymentTransactionObserver> {
	HUDView	*hud;
	NSArray	*validItems;
}
@property (nonatomic, readonly) NSArray *validItems;
+ (SKManager*)sharedInstance;
- (void)startToPurchaseProductWithIdentifier:(NSString*)identifier;
- (BOOL)isPurchasedProductIdentifier:(NSString*)identifier;
- (void)confirmValidItems;
@end
