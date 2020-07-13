//
//  M2DWebViewController.m
//  BoostMedia
//
//  Created by Akira Matsuda on 2013/01/11.
//  Copyright (c) 2013年 akira.matsuda. All rights reserved.
//

#import "M2DWebViewController.h"

static const CGSize M2DArrowIconSize = {10, 18};
static const CGFloat M2DArrowIconLineWidth = 1.3;

typedef NS_ENUM(NSUInteger, M2DArrowIconDirection) {
  M2DArrowIconDirectionLeft,
  M2DArrowIconDirectionRight
};

@implementation UIImage (M2DArrowIcon)

+ (UIImage *)m2d_arrowIconWithDirection:(M2DArrowIconDirection)direction size:(CGSize)size
{
    if (CGSizeEqualToSize(size, CGSizeZero)) {
        return [[UIImage alloc] init];
    }

    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect rect = {CGPointZero, size};

    CGContextSaveGState(context);
	
	CGContextSetLineJoin(context, kCGLineJoinMiter);
	CGContextSetLineWidth(context, M2DArrowIconLineWidth);
    CGContextBeginPath(context);

    if (direction == M2DArrowIconDirectionRight) {
        CGContextMoveToPoint(context, M2DArrowIconLineWidth, M2DArrowIconLineWidth);
        CGContextAddLineToPoint(context, CGRectGetMaxX(rect) - M2DArrowIconLineWidth, CGRectGetMidY(rect));
        CGContextAddLineToPoint(context, M2DArrowIconLineWidth, CGRectGetMaxY(rect) - M2DArrowIconLineWidth);
    }
	else {
        CGContextMoveToPoint(context, CGRectGetMaxX(rect) - M2DArrowIconLineWidth, M2DArrowIconLineWidth);
        CGContextAddLineToPoint(context, M2DArrowIconLineWidth, CGRectGetMidY(rect));
        CGContextAddLineToPoint(context, CGRectGetMaxX(rect) - M2DArrowIconLineWidth, CGRectGetMaxY(rect) - M2DArrowIconLineWidth);
    }

	CGContextStrokePath(context);
    CGContextRestoreGState(context);

    UIImage *icon = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return icon;
}

@end

@interface M2DWebViewController ()
{
	NSURL *url_;
	UIBarButtonItem *goForwardButton_;
	UIBarButtonItem *goBackButton_;
	UIBarButtonItem *actionButton_;
	WKWebView *webView_;
}

@property (nonatomic, copy) UIImage *backArrowImage;
@property (nonatomic, copy) UIImage *forwardArrowImage;

@end

@implementation M2DWebViewController

static NSString *const kM2DWebViewControllerGetTitleScript = @"var elements=document.getElementsByTagName(\'title\');elements[0].innerText";

