//
//  OTOFAQTableViewController.m
//  OnatoFAQs
//
//  Created by Stephen Williams on 27/06/14.
//  Copyright (c) 2014 Onato. All rights reserved.
//

#import "OTOFAQTableViewController.h"
#import "OTOFAQDetailViewController.h"
#import "OTOHelpManager.h"
#import "OTOFAQ.h"

@interface OTOFAQTableViewController ()

@property (nonatomic, strong) OTOHelpManager *helpManager;
@property (nonatomic, strong) NSArray *filteredSearchResults;

@end

@implementation OTOFAQTableViewController

- (NSString *)appName
{
    if (!_appName) {
        NSDictionary* infoDict = [[NSBundle mainBundle] infoDictionary];
        _appName = [infoDict objectForKey:@"OnatoHelpAppName"];
        if (!_appName) {
            _appName = [[NSBundle mainBundle] bundleIdentifier];
        }
    }
    return _appName;
}

- (NSString *)language
{
    if (!_language) {
        _language = [[NSLocale preferredLanguages] objectAtIndex:0];
    }
    return _language;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.helpManager = [[OTOHelpManager alloc] init];

    __weak typeof(self) welf = self;
//    NSString *server = @"http://development.onato.com";
    NSString *server = @"http://localhost:8888/";
    NSString *urlString = [NSString stringWithFormat:@"%@/FAQs/json.php?appName=%@&language=%@",
                           server, self.appName, self.language];

    [self.helpManager GET:urlString
                  success:^(NSArray *faqs, NSString *contact)
    {
              welf.filteredSearchResults = welf.helpManager.faqs;
              [welf.tableView reloadData];
              [welf setupFooter];
          } failure:^(NSURLResponse *response, NSError *connectionError) {
              NSLog(@"Error: %@", connectionError);
          }];
}

- (void)setupFooter
{
    self.contactTextView.textContainerInset = UIEdgeInsetsMake(25, 10, 0, 10);
    [self.contactTextView setAttributedText:self.helpManager.attributedContact];

    self.tableView.tableFooterView.frame = ({
        CGRect frame = self.tableView.tableFooterView.frame;
        frame.size = [self.contactTextView sizeThatFits:CGSizeMake(CGRectGetWidth(self.view.frame), FLT_MAX)];
        frame;
    });

    // Force Resize
    self.tableView.tableFooterView = self.tableView.tableFooterView;

}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"title CONTAINS[cd] %@ OR detail CONTAINS[cd] %@", searchString, searchString];
    self.filteredSearchResults = [self.helpManager.faqs filteredArrayUsingPredicate:predicate];

    return YES;
}

#pragma mark - Table View

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.filteredSearchResults.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

    OTOFAQ *faq;
    if ([tableView isEqual:self.tableView]) {
        if (indexPath.item < self.helpManager.faqs.count) {
            faq = self.helpManager.faqs[indexPath.item];
        }
    }else{
        if (indexPath.item < self.filteredSearchResults.count) {
            faq = self.filteredSearchResults[indexPath.item];
        }else{
            UITextView *textView = [NSKeyedUnarchiver
                            unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:self.contactTextView]];
            textView.textContainerInset = UIEdgeInsetsMake(25, 10, 0, 10);
            [cell addSubview:textView];
        }
    }
    
    if (faq) {
        NSCharacterSet *whiteSpaceAndNewlines = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        NSString *title = [[faq.title substringFromIndex:1] stringByTrimmingCharactersInSet:whiteSpaceAndNewlines];
        [cell.textLabel setText:[NSString stringWithFormat:@"%@", title]];
    }else{
        [cell.textLabel setText:@""];
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.item >= self.filteredSearchResults.count) {
        if ([tableView isEqual:self.tableView]) {
            return 0;
        }else{
            return CGRectGetHeight(self.contactTextView.frame);
        }
    }
    return 94;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    OTOFAQDetailViewController *detailViewController = [segue destinationViewController];
    OTOFAQ *faq = self.filteredSearchResults[self.tableView.indexPathForSelectedRow.item];

    detailViewController.faq = faq;
    
}

@end
