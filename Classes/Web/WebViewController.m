//
//  SNWebBrowser.m
//  2tch
//
//  Created by sonson on 08/12/01.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "WebViewController.h"

#import "UIViewController+LongTitle.h"

UIWebView* webViewForReuse = nil;

UINavigationController *sharedWebViewNavigationController = nil;
WebViewController *sharedWebViewController = nil;

@implementation WebViewController

#pragma mark Class method

+ (UINavigationController*)sharedNavigationController {
	if (sharedWebViewNavigationController == nil) {
		WebViewController* controller = [WebViewController sharedInstance];
		sharedWebViewNavigationController = [[UINavigationController alloc] initWithRootViewController:controller];
		sharedWebViewNavigationController.toolbarHidden = NO;
	}
	return sharedWebViewNavigationController;
}

+ (WebViewController*)sharedInstance {
	if (sharedWebViewController == nil) {
		sharedWebViewController = [[WebViewController alloc] initWithNibName:nil bundle:nil];
	}
	return sharedWebViewController;
}

#pragma mark -
#pragma mark Instance method

- (void)openURLString:(NSString*)URLString {
	DNSLogMethod
	NSURL *url = [NSURL URLWithString:URLString];
	NSString *scheme = [url scheme];
	if ([scheme isEqualToString:@"ttp"]) {
		NSString *newURLString = [@"h" stringByAppendingString:URLString];
		url =[NSURL URLWithString:newURLString];
	}
	else if ([scheme isEqualToString:@"tp"]) {
		NSString *newURLString = [@"ht" stringByAppendingString:URLString];
		url =[NSURL URLWithString:newURLString];
	}
	
	NSURLRequest *request = [NSURLRequest requestWithURL:url];
	[webView loadRequest:request];
}

- (void)allocButtons {
	
	backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Back.png"] style:UIBarButtonItemStylePlain target:self action:@selector(pushBackButton:)];
	backButton.enabled = NO;
	
	fixedSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
	[fixedSpace setWidth:20];
	
	flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
	
	forwardButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Forward.png"] style:UIBarButtonItemStylePlain  target:self action:@selector(pushForwardButton:)];
	forwardButton.enabled = NO;
	
	safariButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"safari.png"] style:UIBarButtonItemStylePlain target:self action:@selector(pushSafariButton:)];
	safariButton.enabled = NO;
}

#pragma mark -
#pragma mark UIButton callback

- (void)pushSafariButton:(id)sender {
	DNSLogMethod
	[[UIApplication sharedApplication] openURL:webView.request.URL];
}

- (void)updateButton {
	DNSLogMethod
	backButton.enabled = [webView canGoBack];
	forwardButton.enabled = [webView canGoForward];
}

- (void)pushCloseButton:(id)sender {
	DNSLogMethod
	[self dismissModalViewControllerAnimated:YES];
}

- (void)pushBackButton:(id)sender {
	DNSLogMethod
	[webView goBack];
}

- (void)pushForwardButton:(id)sender {
	DNSLogMethod
	[webView goForward];
}

#pragma mark -
#pragma mark UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)aWebView {
	DNSLogMethod
	imageButton.enabled = NO;
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)aWebView {
	DNSLogMethod
	[self updateButton];
	safariButton.enabled = YES;
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	
	[self setLongTitle:[webView stringByEvaluatingJavaScriptFromString:@"document.title"]];
}

- (void)webView:(UIWebView *)aWebView didFailLoadWithError:(NSError *)error {
	DNSLogMethod
	[self updateButton];
	safariButton.enabled = NO;
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	self.title = NSLocalizedString(@"Error", nil);
	
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil)
														message:[error localizedDescription] 
													   delegate:nil 
											  cancelButtonTitle:nil 
											  otherButtonTitles:NSLocalizedString(@"OK", nil), nil];
	[alertView show];
	[alertView release];
}

#pragma mark -
#pragma mark Override

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
		[self allocButtons];
        // Custom initialization
		if( webViewForReuse == nil ) {
			DNSLog( @"alloc webview" );
			webViewForReuse = [[UIWebView alloc] initWithFrame:CGRectZero];
			// webViewForReuse.detectsPhoneNumbers = NO;
			webViewForReuse.backgroundColor = [UIColor whiteColor];
			webViewForReuse.scalesPageToFit = YES;
			webViewForReuse.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
			webView = webViewForReuse;
		}
		else {
			DNSLog( @"reuse webview" );
			webView = webViewForReuse;
		}
		
		webView.delegate = self;
		webView.frame = self.view.bounds;
		[self.view addSubview:webView];
    }
    return self;
}		


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	
	UIBarButtonItem*	closeButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Done", nil) style:UIBarButtonItemStyleDone target:self action:@selector(pushCloseButton:)];
	self.navigationItem.rightBarButtonItem = closeButton;
	[closeButton release];
}

- (void)viewDidAppear:(BOOL)animated {
	DNSLogMethod
    [super viewDidAppear:animated];
	
	NSMutableArray *items = [NSMutableArray array];
	[items addObject:backButton];
	[items addObject:fixedSpace];
	[items addObject:forwardButton];
	[items addObject:flexibleSpace];
	[items addObject:safariButton];
	
	[sharedWebViewNavigationController.toolbar setItems:items animated:YES];
}

#pragma mark -
#pragma mark dealloc

- (void) dealloc {
	DNSLogMethod
	[flexibleSpace release];
	[forwardButton release];
	[imageButton release];
	[backButton release];
	[safariButton release];
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	webView.delegate = nil;
	[webView loadHTMLString:@"" baseURL:nil];
	[super dealloc];
}

@end
