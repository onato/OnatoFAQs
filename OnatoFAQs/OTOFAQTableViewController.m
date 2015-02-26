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

static const NSInteger kCONTACT_SECTION = 1;

@interface OTOFAQTableViewController ()

@property (nonatomic, strong) OTOHelpManager *helpManager;
@property (nonatomic, strong) NSArray *filteredSearchResults;

@end

@implementation OTOFAQTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.helpManager = [[OTOHelpManager alloc] init];

    __weak typeof(self) welf = self;
    NSString *server = [self configForKey:@"Server"];
    NSString *urlString = [NSString stringWithFormat:[self configForKey:@"RequestURLFormat"],
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

/////////////////////////////////////////////////////////////
#pragma mark - Search
/////////////////////////////////////////////////////////////

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

/////////////////////////////////////////////////////////////
#pragma mark - Table View
/////////////////////////////////////////////////////////////

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == kCONTACT_SECTION) {
        return 1;
    }else if([tableView isEqual:self.tableView]) {
        return self.helpManager.faqs.count;
    }
    return self.filteredSearchResults.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    static NSString *ContactCellIdentifier = @"ContactCell";
    

    UITableViewCell *cell;
    OTOFAQ *faq;
    if (indexPath.section == 0) {
        cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if ([tableView isEqual:self.tableView]) {
            faq = self.helpManager.faqs[indexPath.item];
        }else{
            faq = self.filteredSearchResults[indexPath.item];
        }
        NSCharacterSet *whiteSpaceAndNewlines = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        NSString *title = [[faq.title substringFromIndex:1] stringByTrimmingCharactersInSet:whiteSpaceAndNewlines];
        [cell.textLabel setText:[NSString stringWithFormat:@"%@", title]];
    }else{
        OTOFAQContactCell *contactCell = [self.tableView dequeueReusableCellWithIdentifier:ContactCellIdentifier];
        //[contactCell.contactTextView setText:self.helpManager.contact];
        [contactCell.contactTextView setAttributedText:self.helpManager.attributedContact];
        cell = contactCell;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
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

/////////////////////////////////////////////////////////////
#pragma mark - Config
/////////////////////////////////////////////////////////////

- (NSString *)appName
{
    if (!_appName) {
        _appName = [self configForKey:@"AppName"];
        if (!_appName) {
            _appName = [[NSBundle mainBundle] bundleIdentifier];
        }
    }
    return _appName;
}

- (NSString *)language
{
    if (!_language) {
        /* Note: We just ask for the language. The server should check if it exist
         and if not send a default language.
         */
        _language = [[NSLocale preferredLanguages] objectAtIndex:0];
    }
    return _language;
}

- (NSString *)configForKey:(NSString *)key
{
    return [self configDict][key];
}

- (NSDictionary *)configDict
{
    NSString *fileName = @"OTOFAQs.plist";
#ifdef DEBUG
    NSString *debugFileName = @"OTOFAQs-local.plist";
    NSString *pathAndFileName = [[NSBundle mainBundle] pathForResource:debugFileName ofType:nil];
    if ([[NSFileManager defaultManager] fileExistsAtPath:pathAndFileName])
    {
        fileName = debugFileName;
    }
#endif
    
    NSURL *file = [[NSBundle mainBundle] URLForResource:fileName withExtension:nil];
    return [NSDictionary dictionaryWithContentsOfURL:file];
}

@end
