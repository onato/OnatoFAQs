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
#import "OTOFAQContactCell.h"

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
              welf.filteredSearchResults = faqs;
              [welf.tableView reloadData];
          } failure:^(NSURLResponse *response, NSError *connectionError) {
              NSLog(@"Error: %@", connectionError);
          }];
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    if (searchString.length == 0) {
        self.filteredSearchResults = self.helpManager.faqs;
    }else{
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"title CONTAINS[cd] %@ OR detail CONTAINS[cd] %@", searchString, searchString];
        self.filteredSearchResults = [self.helpManager.faqs filteredArrayUsingPredicate:predicate];
    }

    return YES;
}

#pragma mark - Table View

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.filteredSearchResults.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    static NSString *ContactCellIdentifier = @"ContactCell";
    

    UITableViewCell *cell;
    OTOFAQ *faq;
    if (indexPath.item < self.filteredSearchResults.count) {
        cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        faq = self.filteredSearchResults[indexPath.item];
        NSCharacterSet *whiteSpaceAndNewlines = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        NSString *title = [[faq.title substringFromIndex:1] stringByTrimmingCharactersInSet:whiteSpaceAndNewlines];
        [cell.textLabel setText:[NSString stringWithFormat:@"%@", title]];
    }else{
        OTOFAQContactCell *contactCell = [self.tableView dequeueReusableCellWithIdentifier:ContactCellIdentifier
                                                                              forIndexPath:indexPath];
        //[contactCell.contactTextView setText:self.helpManager.contact];
        [contactCell.contactTextView setAttributedText:self.helpManager.attributedContact];
        cell = contactCell;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.item >= self.filteredSearchResults.count) {
        return 150;
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
