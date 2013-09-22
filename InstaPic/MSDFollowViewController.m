//
//  MSDFollowViewController.m
//  InstaPic
//
//  Created by Matthew Dobson on 9/21/13.
//  Copyright (c) 2013 Matthew Dobson. All rights reserved.
//

#import "MSDFollowViewController.h"
#import "MSDSharedClient.h"
#import <ApigeeiOSSDK/ApigeeUser.h>
#import <ApigeeiOSSDK/ApigeeQuery.h>

@interface MSDFollowViewController ()

@end

@implementation MSDFollowViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.users.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    NSDictionary *userDict = self.users[indexPath.row];
    cell.textLabel.text = userDict[@"username"];
    return cell;
}

-(void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *userDict = self.users[indexPath.row];
    NSString *username = userDict[@"username"];
    ApigeeUser *user = [[MSDSharedClient sharedClient] getLoggedInUser];
    [[MSDSharedClient sharedClient] connectEntities:@"users"
                                        connectorID:user.username
                                     connectionType:@"following"
                                      connecteeType:@"users"
                                        connecteeID:username
                                  completionHandler:^(ApigeeClientResponse *response){
                                      if (response.transactionState == kApigeeClientResponseSuccess) {
                                          NSLog(@"good");
                                      } else {
                                          NSLog(@"Bad");
                                      }
                                  }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Custom initialization
    ApigeeUser *user = [[MSDSharedClient sharedClient] getLoggedInUser];
    ApigeeQuery *query = [[ApigeeQuery alloc] init];
    NSString *queryString = [NSString stringWithFormat:@"WHERE NOT username='%@'", user.username];
    [query addRequirement:queryString];
    [[MSDSharedClient sharedClient] getEntities:@"users" query:query completionHandler:^(ApigeeClientResponse *response){
        
        if (response.transactionState == kApigeeClientResponseSuccess) {
            self.users = response.response[@"entities"];
            [[self table] reloadData];
        } else {
            NSLog(@"error");
        }
    }];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
