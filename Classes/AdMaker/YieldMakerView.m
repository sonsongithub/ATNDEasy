//
//  YieldMakerView.m
//  RealYieldTest
//
//  Created by Shin Izawa on 10-5-6.
//  Mdified by Shin Izawa on 10-10-26.
//  Copyright 2010 NOBOT Inc. All rights reserved.
//

#import "YieldMakerView.h"

@implementation YieldMakerView
@synthesize webView;
@synthesize tempurl;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
		webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
		webView.hidden = YES;
		[self addSubview:webView];
	    [webView setDelegate:self];		
		[self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}


- (void)drawRect:(CGRect)rect {
    // Drawing code
}


- (void)dealloc {
	[webView release];
	[tempurl release];
    [super dealloc];
}
#pragma mark -
#pragma mark testcase

-(void)setUrl:(NSString *)surl{
	tempurl=surl;
}

-(void)start{
	[webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:tempurl]]];
}
-(void)setController:(UIViewController *)vcontroller{

}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
	//CAPTURE USER LINK-CLICK.
	NSString* str = [[request URL] absoluteString];
	NSRange range = [str rangeOfString:@"ad-maker.info"];
	if (0 != range.length) {
		return YES;
	}
	
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]]; 
	return NO;
	
}

- (void)webViewDidFinishLoad:(UIWebView *)awebView {
	[awebView stringByEvaluatingJavaScriptFromString:@"window.open = function( inurl, blah, blah2 ) {  document.location = inurl; }"];		
	awebView.hidden = NO;
}
@end
