//
//  OTOHelpManager.h
//  OnatoFAQs
//
//  Created by Stephen Williams on 28/06/14.
//  Copyright (c) 2014 Onato. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OTOHelpManager : NSObject

@property (nonatomic, copy) NSString *contact;
@property (nonatomic, copy) NSArray *faqs;
@property (nonatomic, copy) NSString *style;

- (void)GET:(NSString *)URLString
    success:(void (^)(NSArray *faqs, NSString *contact))success
    failure:(void (^)(NSURLResponse *response, NSError *connectionError))failure;

- (NSAttributedString *)attributedContact;

@end
