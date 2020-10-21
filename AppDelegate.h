//
//  AppDelegate.h
//  Imprint
//
//  Created by Geoff Baker on 13/09/2018.
//  Copyright © 2018 ICN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

