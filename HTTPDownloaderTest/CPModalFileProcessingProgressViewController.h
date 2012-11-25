//
//  CPModalProgressView.h
//  ClipPDF
//
//  Created by 越智 修司 on 11/08/03.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CPModalFileProcessingProgressViewController : UIViewController {
  IBOutlet UIView*		progressView_;
  UILabel*		fileNameLabel_;
  UILabel*		progressLabel_;
  UILabel*		processingLabel_;
  UIProgressView*	progress_;
  
}
@property(nonatomic,retain)  IBOutlet UIProgressView*	progress;
@property(nonatomic,retain)  IBOutlet UILabel*		fileNameLabel;
@property(nonatomic,retain)  IBOutlet UILabel*		progressLabel;
@property(nonatomic,retain)  IBOutlet UILabel*		processingLabel;
@end
