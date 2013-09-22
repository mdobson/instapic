//
//  MSDFollowViewController.h
//  InstaPic
//
//  Created by Matthew Dobson on 9/21/13.
//  Copyright (c) 2013 Matthew Dobson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ApigeeiOSSDK/ApigeeCollection.h>

@interface MSDFollowViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSArray *users;
@property (nonatomic, strong) IBOutlet UITableView *table;

@end
