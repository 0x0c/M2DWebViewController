//
//  M2DViewController.m
//  M2DWebViewController
//
//  Created by Akira Matsuda on 10/13/2014.
//  Copyright (c) 2014 Akira Matsuda. All rights reserved.
//

#import "M2DViewController.h"
#import "M2DWebViewController.h"

@interface M2DViewController ()

@end

@implementation M2DViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)show:(id)sender
{
	M2DWebViewController *viewController = [[M2DWebViewController alloc] initWithURL:[NSURL URLWithString:@"https://github.com/0x0c/M2DWebViewController"] type:M2DWebViewTypeUIKit];
	[self.navigationController pushViewController:viewController animated:YES];
}

- (IBAction)show2:(id)sender
{
	M2DWebViewController *viewController = [[M2DWebViewController alloc] initWithURL:[NSURL URLWithString:@"https://github.com/0x0c/M2DWebViewController"] type:M2DWebViewTypeUIKit];
	__weak typeof(viewController) bviewcontroller = viewController;
	viewController.actionButtonPressedHandler = ^(NSString *pageTitle, NSURL *url){
		UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[pageTitle, url] applicationActivities:@[]];
		[bviewcontroller presentViewController:activityViewController animated:YES completion:^{
		}];
	};
	[self.navigationController pushViewController:viewController animated:YES];
}

- (IBAction)showWithArrowImage:(id)sender
{
	CGSize size = CGSizeMake(18, 18);
	UIGraphicsBeginImageContextWithOptions(size, NO, 0);
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGRect rect = {CGPointZero, size};
	
	CGContextSaveGState(context);
	CGContextBeginPath(context);
	
	CGContextMoveToPoint(context, 0, 0);
	CGContextAddLineToPoint(context, CGRectGetMaxX(rect), CGRectGetMidY(rect));
	CGContextAddLineToPoint(context, 0, CGRectGetMaxY(rect));
	
	CGContextClosePath(context);
	CGContextSetFillColorWithColor(context, [[UIColor whiteColor] CGColor]);
	CGContextFillPath(context);
	CGContextRestoreGState(context);
	
	UIImage *icon = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	M2DWebViewController *viewController = [[M2DWebViewController alloc] initWithURL:[NSURL URLWithString:@"https://github.com/0x0c/M2DWebViewController"] type:M2DWebViewTypeUIKit backArrowImage:icon forwardArrowImage:icon];
	[self.navigationController pushViewController:viewController animated:YES];
}

@end
