//
//  OTOHelpManager.m
//  OnatoFAQs
//
//  Created by Stephen Williams on 28/06/14.
//  Copyright (c) 2014 Onato. All rights reserved.
//

#import "OTOHelpManager.h"
#import "OTOFAQ.h"
#import <MMMarkdown/MMMarkdown.h>

@implementation OTOHelpManager

- (void)GET:(NSString *)URLString
    success:(void (^)(NSArray *faqs, NSString *contact))success
    failure:(void (^)(NSURLResponse *response, NSError *connectionError))failure
{
    __weak typeof(self) welf = self;
    NSURL *URL = [NSURL URLWithString:URLString];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:
     ^(NSURLResponse *response, NSData *data, NSError *connectionError) {
         NSError *error;
         id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
         if ([jsonObject isKindOfClass:[NSDictionary class]]) {
             [welf parseHelpDict:(NSDictionary *)jsonObject];
             success(welf.faqs, welf.contact);
         }else{
             failure(response, connectionError);
         }
     }];
}

- (void)parseHelpDict:(NSDictionary *)helpDict
{
    NSArray *faqArray = helpDict[@"faqs"];
    self.contact = helpDict[@"contact"];
    NSMutableArray *newArray = [NSMutableArray array];
    for (NSDictionary *faqDict in faqArray) {
        NSString *title = faqDict[@"title"];
        NSString *detail = faqDict[@"detail"];
        OTOFAQ *faq = [[OTOFAQ alloc] initWithTitle:title andDetail:detail];
        faq.style = self.style;
        [newArray addObject:faq];
    }
    self.faqs = [NSArray arrayWithArray:newArray];
}

- (void)setContact:(NSString *)contact
{
    NSError *error;
    NSString *html = [MMMarkdown HTMLStringWithMarkdown:contact error:&error];
    NSAssert(!error, @"Contact Markdown Error: %@", error.localizedDescription);
    _contact = html;
}

- (NSAttributedString *)attributedContact
{
    NSString *markdown = [NSString stringWithFormat:@"%@", self.contact];
    
    NSError *error;
    NSString *html = [MMMarkdown HTMLStringWithMarkdown:markdown error:&error];
    NSAssert(!error, @"Markdown Error: %@", error.localizedDescription);
    
    html = [NSString stringWithFormat:@"<html>%@<body class=\"contact\">%@</body></html>", self.style, html];
    
    NSDictionary *options = @{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType};
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:24.0]};
    NSAttributedString *detail = [[NSAttributedString alloc] initWithData:[html dataUsingEncoding:NSUTF8StringEncoding]
                                                                  options:options
                                                       documentAttributes:&attributes
                                                                    error:&error];
    return detail;
}

- (NSString *)style
{
    if (!_style) {
        _style = @"<style>\
            * {font-family: 'HelveticaNeue';} \
            body { font-size: 15px; color:black; } \
            .contact { color:gray; } \
            img {max-width:290px; } \
            </style>";
    }
    return _style;
}

@end
