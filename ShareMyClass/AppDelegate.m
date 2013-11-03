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
#import "MessagesViewController.h"

@interface AppDelegate ()

@property (strong, nonatomic) UINavigationController* navController;
@property (strong, nonatomic) ViewController *mainViewController;

@end

@implementation AppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;


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
                
                [FBRequestConnection
                 startWithGraphPath:@"me?fields=id,first_name,last_name"
                 completionHandler:^(FBRequestConnection *connection,
                                     id result,
                                     NSError *error) {
                     if (!error)
                     {
                         [self registerUser:result];
                     }
                 }];
            
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


#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"ShareMyClassData" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"ShareMyClassData.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
       
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}


-(void)registerUser:(id)userData
{
    NSURL *url = [NSURL URLWithString:@"http://192.241.224.160/ShareMyClass/ShareMyClassApi/api.php?"];
    //URL a usar para mandar los parametros en este caso utilizo mi pagina ejemplo
    
	NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url
                                                       cachePolicy:NSURLRequestReloadIgnoringCacheData
                                                   timeoutInterval:60];
	
	[req setHTTPMethod:@"POST"];	//indicamos que es un metodo POST
	[req setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
	//Indicamos en que formato esta lo que mandamos
    
    //Valor del post
    NSString *postData = [NSString stringWithFormat:@"cmd=join&idAlumno=%@&nombre=%@&apellidos=Omaña",[userData objectForKey:@"id"], [userData objectForKey:@"first_name"]]; //Mandamos el valor
	
    NSString *correctString = [NSString stringWithCString:[postData cStringUsingEncoding:NSISOLatin1StringEncoding] encoding:NSUTF8StringEncoding];
    
    NSLog(@"%@",correctString);

//    NSLog(@"%@",postData);
	NSString *length = [NSString stringWithFormat:@"%d", [postData length]];
	[req setValue:length forHTTPHeaderField:@"Content-Length"];   //indicamos en nuestro paquete el tamaño de
    //nuestros datos
	
    NSLog(@" tamano: %d", postData.length); //Podemos imprimir nuestro datos para saber cuales son
    
	[req setHTTPBody:[postData dataUsingEncoding:NSASCIIStringEncoding]]; //Mandamos el contenido de este
    
	NSHTTPURLResponse* urlResponse = nil; //Vemos nuestra respuesta
	NSError *error = [[NSError alloc] init];  //creamos un parametro valor, donde nos servira mucho para
    //debugiar algunos errores generados
	
	NSData *responseData = [NSURLConnection sendSynchronousRequest:req
                                                 returningResponse:&urlResponse
                                                             error:&error];
    //Guardamos los parametros que obtuvimos en la respuesta
    NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSASCIIStringEncoding]; //Guardamos en estring
     NSLog(@"Respueta: %@", responseString); //imprimimos lo obtenido

}




@end
