//
//  OTOFAQ.m
//  OnatoFAQs
//
//  Created by Stephen Williams on 27/06/14.
//  Copyright (c) 2014 Onato. All rights reserved.
//

#import "OTOFAQ.h"
#import <MMMarkdown/MMMarkdown.h>

@interface OTOFAQ ()

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *detail;

@end

@implementation OTOFAQ

- (instancetype)initWithTitle:(NSString *)title andDetail:(NSString *)detail
{
    self = [super init];
    if (self) {
        _title = title;
        _detail = detail;
    }
    return self;
}

- (NSAttributedString *)attributedText
{
    NSString *markdown = [NSString stringWithFormat:@"%@\n%@", self.title, self.detail];
    
    NSError *error;
    NSString *html = [MMMarkdown HTMLStringWithMarkdown:markdown error:&error];
    NSAssert(!error, @"Markdown Error: %@", error.localizedDescription);
    
    html = [NSString stringWithFormat:@"<html>%@<body>%@</body></html>", self.style, html];
    
    NSDictionary *options = @{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType};
   
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:24.0]};
    NSAttributedString *detail = [[NSAttributedString alloc] initWithData:[html dataUsingEncoding:NSUnicodeStringEncoding]
                                                                  options:options
                                                       documentAttributes:&attributes
                                                                    error:&error];
    return detail;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@: %@", NSStringFromClass([self class]), self.title];
}

@end