- (id)initWithURL:(NSURL *)url
{
	self = [super init];
	if (self) {
		url_ = [url copy];
		
        webView_ = [[WKWebView alloc] initWithFrame:self.view.bounds];
        [webView_ setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
        webView_.navigationDelegate = self;
        [webView_ loadRequest:[NSURLRequest requestWithURL:url_]];
		
		[self.view addSubview:webView_];
	}
	
	return self;
}

- (instancetype)initWithURL:(NSURL *)url backArrowImage:(UIImage *)backArrowImage forwardArrowImage:(UIImage *)forwardArrowImage
{
	self = [self initWithURL:url];
	if (self) {
		self.backArrowImage = backArrowImage;
		self.forwardArrowImage = forwardArrowImage;
	}
	
	return self;
}

- (instancetype)initWithConfiguration:(WKWebViewConfiguration *)configuration url:(NSURL *)url
{
	self = [super init];
	if (self) {
		url_ = [url copy];
		webView_ = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:configuration];
		[webView_ setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
		webView_.navigationDelegate = self;
		[webView_ loadRequest:[NSURLRequest requestWithURL:url_]];
		[self.view addSubview:webView_];
	}
	
	return self;
}

- (instancetype)initWithConfiguration:(WKWebViewConfiguration *)configuration url:(NSURL *)url backArrowImage:(UIImage *)backArrowImage forwardArrowImage:(UIImage *)forwardArrowImage
{
	self = [self initWithConfiguration:configuration url:url];
	if (self) {
		self.backArrowImage = backArrowImage;
		self.forwardArrowImage = forwardArrowImage;
	}
	
	return self;
}

- (void)dealloc
{
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (id)webView
{
	return webView_;
}

- (BOOL)prefersStatusBarHidden
{
    return NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = NSLocalizedString(@"Loading...", @"");
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[self.navigationController setToolbarHidden:self.toolbarHidden animated:YES];
	if (goBackButton_ == nil) {
		NSArray *toolbarItems = nil;
		goBackButton_ = [[UIBarButtonItem alloc] initWithImage:self.backArrowImage ?: [UIImage m2d_arrowIconWithDirection:M2DArrowIconDirectionLeft size:M2DArrowIconSize] style:UIBarButtonItemStylePlain target:self action:@selector(goBack:)];
		goForwardButton_ = [[UIBarButtonItem alloc] initWithImage:self.forwardArrowImage ?: [UIImage m2d_arrowIconWithDirection:M2DArrowIconDirectionRight size:M2DArrowIconSize] style:UIBarButtonItemStylePlain target:self action:@selector(goForward:)];
		UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
		UIBarButtonItem *fixedSpace19 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
		fixedSpace19.width = 19;
		UIBarButtonItem *fixedSpace6 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
		fixedSpace6.width = 6;
		UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refresh:)];

		if (self.actionButtonPressedHandler) {
			actionButton_ = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(doAction:)];

			toolbarItems = @[fixedSpace6, goBackButton_, fixedSpace19, goForwardButton_, space, refreshButton, fixedSpace19, actionButton_, fixedSpace6];
		}
		else {
			toolbarItems = @[fixedSpace6, goBackButton_, fixedSpace19, goForwardButton_, space, refreshButton, fixedSpace6];
		}
		self.toolbarItems = toolbarItems;
		
		goForwardButton_.enabled = NO;
		goBackButton_.enabled = NO;
	}
}

- (void)setSmoothScroll:(BOOL)smoothScroll
{
	if (smoothScroll) {
		webView_.scrollView.decelerationRate = UIScrollViewDecelerationRateNormal;
	}
	else {
		webView_.scrollView.decelerationRate = UIScrollViewDecelerationRateFast;
	}
}

- (void)setToolbarHidden:(BOOL)toolbarHidden
{
	_toolbarHidden = toolbarHidden;
	[self.navigationController setToolbarHidden:self.toolbarHidden animated:YES];
}

#pragma mark - WKUIDelegate

- (WKWebView * _Nullable)webView:(WKWebView * _Nonnull)webView createWebViewWithConfiguration:(WKWebViewConfiguration * _Nonnull)configuration forNavigationAction:(WKNavigationAction * _Nonnull)navigationAction windowFeatures:(WKWindowFeatures * _Nonnull)windowFeatures
{
	if ([self.delegate respondsToSelector:@selector(m2d_webView:createWebViewWithConfiguration:forNavigationAction:windowFeatures:)]) {
		return [self.delegate m2d_webView:webView createWebViewWithConfiguration:configuration forNavigationAction:navigationAction windowFeatures:windowFeatures];
	}
	
	return nil;
}

- (void)webViewDidClose:(WKWebView * _Nonnull)webView
{
	if ([self.delegate respondsToSelector:@selector(m2d_webViewDidClose:)]) {
		[self.delegate m2d_webViewDidClose:webView];
	}
}
- (void)webView:(WKWebView * _Nonnull)webView runJavaScriptAlertPanelWithMessage:(NSString * _Nonnull)message initiatedByFrame:(WKFrameInfo * _Nonnull)frame completionHandler:(void (^ _Nonnull)(void))completionHandler
{
	if ([self.delegate respondsToSelector:@selector(m2d_webView:runJavaScriptAlertPanelWithMessage:initiatedByFrame:completionHandler:)]) {
		[self.delegate m2d_webView:webView runJavaScriptAlertPanelWithMessage:message initiatedByFrame:frame completionHandler:completionHandler];
	}
	else {
		completionHandler();
	}
}

- (void)webView:(WKWebView * _Nonnull)webView runJavaScriptConfirmPanelWithMessage:(NSString * _Nonnull)message initiatedByFrame:(WKFrameInfo * _Nonnull)frame completionHandler:(void (^ _Nonnull)(BOOL result))completionHandler
{
	if ([self.delegate respondsToSelector:@selector(m2d_webView:runJavaScriptConfirmPanelWithMessage:initiatedByFrame:completionHandler:)]) {
		[self.delegate m2d_webView:webView runJavaScriptConfirmPanelWithMessage:message initiatedByFrame:frame completionHandler:completionHandler];
	}
	else {
		completionHandler(YES);
	}
}

