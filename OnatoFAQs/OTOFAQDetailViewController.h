//
//  OTOFAQDetailViewController.h
//  OnatoFAQs
//
//  Created by Stephen Williams on 27/06/14.
//  Copyright (c) 2014 Onato. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OTOFAQ;

@interface OTOFAQDetailViewController : UIViewController

@property (nonatomic, strong) OTOFAQ *faq;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end
