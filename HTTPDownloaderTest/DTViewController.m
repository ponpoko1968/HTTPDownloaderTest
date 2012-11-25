//
//  DTViewController.m
//  HTTPDownloaderTest
//
//  Created by 越智 修司 on 12/10/29.
//  Copyright (c) 2012年 越智 修司. All rights reserved.
//
#import "DTAppDelegate.h"
#import "DTViewController.h"

enum {
  kRequestForHeader		= 1,
  kRequestForDownloadingPDF	= 2,
};

@interface DTViewController ()
{
  BOOL manualLoading;
}
@end

@implementation DTViewController
@synthesize queue;
@synthesize urlField;
@synthesize modalVC;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.queue = [[[ASINetworkQueue alloc] init] autorelease];
    self.queue.requestDidReceiveResponseHeadersSelector = @selector(request:DidReceiveResponseHeaders:);
    self.queue.delegate = self;
    self.queue.downloadProgressDelegate = self;
    manualLoading = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)gotoURL
{
  NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlField.text]];
  [self.webView loadRequest:request];
}

#pragma mark UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
  Log( @"manualLoading=%@",manualLoading ? @"YES" : @"NO" );
  if( manualLoading ){		// 先読み前
    NSURL* url = [request URL];
    // HEADメソッドを使用
    ASIHTTPRequest *req = [[ASIHTTPRequest requestWithURL:url] HEADRequest];
    req.tag = kRequestForHeader;
    [req setDidFinishSelector:@selector(requestDone:)];
    [req setDidFailSelector:@selector(requestWentWrong:)];
    [req setDelegate:self];

    [self.queue addOperation:req];
    [self.queue go];
  
    return NO;
  }else{			// 先読み後
    return YES;
  }
  return NO;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
  Log(@"done");
  manualLoading = manualLoading ? NO : YES;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
  Log(@"failed");
  manualLoading = manualLoading ? NO : YES;

}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    Log(@"start");
}

#pragma mark ASIHttpRequestDelegate


- (void)requestDone:(ASIHTTPRequest *)request
{
  NSLog(@"done");
  manualLoading = manualLoading ? NO : YES;
}

- (void)requestWentWrong:(ASIHTTPRequest *)request
{
  NSLog(@"failed");
  manualLoading = manualLoading ? NO : YES;
}


-(void)request:(ASIHTTPRequest*) request DidReceiveResponseHeaders:(NSDictionary*)responseHeders
{
  if( kRequestForDownloadingPDF  == request.tag ){
    return;
  }
  [request clearDelegatesAndCancel];
#ifdef DEBUG
  for( NSString* k in [responseHeders allKeys]){
    NSLog(@"%@='%@'",k,[responseHeders objectForKey:k]);
  }
#endif
  if( ! NSEqualRanges([[responseHeders objectForKey:@"Content-Type"] rangeOfString:@"application/pdf" options:NSAnchoredSearch|NSCaseInsensitiveSearch],NSMakeRange(NSNotFound,0))){
    ASIHTTPRequest* req = [ASIHTTPRequest requestWithURL:[request url]];
    req.tag = kRequestForDownloadingPDF;
    NSArray* paths= NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    Log(@"documentsDirectory='%@'",documentsDirectory);
    
    [req setDownloadDestinationPath:[documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.pdf",[self newUUIDString]] ]];

    [req setDidFinishSelector:@selector(downloadDone:)];
    [req setDidFailSelector:@selector(downloadFailed:)];
    [req setDelegate:self];


    [self.queue addOperation:req];
    [self showProgressView];
    [self.queue go];
    
    return;
  }

  if( [@"text/html" isEqualToString:[responseHeders objectForKey:@"Content-Type"]] ){
    NSURLRequest* requestx = [NSURLRequest requestWithURL:[request url]];
    manualLoading = NO;
    [self.webView loadRequest:requestx];
    return;
  }
}
#pragma mark download result

-(void)downloadDone:(ASIHTTPRequest*)request
{
  Log(@"");
  [self.modalVC.progress setProgress:1.0 animated:NO];
  [self hideProgressView];
}

-(void)downloadFailed:(ASIHTTPRequest*)request
{
  Log(@"");
  [self.modalVC.progress setProgress:1.0 animated:NO];
  [self hideProgressView];
}

#pragma mark progress
- (void)setProgress:(float)newProgress
{
  Log(@"%f",newProgress);
  [self.modalVC.progress setProgress:newProgress animated:NO];
}

-(void)showProgressView
{
  DTAppDelegate* app = (DTAppDelegate*) [UIApplication sharedApplication].delegate;
  if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
    self.modalVC = [[[CPModalFileProcessingProgressViewController alloc] initWithNibName:@"CPModalFileProcessingProgressViewController-iPhone" bundle:nil] autorelease];
  } else {
    self.modalVC = [[[CPModalFileProcessingProgressViewController alloc] initWithNibName:@"CPModalFileProcessingProgressViewController-iPad" bundle:nil] autorelease];
  }
  [app.window addSubview:self.modalVC.view];
  [app.window bringSubviewToFront:self.modalVC.view];
}



-(void)hideProgressView
{
  [self.modalVC.view removeFromSuperview];
}

-(NSString*) newUUIDString
{
  CFUUIDRef uuidRef = CFUUIDCreate(kCFAllocatorDefault);
  NSString* uuidString = (NSString *)CFUUIDCreateString(kCFAllocatorDefault, uuidRef);
  [uuidString autorelease];
  CFRelease(uuidRef);
  return uuidString;
}

@end
