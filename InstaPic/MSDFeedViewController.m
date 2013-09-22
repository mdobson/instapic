//
//  MSDFeedViewController.m
//  InstaPic
//
//  Created by Matthew Dobson on 9/21/13.
//  Copyright (c) 2013 Matthew Dobson. All rights reserved.
//

#import "MSDFeedViewController.h"
#import "MSDSharedClient.h"

@interface MSDFeedViewController ()

@end

@implementation MSDFeedViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.activities.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    NSDictionary *dict = self.activities[indexPath.row];
    cell.textLabel.text = dict[@"content"];
    return cell;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    ApigeeUser *user = [[MSDSharedClient sharedClient] getLoggedInUser];
    [[MSDSharedClient sharedClient] getActivityFeedForUser:user.username
                                                   query:nil
                                       completionHandler:^(ApigeeClientResponse *response){
                                           if (response.transactionState == kApigeeClientResponseSuccess) {
                                               self.activities = response.response[@"entities"];
                                               NSLog(@"%@", response.response[@"entities"]);
                                               [self.table reloadData];
                                           } else {
                                               NSLog(@"Can't get feed.");
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
