//
//  FeaturesAndBenefitsViewController.m
//  Access Sales Assistant
//
//  Created by Easwara Reddy Illuri on 7/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FeaturesAndBenefitsViewController.h"
#import "RootViewController.h"

#import "StateSelectionTableViewController.h"
#import "Features.h"
@implementation FeaturesAndBenefitsViewController

@synthesize _accessInternationalDrivers;
@synthesize _accessBusiness;
@synthesize _multilingualCompany;
@synthesize _salvageTitles;
@synthesize _weDonotDirect;
@synthesize _namedNonOwnerPolicy;
@synthesize _registeredOwnerDiscounts;
@synthesize _multiFamilyPolicy;
@synthesize _acceptUpto2DUIs;
@synthesize _noCreditScoreorTiers;
@synthesize _multiplePaymentOptions;
@synthesize _changeStateButton;
@synthesize stateViewController=_stateViewController;
@synthesize fnbScrollview=_fnbScrollview;
@synthesize navigationBar;
@synthesize toolBar;
@synthesize currentStateCode;
@synthesize currentStateName;


#define SR22FEATURE @"AZ",@"CA",@"SC",nil
#define LIMITEDPOLICYFEATURE @"CA",@"TX",nil
#define MARKETNICHE @"Market Niche"
#define LOWRATES @"Low Rates"
#define EASEOFUSE @"Ease of Use"
#define CLAIMS @"Claims"
#define SR22 @"SR-22"
#define LIMITEDPOLICY @"Limited Policy"
#define FNBFEATURES @"Market Niche",@"Low Rates",@"Ease of Use",@"Claims",nil
#define MARKETNICHEFEATURES @"FDL Accepted",@"Biz/Artisan use",@"ADD Coverage",@"Multi Lingual",@"Salvage Titles",@"We don't go Direct",@"Non-Owner Policies",@"Registered Owner Discounts",@"Multi Family Policy",@"Accept DUI",@"Credit Cards on Down Payment",@"SR-22",@"Limited Policy",nil
#define LOWRATESFEATURES @"Low down pay",@"No Credit Scoring",@"No CC Fees",@"Paid as Earned",nil
#define EASEOFUSEFEATURES @"No Taxing",@"Access website",@"24/7 automated",@"Responsive Prod Support",@"59 Day Reinstate",@"No Production Requirement",@"Retention Calls",@"Visible Sales Force",@"No Charge for MVR",@"Real Time",@"Flexible Billing",@"iPhone app",nil
#define CLAIMSFEATURES @"70% settled in 7 days 90% in 30 days",@"Talk directly to adjuster",@"Pick your body shop",@"Claims Hours",nil

#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define RGBA(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

#pragma mark Managing the popover

/*- (void)showRootPopoverButtonItem:(UIBarButtonItem *)barButtonItem {
    // Add the popover button to the left navigation item.
    [navigationBar.topItem setLeftBarButtonItem:barButtonItem animated:NO];
}


- (void)invalidateRootPopoverButtonItem:(UIBarButtonItem *)barButtonItem {
    // Remove the popover button.
    [navigationBar.topItem setLeftBarButtonItem:nil animated:NO];
}
*/
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.baseNavigationBar = self.navigationBar;
    self.baseToolbar = self.toolBar;
    [_fnbScrollview setBackgroundColor:[UIColor blackColor]];
    
#if TARGET_IPHONE_SIMULATOR
    [self selectedState:@"Georgia" :@"GA"];
#else
	[self selectedState:@"Georgia" :@"GA"];
    //[[SSLocationManager sharedManager] addDelegate:self];
    //[[SSLocationManager sharedManager] startUpdatingCurrentLocation];
