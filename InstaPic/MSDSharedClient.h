//
//  MSDSharedClient.h
//  InstaPic
//
//  Created by Matthew Dobson on 9/21/13.
//  Copyright (c) 2013 Matthew Dobson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ApigeeiOSSDK/ApigeeDataClient.h>

@interface MSDSharedClient : NSObject

+(ApigeeDataClient *) sharedClient;
+(void)initWithOrg:(NSString*)organization andApp:(NSString*)application;

@end
