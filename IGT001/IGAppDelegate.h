//
//  IGAppDelegate.h
//  IGT001
//
//  Created by Ming Liu lipeng on 12-4-30.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IGMainViewController.h"
#import "IGA01ViewController.h"
#import "IGCoreDataUtil.h"
#import "IGPlanUtil.h"


@interface IGAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@property (strong, nonatomic) IGMainViewController *mainViewController;

@end
