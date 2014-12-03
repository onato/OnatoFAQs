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

@end