#endif
    
    
   // [self selectedState:@"California" :@"CA"];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    //[self selectedState:self.currentStateName :self.currentStateCode];
    
    [self.fnbScrollview setNeedsDisplay];
}
-(IBAction)selectState:(id)sender
{
    UIButton *button = (UIButton *)sender;
    if(self.stateViewController == nil)
    {
        self.stateViewController = [[StateSelectionTableViewController alloc] initWithStyle:UITableViewStylePlain];
    
 
    
    _popOverController  = [[UIPopoverController alloc] initWithContentViewController:self.stateViewController];
    }
    
    self.stateViewController.currentSelectedState = self.currentStateName;
    
    [self.stateViewController setContentSizeForViewInPopover:CGSizeMake(300.0, 500.0)];
    
    [_popOverController presentPopoverFromRect:button.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
    self.stateViewController.delegate = self;
    
    
    
}
-(void) selectedState:(NSString*) stateName:(NSString*) stateCode
{
    [self.fnbScrollview setNeedsDisplay];
    
    self.currentStateCode = stateCode;
    self.currentStateName = stateName;
    NSString *path = [[NSBundle mainBundle] pathForResource:
                      @"FeaturesAndBenefitsList" ofType:@"plist"];
      NSDictionary *plistData = [NSDictionary dictionaryWithContentsOfFile:path];
    
    NSDictionary* featuresAndBenefits = [plistData objectForKey:stateName]; 
    
    [_changeStateButton setTitle:stateName forState:UIControlStateNormal];
    
    NSArray *sr22FeatureStates = [[NSArray alloc] initWithObjects:SR22FEATURE];
    NSArray *limitedPolicyFeatureStats = [[NSArray alloc] initWithObjects:LIMITEDPOLICYFEATURE];
    
    NSMutableArray* featureObjArray;
    
    featureObjArray = [NSMutableArray array];
    NSArray* fnbFeaturesArray = [[NSArray alloc] initWithObjects:FNBFEATURES];

    for(int fKey = 0; fKey<[plistData count];fKey++)
    {
       // NSArray * arr= [[plistData allKeys] so]
        NSString *keyValue = [fnbFeaturesArray objectAtIndex:fKey];
        NSDictionary* tDictionary = [plistData objectForKey:keyValue];
        
             
        Features* tFeatureObj = [[Features alloc]init];
        tFeatureObj.strFeature = [[NSString alloc] initWithString:keyValue];
        tFeatureObj.strBenefit = @"";
        tFeatureObj.bIsFeatureTitle = TRUE;
        [featureObjArray addObject:tFeatureObj];
        
        NSArray *arrKeysInOrder;
        if([keyValue isEqualToString:MARKETNICHE])
            arrKeysInOrder = [[NSArray alloc] initWithObjects:MARKETNICHEFEATURES];
        else if([keyValue isEqualToString:LOWRATES])
            arrKeysInOrder = [[NSArray alloc] initWithObjects:LOWRATESFEATURES];
        else if([keyValue isEqualToString:EASEOFUSE])
            arrKeysInOrder = [[NSArray alloc] initWithObjects:EASEOFUSEFEATURES];
        else if([keyValue isEqualToString:CLAIMS])
            arrKeysInOrder = [[NSArray alloc] initWithObjects:CLAIMSFEATURES];

        
        for(int fSubKey = 0;fSubKey<[tDictionary count];fSubKey++)
        {
            NSString *strSubKey  = [arrKeysInOrder objectAtIndex:fSubKey];
            NSString *strSubValue = [tDictionary objectForKey: strSubKey];
                 
            BOOL addFeature = TRUE;
            if([strSubKey isEqualToString:SR22])
            {
                addFeature = FALSE;
                for(int sCode =0; sCode < [sr22FeatureStates count];sCode++)
                {
                    if([stateCode isEqualToString:[sr22FeatureStates objectAtIndex:sCode]])
                    {
                        addFeature = TRUE;
                        break;
                    }
                }

            }
            else if([strSubKey isEqualToString:LIMITEDPOLICY])
            {
                addFeature = FALSE;
                for(int sCode =0; sCode < [limitedPolicyFeatureStats count];sCode++)
                {
                    if([stateCode isEqualToString:[limitedPolicyFeatureStats objectAtIndex:sCode]])
                    {
                        addFeature = TRUE;
                        break;
                    }
                }

            }
            if(addFeature)
            {
                Features* tFeatureObj1 = [[Features alloc]init];
                tFeatureObj1.strFeature = [[NSString alloc] initWithString:strSubKey];
                tFeatureObj1.strBenefit = [[NSString alloc] initWithString:strSubValue];
                tFeatureObj1.bIsFeatureTitle = FALSE;
            [featureObjArray addObject:tFeatureObj1];
            }
        }
    }
    
    [_fnbScrollview clearsContextBeforeDrawing];
    
 //   NSLog(@"array is: %@",featureObjArray);
    
    int fObjCount = [featureObjArray count];
    
    int scrollwidth =600;// [_fnbScrollview bounds].size.width;//686;
    
    
    
    [_fnbScrollview setBackgroundColor:[UIColor whiteColor]];
	[_fnbScrollview setCanCancelContentTouches:NO];
	_fnbScrollview.clipsToBounds = YES;	// default is NO, we want to restrict drawing within our scrollview
	_fnbScrollview.indicatorStyle = UIScrollViewIndicatorStyleWhite;
	
    
    _fnbScrollview.contentOffset = CGPointMake(0, 0);

    int xPos = [_fnbScrollview bounds].origin.x;
    int orgYPos = [_fnbScrollview bounds].origin.y;
    
    for(int fLabel =0; fLabel<[featureObjArray count];fLabel++)
    {
        Features *tFeaturesObj = [featureObjArray objectAtIndex:fLabel];
        orgYPos=30*fLabel;
        UILabel* featureLabel = [[UILabel alloc] initWithFrame:CGRectMake(xPos, orgYPos, scrollwidth/2-10, 30)];
        
        featureLabel.textAlignment=UITextAlignmentRight;
        UILabel* benefitLabel = [[UILabel alloc] initWithFrame:CGRectMake(scrollwidth/2, orgYPos, scrollwidth/2, 30)];
        
        if(tFeaturesObj.bIsFeatureTitle)
        {
            featureLabel.text = tFeaturesObj.strFeature;
            

            featureLabel.textColor = [UIColor orangeColor];
             featureLabel.textAlignment=UITextAlignmentLeft;
            
            //featureLabel.font = [UIFont boldSystemFontOfSize:20];
             featureLabel.font = [UIFont fontWithName:@"Trebuchet MS" size:20.0];
            
            [_fnbScrollview addSubview:featureLabel];
           //  NSLog(tFeaturesObj.strFeature);
        }
        else
        {
            featureLabel.text = tFeaturesObj.strFeature;
            
            featureLabel.font = [UIFont fontWithName:@"Trebuchet MS" size:16.0];
            benefitLabel.text = tFeaturesObj.strBenefit;
            benefitLabel.font = [UIFont fontWithName:@"Trebuchet MS" size:16.0];
            benefitLabel.textColor = RGB(0,111,162);
                 
            [_fnbScrollview addSubview:featureLabel];
            [_fnbScrollview addSubview:benefitLabel];
        }
        
        
    }
    _fnbScrollview.contentSize = CGSizeMake(scrollwidth, fObjCount*30);
    [_popOverController dismissPopoverAnimated:YES];
}

- (void) ssLocationManager:(SSLocationManager *)locManager updatedCurrentLocation:(YahooPlaceData *)_currentLocation
{
    self.currentStateName = _currentLocation.state;
    self.currentStateCode = _currentLocation.statecode;
    [self selectedState:self.currentStateName :self.currentStateCode];
    NSLog(@"Current Location string is: %@",[_currentLocation toString]);
}

- (void) ssLocationManager:(SSLocationManager *)locManager didFailWithError:(NSError *)error
{
    NSLog(@"location update failed...");
}


@end
