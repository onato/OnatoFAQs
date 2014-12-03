//
//  OTOFAQTableViewController.h
//  OnatoFAQs
//
//  Created by Stephen Williams on 27/06/14.
//  Copyright (c) 2014 Onato. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OTOFAQTableViewController : UITableViewController <UISearchDisplayDelegate>

/**
 Defaults to the bundle identifier.
 You can also set it in your info.plist with the key OnatoHelpAppName.
 */
@property (nonatomic, copy) NSString *appName;

/**
 Defaults to [[NSLocale preferredLanguages] objectAtIndex:0].
 */
@property (nonatomic, copy) NSString *language;

//@property (nonatomic, strong) IBOutlet UISearchBar *searchBar;
@property (nonatomic, weak) IBOutlet UITextView *contactTextView;

@end
