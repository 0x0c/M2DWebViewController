//
//  M2DWebViewController.h
//  BoostMedia
//
//  Created by Akira Matsuda on 2013/01/11.
//  Copyright (c) 2013年 akira.matsuda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_8_0
#import <WebKit/WebKit.h>
#endif

@protocol M2DWebViewControllerDelegate <NSObject>
@optional

// WKUIDelegate
- (WKWebView * _Nullable)m2d_webView:(WKWebView * _Nonnull)webView createWebViewWithConfiguration:(WKWebViewConfiguration * _Nonnull)configuration forNavigationAction:(WKNavigationAction * _Nonnull)navigationAction windowFeatures:(WKWindowFeatures * _Nonnull)windowFeatures;
- (void)m2d_webViewDidClose:(WKWebView * _Nonnull)webView API_AVAILABLE(macosx(10.11), ios(9.0));
- (void)m2d_webView:(WKWebView * _Nonnull)webView runJavaScriptAlertPanelWithMessage:(NSString * _Nonnull)message initiatedByFrame:(WKFrameInfo * _Nonnull)frame completionHandler:(void (^ _Nonnull)(void))completionHandler;
- (void)m2d_webView:(WKWebView * _Nonnull)webView runJavaScriptConfirmPanelWithMessage:(NSString * _Nonnull)message initiatedByFrame:(WKFrameInfo * _Nonnull)frame completionHandler:(void (^ _Nonnull)(BOOL result))completionHandler;
- (void)m2d_webView:(WKWebView * _Nonnull)webView runJavaScriptTextInputPanelWithPrompt:(NSString * _Nonnull)prompt defaultText:(NSString * _Nullable)defaultText initiatedByFrame:(WKFrameInfo * _Nonnull)frame completionHandler:(void (^ _Nonnull)(NSString * _Nullable result))completionHandler;
- (BOOL)m2d_webView:(WKWebView * _Nullable)webView shouldPreviewElement:(WKPreviewElementInfo * _Nonnull)elementInfo API_AVAILABLE(ios(10.0));
- (UIViewController * _Nullable)m2d_webView:(WKWebView * _Nullable)webView previewingViewControllerForElement:(WKPreviewElementInfo * _Nonnull)elementInfo defaultActions:(NSArray<id <WKPreviewActionItem>> * _Nonnull)previewActions API_AVAILABLE(ios(10.0));
- (void)m2d_webView:(WKWebView * _Nonnull)webView commitPreviewingViewController:(UIViewController * _Nonnull)previewingViewController API_AVAILABLE(ios(10.0));

// WKNavigationDelegate
- (void)m2d_webView:(WKWebView * _Nonnull)webView decidePolicyForNavigationAction:(WKNavigationAction * _Nonnull)navigationAction decisionHandler:(void (^ _Nonnull)(WKNavigationActionPolicy))decisionHandler;
- (void)m2d_webView:(WKWebView * _Nonnull)webView decidePolicyForNavigationResponse:(WKNavigationResponse * _Nonnull )navigationResponse decisionHandler:(void (^ _Nonnull)(WKNavigationResponsePolicy))decisionHandler;
- (void)m2d_webView:(WKWebView * _Nonnull)webView didStartProvisionalNavigation:(WKNavigation * _Null_unspecified)navigation;
- (void)m2d_webView:(WKWebView * _Nonnull)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation * _Null_unspecified)navigation;
- (void)m2d_webView:(WKWebView * _Nonnull)webView didFailProvisionalNavigation:(WKNavigation * _Null_unspecified)navigation withError:(NSError * _Nonnull)error;
- (void)m2d_webView:(WKWebView * _Nonnull)webView didCommitNavigation:(WKNavigation * _Null_unspecified)navigation;
- (void)m2d_webView:(WKWebView * _Nonnull)webView didFinishNavigation:(WKNavigation * _Null_unspecified)navigation;
- (void)m2d_webView:(WKWebView * _Nonnull)webView didFailNavigation:(WKNavigation * _Null_unspecified)navigation withError:(NSError * _Nonnull)error;
- (void)m2d_webView:(WKWebView * _Nonnull)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge * _Nonnull)challenge completionHandler:(void (^ _Nonnull)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler;
- (void)m2d_webViewWebContentProcessDidTerminate:(WKWebView * _Nonnull)webView API_AVAILABLE(macosx(10.11), ios(9.0));

// UIWebViewDelegate
- (BOOL)m2d_webView:(UIWebView * _Nonnull)webView shouldStartLoadWithRequest:(NSURLRequest * _Nonnull)request navigationType:(UIWebViewNavigationType)navigationType;
- (void)m2d_webViewDidFinishLoad:(UIWebView * _Nonnull)webView;
- (void)m2d_webViewDidStartLoad:(UIWebView * _Nonnull)webView;
- (void)m2d_webView:(UIWebView * _Nonnull)webView didFailLoadWithError:(NSError * _Nullable)error;

@end

@class M2DWebViewController;

typedef NS_ENUM(NSUInteger, M2DWebViewType) {
	M2DWebViewTypeUIKit,
	M2DWebViewTypeWebKit,
	M2DWebViewTypeAutoSelect
};

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_8_0
@interface M2DWebViewController : UIViewController <WKUIDelegate, WKNavigationDelegate, UIWebViewDelegate>
#else
@interface M2DWebViewController : UIViewController <UIWebViewDelegate>
#endif

@property (nonatomic, readonly) id _Nullable webView;
@property (nonatomic, assign) BOOL toolbarHidden;
@property (nonatomic, assign) BOOL smoothScroll;
@property (nonatomic, weak) id<M2DWebViewControllerDelegate> _Nullable delegate;
@property (nonatomic, copy) void (^_Nonnull actionButtonPressedHandler)(NSString * _Nullable pageTitle, NSURL * _Nullable url);

- (instancetype _Nonnull)initWithURL:(NSURL * _Nullable)url type:(M2DWebViewType)type;
- (instancetype _Nonnull)initWithURL:(NSURL * _Nullable)url type:(M2DWebViewType)type backArrowImage:(UIImage * _Nullable)backArrowImage forwardArrowImage:(UIImage * _Nullable)forwardArrowImage;
- (instancetype _Nonnull)initWithConfiguration:(WKWebViewConfiguration * _Nonnull)configuration url:(NSURL * _Nullable)url;
- (instancetype _Nonnull)initWithConfiguration:(WKWebViewConfiguration * _Nonnull)configuration url:(NSURL * _Nullable)url backArrowImage:(UIImage * _Nullable)backArrowImage forwardArrowImage:(UIImage * _Nullable)forwardArrowImage;
- (void)goForward:(id _Nonnull)sender;
- (void)goBack:(id _Nonnull)sender;
- (void)refresh:(id _Nonnull)sender;
- (void)stop:(id _Nonnull)sender;
- (void)doAction:(id _Nonnull)sender;
- (void)loadURL:(NSURL * _Nullable)url;
- (void)setSmoothScroll:(BOOL)smoothScroll;

@end