- (void)webView:(WKWebView * _Nonnull)webView runJavaScriptTextInputPanelWithPrompt:(NSString * _Nonnull)prompt defaultText:(NSString * _Nullable)defaultText initiatedByFrame:(WKFrameInfo * _Nonnull)frame completionHandler:(void (^ _Nonnull)(NSString * _Nullable result))completionHandler
{
	if ([self.delegate respondsToSelector:@selector(m2d_webView:runJavaScriptTextInputPanelWithPrompt:defaultText:initiatedByFrame:completionHandler:)]) {
		[self.delegate m2d_webView:webView runJavaScriptTextInputPanelWithPrompt:prompt defaultText:defaultText initiatedByFrame:frame completionHandler:completionHandler];
	}
	else {
		completionHandler(nil);
	}
}

- (BOOL)webView:(WKWebView * _Nonnull)webView shouldPreviewElement:(WKPreviewElementInfo * _Nonnull)elementInfo
{
	if ([self.delegate respondsToSelector:@selector(m2d_webView:shouldPreviewElement:)]) {
		return [self.delegate m2d_webView:webView shouldPreviewElement:elementInfo];
	}
	
	return NO;
}

- (UIViewController * _Nullable)webView:(WKWebView * _Nonnull)webView previewingViewControllerForElement:(WKPreviewElementInfo * _Nonnull)elementInfo defaultActions:(NSArray<id <WKPreviewActionItem>> * _Nonnull)previewActions
{
	if ([self.delegate respondsToSelector:@selector(m2d_webView:previewingViewControllerForElement:defaultActions:)]) {
		return [self.delegate m2d_webView:webView previewingViewControllerForElement:elementInfo defaultActions:previewActions];
	}
	
	return nil;
}

- (void)webView:(WKWebView * _Nonnull)webView commitPreviewingViewController:(UIViewController * _Nonnull)previewingViewController
{
	if ([self.delegate respondsToSelector:@selector(m2d_webView:commitPreviewingViewController:)]) {
		[self.delegate m2d_webView:webView commitPreviewingViewController:previewingViewController];
	}
}

#pragma mark - WKNavigationDelegate

- (void)webView:(WKWebView * _Nonnull )webView decidePolicyForNavigationAction:(WKNavigationAction * _Nonnull )navigationAction decisionHandler:(void (^ _Nonnull)(WKNavigationActionPolicy))decisionHandler
{
	if ([self.delegate respondsToSelector:@selector(m2d_webView:decidePolicyForNavigationAction:decisionHandler:)]) {
		[self.delegate m2d_webView:webView decidePolicyForNavigationAction:navigationAction decisionHandler:decisionHandler];
	}
	else {
		decisionHandler(WKNavigationActionPolicyAllow);
	}
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler
{
	if ([self.delegate respondsToSelector:@selector(m2d_webView:decidePolicyForNavigationResponse:decisionHandler:)]) {
		[self.delegate m2d_webView:webView decidePolicyForNavigationResponse:navigationResponse decisionHandler:decisionHandler];
	}
	else {
		decisionHandler(WKNavigationResponsePolicyAllow);
	}
}

- (void)webView:(WKWebView * _Nonnull )webView didStartProvisionalNavigation:(WKNavigation * _Null_unspecified)navigation
{
	if ([webView_ canGoBack]) {
		goBackButton_.enabled = YES;
	}
	else {
		goBackButton_.enabled = NO;
	}
	
	if ([webView_ canGoForward]) {
		goForwardButton_.enabled = YES;
	}
	else {
		goForwardButton_.enabled = NO;
	}
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	[self updateToolbarItemsWithType:UIBarButtonSystemItemStop];
	
	if ([self.delegate respondsToSelector:@selector(m2d_webView:didStartProvisionalNavigation:)]) {
		[self.delegate m2d_webView:webView didStartProvisionalNavigation:navigation];
	}
}

- (void)webView:(WKWebView * _Nonnull )webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation * _Null_unspecified)navigation
{
	if ([self.delegate respondsToSelector:@selector(m2d_webView:didReceiveServerRedirectForProvisionalNavigation:)]) {
		[self.delegate m2d_webView:webView didReceiveServerRedirectForProvisionalNavigation:navigation];
	}
}

