//
//  MSDFeedViewController.h
//  InstaPic
//
//  Created by Matthew Dobson on 9/21/13.
//  Copyright (c) 2013 Matthew Dobson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MSDFeedViewController : UIViewController

@property (nonatomic, retain) NSArray *activities;
@property (nonatomic, retain) IBOutlet UITableView *table;

@end
