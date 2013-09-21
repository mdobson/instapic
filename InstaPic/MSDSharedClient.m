//
//  MSDSharedClient.m
//  InstaPic
//
//  Created by Matthew Dobson on 9/21/13.
//  Copyright (c) 2013 Matthew Dobson. All rights reserved.
//

#import "MSDSharedClient.h"
#import <ApigeeiOSSDK/ApigeeClient.h>

@implementation MSDSharedClient

static ApigeeClient * client = nil;
static NSString *org;
static NSString *app;

+(void)initWithOrg:(NSString *)organization andApp:(NSString *)application {
    org = organization;
    app = application;
    client = [[ApigeeClient alloc] initWithOrganizationId:org applicationId:app];
}

+(ApigeeDataClient *)sharedClient {
    return [client dataClient];
}

@end
