//
//  AppDelegate.m
//  ShareMyClass
//
//  Created by carlos omana on 07/10/13.
//  Copyright (c) 2013 ITESM. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import "loginViewController.h"
@interface AppDelegate ()

@property (strong, nonatomic) UINavigationController* navController;
@property (strong, nonatomic) ViewController *mainViewController;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.mainViewController = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
    self.navController = [[UINavigationController alloc] initWithRootViewController:self.mainViewController];
    self.window.rootViewController = self.navController;
    [self.window makeKeyAndVisible];
    if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded) {
        // Yes, so just open the session (this won't display any UX).
        [self openSession];
    } else {
        // No, display the login page.
        [self showLoginView];
    }
    return YES;
}

- (void)showLoginView
{
    UIViewController *topViewController = [self.navController topViewController];
    UIViewController *modalViewController = [topViewController presentedViewController];
    
    // If the login screen is not already displayed, display it. If the login screen is
    // displayed, then getting back here means the login in progress did not successfully
    // complete. In that case, notify the login view so it can update its UI appropriately.
    if (![modalViewController isKindOfClass:[loginViewController class]]) {
        loginViewController* loginViewControllerVar = [[loginViewController alloc]
                                                      initWithNibName:@"loginViewController"
                                                      bundle:nil];
        [topViewController presentViewController:loginViewControllerVar animated:NO completion:nil];
    } else {
        loginViewController* loginViewControllerVar = (loginViewController*)modalViewController;
        [loginViewControllerVar loginFailed];
    }
    
    
    
}
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)sessionStateChanged:(FBSession *)session
                      state:(FBSessionState) state
                      error:(NSError *)error
{
    switch (state) {
        case FBSessionStateOpen: {
            UIViewController *topViewController = [self.navController topViewController];
            if ([[topViewController presentedViewController] isKindOfClass:[loginViewController class]]) {
                //[topViewController dismissModalViewControllerAnimated:YES];
                //[presentViewController:topViewController animated:NO completion:nil];
                [topViewController dismissViewControllerAnimated:NO completion:Nil];
            }
        }
            break;
        case FBSessionStateClosed:
        case FBSessionStateClosedLoginFailed:
            // Once the user has logged in, we want them to
            // be looking at the root view.
            [self.navController popToRootViewControllerAnimated:NO];
            
            [FBSession.activeSession closeAndClearTokenInformation];
            
            [self showLoginView];
            break;
        default:
            break;
    }
    
    if (error) {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Error"
                                  message:error.localizedDescription
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
    }
}

- (void)openSession
{
    
    NSArray *permission = [[NSArray alloc] initWithObjects:@"email", nil];
    FBSession *sessions = [[FBSession alloc] initWithPermissions:permission];
    [FBSession setActiveSession:sessions];
    [sessions openWithBehavior:FBSessionLoginBehaviorForcingWebView
            completionHandler:^(FBSession *session,
                                FBSessionState status,
                                NSError *error) {
                NSLog(@"%@",[session accessTokenData]);
                [self sessionStateChanged:session state:status error:error];
            }];
}


- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return [FBSession.activeSession handleOpenURL:url];
}

@end
