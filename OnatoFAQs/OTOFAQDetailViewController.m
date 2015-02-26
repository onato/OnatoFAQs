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
    
    self.textView.attributedText = self.faq.attributedText;
    self.textView.textContainerInset = UIEdgeInsetsMake(5, 10, 0, 10);
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
#warning A better solution is needed for this since the user sees it scroll to the top.
    [self.textView setContentOffset:CGPointMake(0, -self.topLayoutGuide.length) animated:YES];
}

@end
