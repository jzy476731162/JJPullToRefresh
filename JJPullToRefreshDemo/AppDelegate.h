//
//  AppDelegate.h
//  JJPullToRefreshDemo
//
//  Created by Jox.J on 17/05/2017.
//  Copyright © 2017 Jox.J. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

