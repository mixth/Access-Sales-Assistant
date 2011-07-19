//
//  VisitApplicationPhotosViewController.m
//  Access Sales Assistant
//
//  Created by Ross Chapman on 7/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "VisitApplicationPhotosViewController.h"

#import "Producer.h"

#import "ProducerImage.h"

#import "HTTPOperationController.h"

#import "SpringBoardIconCell.h"

@implementation VisitApplicationPhotosViewController

@synthesize detailItem=_detailItem;

@synthesize gridView=_gridView;

@synthesize images=_images;

@synthesize managedObjectContext=_managedObjectContext;

@synthesize parent=_parent;

- (NSManagedObjectContext *)managedObjectContext
{
	if (_managedObjectContext == nil) {
		self.managedObjectContext = [NSManagedObjectContext defaultContext];
	}
	return _managedObjectContext;
}

- (void)getImageSuccess:(ASIHTTPRequest *)request
{
	self.images = self.detailItem.images.allObjects;
	[self.gridView reloadData];
}

- (void)postImageSuccess:(ASIHTTPRequest *)request
{
	[self configureView];
}

#pragma mark -
#pragma mark Detail item

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
	if (self.detailItem) {
		if ([self.detailItem valueForKey:@"editedValue"]) {
			[[NSManagedObjectContext defaultContext] save];
		}
	}
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }
}

- (void)configureView
{
	[[HTTPOperationController sharedHTTPOperationController] getImagesForProducer:self.detailItem.uid];
	self.images = self.detailItem.images.allObjects;
	[self.gridView reloadData];
}

- (IBAction)uploadPhoto:(id)sender
{
	
}

#pragma mark -
#pragma mark Init

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
	// Do any additional setup after loading the view from its nib.
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getImageSuccess:) name:@"Get Image Successful" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(postImageSuccess:) name:@"Post Image Successful" object:nil];
	
	self.images = self.detailItem.images.allObjects;
	NSLog(@"Images Count: %d", self.images.count);
	
	self.gridView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
	self.gridView.autoresizesSubviews = YES;
	
	[self configureView];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	self.images = self.detailItem.images.allObjects;
	[self.gridView reloadData];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	// Access the uncropped image from info dictionary
	UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
	[[HTTPOperationController sharedHTTPOperationController] postImage:image forProducer:self.detailItem.uid];
	[self.parent dismissModalViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark GridView Delegate


// Called after the user changes the selection
- (void) gridView: (AQGridView *) gridView didSelectItemAtIndex: (NSUInteger) index
{
	[gridView deselectItemAtIndex:index animated:YES];
	if (index == self.images.count) {
		// Create image picker controller
		UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
		
		// Delegate is self
		imagePicker.delegate = self;
		
		[imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
		
		// Show image picker
		[self.parent presentModalViewController:imagePicker animated:YES];
	}
}


- (void) gridView: (AQGridView *) gridView didDeselectItemAtIndex: (NSUInteger) index
{
	
}


// Called after animated updates finished
- (void) gridViewDidEndUpdateAnimation:(AQGridView *) gridView
{
	
}


#pragma mark -
#pragma mark GridView Data Source

- (NSUInteger) numberOfItemsInGridView: (AQGridView *) gridView
{
    return self.images.count + 1;
}

- (AQGridViewCell *) gridView: (AQGridView *) gridView cellForItemAtIndex: (NSUInteger) index
{
    static NSString * CellIdentifier = @"CellIdentifier";
    SpringBoardIconCell * cell = (SpringBoardIconCell *)[gridView dequeueReusableCellWithIdentifier: CellIdentifier];
    if ( cell == nil )
    {
        cell = [[SpringBoardIconCell alloc] initWithFrame: CGRectMake(0.0, 0.0, 144.0, 144.0) reuseIdentifier: CellIdentifier];
    }
	UIImage *image;
	if (index == self.images.count) {
		image = [UIImage imageNamed:@"button-plus.png"];
	} else {
		ProducerImage *producerImage = [self.images objectAtIndex:index];
		NSString *imageName = producerImage.imagePath;
		image = [UIImage imageWithContentsOfFile:imageName];
	}
	[cell setIcon:image];
    
    return cell;
}

- (CGSize) portraitGridCellSizeForGridView: (AQGridView *) gridView
{
    return CGSizeMake(144.0, 144.0);
}

#pragma mark - Application's Documents directory

/**
 Returns the URL to the application's Documents directory.
 */
- (NSString *)applicationDocumentsDirectory
{
	NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [documentPaths objectAtIndex:0];
}

@end