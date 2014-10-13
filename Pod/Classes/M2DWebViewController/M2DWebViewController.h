//
//  M2DWebViewController.h
//  BoostMedia
//
//  Created by Akira Matsuda on 2013/01/11.
//  Copyright (c) 2013年 akira.matsuda. All rights reserved.
//

#import <UIKit/UIKit.h>
@import QuartzCore;
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_8_0
@import WebKit;
#endif

@class M2DWebViewController;

typedef NS_ENUM(NSUInteger, M2DWebViewType) {
	M2DWebViewTypeUIKit,
	M2DWebViewTypeWebKit,
};

@interface M2DWebViewController : UIViewController <WKNavigationDelegate, UIWebViewDelegate>
{
	NSURL *url_;
	UIBarButtonItem *goForwardButton_;
	UIBarButtonItem *goBackButton_;
	UIBarButtonItem *actionButton_;
	id webView_;
	M2DWebViewType type_;
}

@property (assign, nonatomic) BOOL smoothScroll;
@property (nonatomic, readonly) id webView;
@property (nonatomic, copy) void (^actionButtonPressedHandler)(NSString *pageTitle, NSURL *url);

- (instancetype)initWithURL:(NSURL *)url type:(M2DWebViewType)type;
- (void)goForward:(id)sender;
- (void)goBack:(id)sender;
- (void)refresh:(id)sender;
- (void)doAction:(id)sender;
- (void)loadURL:(NSURL *)url;
- (void)setSmoothScroll:(BOOL)smoothScroll;

@end
