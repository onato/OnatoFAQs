//
//  OTOFAQContactCell.m
//  OnatoFAQs
//
//  Created by Stephen Williams on 18/02/15.
//  Copyright (c) 2015 Onato. All rights reserved.
//

#import "OTOFAQContactCell.h"

@implementation OTOFAQContactCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.contactTextView.textContainerInset = UIEdgeInsetsMake(25, 10, 0, 10);
}

@end
