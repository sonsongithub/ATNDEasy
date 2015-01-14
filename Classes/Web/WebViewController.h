//
//  SNWebBrowser.h
//  2tch
//
//  Created by sonson on 08/12/01.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController <UIWebViewDelegate> {
	UIWebView			*webView;

	UIBarButtonItem		*backButton;
	UIBarButtonItem		*forwardButton;
	UIBarButtonItem		*imageButton;
	UIBarButtonItem		*safariButton;
	UIBarButtonItem		*fixedSpace;
	UIBarButtonItem		*flexibleSpace;
}
+ (UINavigationController*)sharedNavigationController;
+ (WebViewController*)sharedInstance;
- (void)openURLString:(NSString*)url;
- (BOOL)isImageURL:(NSString*)imageURL;
@end
