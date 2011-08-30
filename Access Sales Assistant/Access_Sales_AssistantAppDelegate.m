//
//  Access_Sales_AssistantAppDelegate.m
//  Access Sales Assistant
//
//  Created by Ross Chapman on 6/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Access_Sales_AssistantAppDelegate.h"

#import "HTTPOperationController.h"

#import "RootViewController.h"

#import "BaseDetailViewController.h"

#import "VisitApplicationViewController.h"

#import "SplashViewController.h"

#import "LoginViewController.h"

#import "User.h"

#import "ASIHTTPRequest.h"

#import "VisitApplicationProducerProfileTableViewController.h"

#import "CLLocationController.h"

#import "FlurryAnalytics.h"

#import "VisitApplicationMapViewController.h"

@implementation Access_Sales_AssistantAppDelegate

@synthesize window = _window;
@synthesize splitViewController = _splitViewController;
@synthesize mgSplitViewController = _mgSplitViewController;
@synthesize loginController = _loginController;
@synthesize isDidFinishLaunching;

- (void)loginFailed:(ASIHTTPRequest *)request
{
	/*LoginViewController *viewController*/
    
    LoginViewController *viewController= [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
	[viewController setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
	[viewController setModalPresentationStyle:UIModalPresentationFormSheet];
	[self.mgSplitViewController presentModalViewController:viewController animated:YES];
}

- (void)showError:(id)notification
{
	ASIHTTPRequest *request = (ASIHTTPRequest *)[notification object];
	NSError *error = [request error];
	NSLog(@"Request Error: %@", [error localizedDescription]);
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
	[alertView show];
}

-(void) loginSuccess:(id) sender
{
   if(isDidFinishLaunching)
   {
    
       NSArray *producersArray = [Producer findAllSortedBy:@"nextScheduledVisit" ascending:YES];
	NSMutableArray *daysArray = [NSMutableArray arrayWithCapacity:[producersArray count]];
	for (Producer *producer in producersArray) {
		if (![daysArray containsObject:producer.nextScheduledVisitDate] && (producer.nextScheduledVisitDate != nil)) {
			[daysArray addObject:producer.nextScheduledVisitDate];
		}
	}
    if([daysArray count])
    {
        NSArray* viewControllerArr =   [ self.mgSplitViewController viewControllers ];
        VisitApplicationMapViewController *detailViewController = [[VisitApplicationMapViewController alloc] initWithNibName:@"VisitApplicationMapViewController" bundle:nil];
        self.mgSplitViewController.viewControllers = [NSArray arrayWithObjects:[viewControllerArr objectAtIndex:0],detailViewController,nil];
        detailViewController.splitviewcontroller = self.mgSplitViewController;
        
         if([daysArray count])
             [detailViewController setSelectedDay:[daysArray objectAtIndex:0]];   
        
        
        UINavigationController* navController = [viewControllerArr objectAtIndex:0];
        RootViewController *rootController = (RootViewController *)[navController.viewControllers objectAtIndex:0];
        if(rootController)
        {
            rootController.detailViewController = detailViewController;
            
            [rootController displayTopMenuItem];
        }
    }
   }
    /*   
     UIBarButtonItem *rootPopoverButtonItem = controller.rootPopoverButtonItem;
     // if(orientation == 0)
     //     orientation = self.detailViewController.interfaceOrientation;
     
     if(UIDeviceOrientationIsPortrait(orientation))
     {
     
     [detailViewController showRootPopoverButtonItem:rootPopoverButtonItem];
     
     }
     else
     [detailViewController invalidateRootPopoverButtonItem:rootPopoverButtonItem];
     */  
    
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	// Setup the Core Data Stack
	[ActiveRecordHelpers setupCoreDataStackWithAutoMigratingSqliteStoreNamed:@"Access_Sales_Assistant.sqlite"];
	
	[NSManagedObjectContext setDefaultContext:[NSManagedObjectContext context]];
	
    // Override point for customization after application launch.
	self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	
	RootViewController *controller = [[RootViewController alloc] initWithNibName:@"RootViewController" bundle:nil];
	UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
	
	//VisitApplicationViewController *detailViewController = [[VisitApplicationViewController alloc] initWithNibName:@"VisitApplicationViewController" bundle:nil];
    
    SplashViewController* detailViewController = [[SplashViewController alloc] initWithNibName:@"SplashViewController" bundle:nil];
    
	// VisitApplicationProducerProfileTableViewController* detailViewController = [[VisitApplicationProducerProfileTableViewController alloc] initWithNibName:@"VisitApplicationProducerProfileTableViewController" bundle:nil];
	
    //TODO: Need to uncomment below code
	/*	self.splitViewController = [[UISplitViewController alloc] init];
	 self.splitViewController.delegate = controller;
	 controller.splitViewController = self.splitViewController;
	 self.splitViewController.viewControllers = [NSArray arrayWithObjects:navigationController, detailViewController, nil];
	 controller.detailViewController = detailViewController;
     */
    
    //MGSplitviewcontroller 
    self.mgSplitViewController = [[MGSplitViewController alloc] init];
    self.mgSplitViewController.viewControllers = [NSArray arrayWithObjects:navigationController, detailViewController, nil];
    self.mgSplitViewController.delegate = controller;
    controller.mgSplitViewController = self.mgSplitViewController;
    detailViewController.splitviewcontroller = self.mgSplitViewController;
	controller.detailViewController = detailViewController;
    
	[FlurryAnalytics startSession:@"Y1A8YRZTCUKUTUYY9M43"];
    
    isDidFinishLaunching = TRUE;
    
    
	/*  MGSplitViewDividerStyle newStyle = ((self.mgSplitViewController.dividerStyle == MGSplitViewDividerStyleThin) ? MGSplitViewDividerStylePaneSplitter : MGSplitViewDividerStyleThin);
	 [self.mgSplitViewController setDividerStyle:newStyle animated:YES];
	 */
    
	
    self.window.rootViewController = self.mgSplitViewController;
    
    
    
	//self.window.rootViewController = self.splitViewController;
    [self.window makeKeyAndVisible];
	
	//[self loginFailed:nil];
	
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
	/*
	 Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	 Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
	 */
	[[CLLocationController sharedCLLocationController] stopUpdatingCurrentLocation];
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    isDidFinishLaunching = FALSE;
	/*
	 Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
	 If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
	 */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
	/*
	 Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
	 */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
	/*
	 Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
	 */
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginFailed:) name:@"Login Failure" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showError:) name:@"Post Producer Failure" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showError:) name:@"Post Summary Failure" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showError:) name:@"Post Image Failure" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showError:) name:@"Get Images Failure" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showError:) name:@"Get Image Failure" object:nil];
    
    	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccess:) name:@"Launch Map" object:nil];
	
	[[CLLocationController sharedCLLocationController] startUpdatingCurrentLocation];
	
	[[HTTPOperationController sharedHTTPOperationController] login];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
	/*
	 Called when the application is about to terminate.
	 Save data if appropriate.
	 See also applicationDidEnterBackground:.
	 */
	[ActiveRecordHelpers cleanUp];
}

@end
