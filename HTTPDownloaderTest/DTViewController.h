//
//  DTViewController.h
//  HTTPDownloaderTest
//
//  Created by 越智 修司 on 12/10/29.
//  Copyright (c) 2012年 越智 修司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASINetworkQueue.h"
#import "ASIHttpRequest.h"
#import "CPModalFileProcessingProgressViewController.h"

@interface DTViewController : UIViewController<UIWebViewDelegate,ASIProgressDelegate>

-(IBAction)gotoURL;
@property(nonatomic,retain) IBOutlet UITextField*	urlField;
@property(nonatomic,retain) IBOutlet UIWebView*		webView;
@property(nonatomic,retain) ASINetworkQueue*		queue;
@property(nonatomic,retain) CPModalFileProcessingProgressViewController* modalVC;
@end
