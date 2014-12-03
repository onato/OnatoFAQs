//
//  OTOFAQ.h
//  OnatoFAQs
//
//  Created by Stephen Williams on 27/06/14.
//  Copyright (c) 2014 Onato. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OTOFAQ : NSObject

@property (nonatomic, copy, readonly) NSString *title;
@property (nonatomic, copy, readonly) NSString *detail;
@property (nonatomic, copy) NSString *style;

- (instancetype)initWithTitle:(NSString *)title andDetail:(NSString *)detail;
- (NSAttributedString *)attributedText;

@end