- (void)webView:(WKWebView * _Nonnull )webView didFailProvisionalNavigation:(WKNavigation * _Null_unspecified)navigation withError:(NSError * _Nonnull)error
{
	if ([self.delegate respondsToSelector:@selector(m2d_webView:didFailProvisionalNavigation:withError:)]) {
		[self.delegate m2d_webView:webView didFailProvisionalNavigation:navigation withError:error];
	}
}

- (void)webView:(WKWebView * _Nonnull )webView didCommitNavigation:(WKNavigation * _Null_unspecified)navigation
{
	if ([self.delegate respondsToSelector:@selector(m2d_webView:didCommitNavigation:)]) {
		[self.delegate m2d_webView:webView didCommitNavigation:navigation];
	}
}

- (void)webView:(WKWebView * _Nonnull )webView didFailNavigation:(WKNavigation * _Null_unspecified)navigation withError:(NSError * _Nonnull)error
{
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	[self updateToolbarItemsWithType:UIBarButtonSystemItemRefresh];
	
	if ([self.delegate respondsToSelector:@selector(m2d_webView:didFailNavigation:withError:)]) {
		[self.delegate m2d_webView:webView didFailNavigation:navigation withError:error];
	}
}

- (void)webView:(WKWebView * _Nonnull )webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge * _Nonnull )challenge completionHandler:(void (^ _Nonnull)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler
{
	if ([self.delegate respondsToSelector:@selector(m2d_webView:didReceiveAuthenticationChallenge:completionHandler:)]) {
		[self.delegate m2d_webView:webView didReceiveAuthenticationChallenge:challenge completionHandler:completionHandler];
	}
	else {
		completionHandler(NSURLSessionAuthChallengePerformDefaultHandling, nil);
	}
}

- (void)webViewWebContentProcessDidTerminate:(WKWebView * _Nonnull )webView
{
	if ([self.delegate respondsToSelector:@selector(m2d_webViewWebContentProcessDidTerminate:)]) {
		[self.delegate m2d_webViewWebContentProcessDidTerminate:webView];
	}
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
	self.title = webView.title;
	
	if ([webView_ canGoBack]) {
		goBackButton_.enabled = YES;
	}
	else {
		goBackButton_.enabled = NO;
	}
	
	if ([webView_ canGoForward]) {
		goForwardButton_.enabled = YES;
	}
	else {
		goForwardButton_.enabled = NO;
	}
	
	url_ = [webView.URL copy];
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	[self updateToolbarItemsWithType:UIBarButtonSystemItemRefresh];
	
	if ([self.delegate respondsToSelector:@selector(m2d_webView:didFinishNavigation:)]) {
		[self.delegate m2d_webView:webView didFinishNavigation:navigation];
	}
}

#pragma mark -

- (NSString *)realTitle
{
    return [webView_ title];
}

- (void)goForward:(id)sender
{
	[webView_ goForward];
}

- (void)goBack:(id)sender
{
	[webView_ goBack];
}

- (void)refresh:(id)sender
{
	[webView_ reload];
}

- (void)stop:(id)sender
{
	[webView_ stopLoading];
}

- (void)doAction:(id)sender
{
	if (self.actionButtonPressedHandler) {
		NSString *title = [self realTitle];
		self.actionButtonPressedHandler(title, url_);
	}
}

- (void)loadURL:(NSURL *)url
{
	[webView_ loadRequest:[NSURLRequest requestWithURL:url]];
}

- (NSString *)resourceFilePath:(NSString *)filename
{
	return 	[NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] pathForResource:@"M2DWebViewController" ofType:@"bundle"], filename];
}

- (void)updateToolbarItemsWithType:(UIBarButtonSystemItem)type
{
	if (type == UIBarButtonSystemItemRefresh) {
		NSMutableArray *items = [[self.navigationController.toolbar items] mutableCopy];
		UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refresh:)];
		[items replaceObjectAtIndex:5 withObject:refreshButton];
		[self.navigationController.toolbar setItems:items];
	}
	else if (type == UIBarButtonSystemItemStop) {
		NSMutableArray *items = [[self.navigationController.toolbar items] mutableCopy];
		UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(stop:)];
		[items replaceObjectAtIndex:5 withObject:refreshButton];
		[self.navigationController.toolbar setItems:items];
	}
}

@end
