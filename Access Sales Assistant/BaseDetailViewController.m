//
//  DetailViewController.m
//  Access Sales Assistant
//
//  Created by Ross Chapman on 6/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BaseDetailViewController.h"

#import "RootViewController.h"

#import <QuartzCore/QuartzCore.h>

@implementation BaseDetailViewController

@synthesize baseNavigationBar;

@synthesize baseToolbar;

@synthesize hidemaster;

@synthesize showHideMaster;

@synthesize splitviewcontroller;

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
}

- (void)showRootPopoverButtonItem:(UIBarButtonItem *)barButtonItem {
 
    
    NSMutableArray *items1 = [[self.baseToolbar items] mutableCopy];
    
    UIBarButtonItem *prospectSubmitBtn = nil;
    
    for(UIBarButtonItem* btn in items1)
    {
        if(btn.tag == 1001)
        {
            prospectSubmitBtn = btn;
        }
    }
    
    if(items1)
        [items1 removeAllObjects];
    [items1 insertObject:barButtonItem atIndex:0];
    
    if([self isShowMaster])
    {    
    showHideMaster = [[UIBarButtonItem alloc] initWithTitle:@"Hide Menu"
                                                      style:UIBarButtonItemStyleBordered
                                                     target:self
                                                     action:@selector(toggleMaster:)];
    

    [items1 insertObject:showHideMaster atIndex:1];
    }

    if(prospectSubmitBtn)
        [items1 insertObject:prospectSubmitBtn atIndex:[items1 count]];
    [self.baseToolbar setItems:items1 animated:YES];
    
   
    
   

  //  }
	
}


- (void)invalidateRootPopoverButtonItem:(UIBarButtonItem *)barButtonItem {
    // Remove the popover button.
	// [baseNavigationBar.topItem setLeftBarButtonItem:nil animated:NO];
    
    NSMutableArray *items = [[self.baseToolbar items] mutableCopy];
    
    UIBarButtonItem *prospectSubmitBtn = nil;
    
    for(UIBarButtonItem* btn in items)
    {
        if(btn.tag == 1001)
        {
            prospectSubmitBtn = btn;
        }
    }

    if([items count])
        [items removeAllObjects];
    if([self isShowMaster])
    {
      
    showHideMaster = [[UIBarButtonItem alloc] initWithTitle:@"Hide Menu"
                                                                    style:UIBarButtonItemStyleBordered
                                                                   target:self
                                                                   action:@selector(toggleMaster:)];
    
      
    [items insertObject:showHideMaster atIndex:0];
    }
    
    
    if(prospectSubmitBtn)
        [items insertObject:prospectSubmitBtn atIndex:[items count]];


    [self.baseToolbar setItems:items animated:YES];

    
}


-(void)insertBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    
    NSMutableArray *items = [[self.baseToolbar items] mutableCopy];
    [items insertObject:barButtonItem atIndex:[items count]];
    [self.baseToolbar setItems:items animated:YES];
}

-(void) toggleMaster:(id) sender
{
    hidemaster = !hidemaster;
    
    [splitviewcontroller toggleMasterView:sender];
    
    NSString* title = hidemaster?@"Show Menu":@"Hide Menu";
    
    [self.showHideMaster setTitle:title];
    [self.view setNeedsDisplay];
    
    
    
    
}
-(BOOL) isShowMaster
{
    return UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation);
}
-(void) showAlert:(NSString *)alertText
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert" message:alertText delegate:nil cancelButtonTitle:nil otherButtonTitles: @"OK", nil];
	[alertView show];
}

-(void) changeTextFieldOutline:(UITextField *)textField:(BOOL) toOriginal
{
    if(!toOriginal)
    {
        [textField.layer setBackgroundColor: [[UIColor whiteColor] CGColor]];
        [textField.layer setBorderColor: [[UIColor redColor] CGColor]];
        [textField.layer setBorderWidth: 3.0f];
        [textField.layer setCornerRadius:8.0f];
        [textField.layer setMasksToBounds:YES];
    }
    else
    {
        textField.layer.borderColor=[[UIColor clearColor]CGColor];
    }
}
@end

@implementation BaseTextField

@synthesize showOriginal;

@end
