//
//  OTOFAQDetailViewController.m
//  OnatoFAQs
//
//  Created by Stephen Williams on 27/06/14.
//  Copyright (c) 2014 Onato. All rights reserved.
//

#import "OTOFAQDetailViewController.h"
#import "OTOFAQ.h"

@interface OTOFAQDetailViewController ()

@end

@implementation OTOFAQDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.textView.scrollEnabled = NO;
    self.textView.attributedText = self.faq.attributedText;
    self.textView.textContainerInset = UIEdgeInsetsMake(5, 10, 0, 10);
}

- (void)viewDidAppear:(BOOL)animated
{
    self.textView.scrollEnabled = YES;
    [super viewDidAppear:animated];
    
    // 27th February 2015: This is a hack to make sure the the text view is scrolled
    // to the top and redrawn correctly. The issues appeared when there was an image at the
    // bottom of the screen that was not being drawn.
    CGFloat topOffset = -self.topLayoutGuide.length;
    [self.textView setContentOffset:CGPointMake(0, topOffset+1) animated:NO];
    [self.textView setContentOffset:CGPointMake(0, topOffset) animated:YES];
}

@end
