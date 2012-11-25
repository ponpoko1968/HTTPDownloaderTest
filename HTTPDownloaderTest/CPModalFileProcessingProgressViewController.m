//
//  CPModalProgressView.m
//  ClipPDF
//
//  Created by 越智 修司 on 11/08/03.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//
#import "QuartzCore/QuartzCore.h"

#import "CPModalFileProcessingProgressViewController.h"

@implementation CPModalFileProcessingProgressViewController

@synthesize progress = progress_;
@synthesize fileNameLabel = fileNameLabel_;
@synthesize progressLabel = progressLabel_;
@synthesize processingLabel = processingLabel_;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle
- (void)viewWillAppear:(BOOL)animated
{
    progressView_.layer.cornerRadius = 5.0;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

@end
