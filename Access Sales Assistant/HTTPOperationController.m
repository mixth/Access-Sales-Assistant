//
//  HTTPOperationController.m
//  Access Sales Assistant
//
//  Created by Ross Chapman on 7/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//



#import "HTTPOperationController.h"
#import "SynthesizeSingleton.h"
#import "ASINetworkQueue.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "JSON.h"
#import "JSONKit.h"
#import "NSData+Base64.h"
#import "StringEncryption.h"
#import "GetProducerRequest.h"
#import "GetCompetitorRequest.h"
#import "UIHelpers.h"
#import "AccessSalesConstants.h"
#import "Access_Sales_AssistantAppDelegate.h"
#import "MBProgressHUD.h"

#define kPAGESIZE 100

@implementation HTTPOperationController

@synthesize networkQueue=_networkQueue;

@synthesize managedObjectContext = managedObjectContext_;

SYNTHESIZE_SINGLETON_FOR_CLASS(HTTPOperationController);

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
		self.managedObjectContext = [NSManagedObjectContext defaultContext];
		
        // Create the network queue and initialize property
		[self setNetworkQueue:[HUDNetworkQueue queue]];
		[[self networkQueue] setDelegate:self];
		[[self networkQueue] setQueueDidFinishSelector:@selector(queueFinished:)];
		[[self networkQueue] setRequestDidStartSelector:@selector(requestDidStart:)];;
		[[self networkQueue] setShouldCancelAllRequestsOnFailure:NO];
		[[self networkQueue] go];
    }
    
    return self;
}

#pragma mark -
#pragma mark ASIHTTPRequest Delegate Methods


- (void)requestFinished:(ASIHTTPRequest *)request
{
	//... Handle finished notification
}


- (void)requestFailed:(ASIHTTPRequest *)request
{
	//... Handle fail notification
	[UIHelpers showAlertWithTitle:@"Error" msg:[[request error] localizedDescription] buttonTitle:@"OK"];
}


- (void)requestDidStart:(id)request
{
	//... Handle start notification
}


- (void)queueFinished:(ASINetworkQueue *)queue
{
	[[self networkQueue] setSuspended:YES];
	NSLog(@"Queue finished");
}


#pragma mark -
#pragma mark Specific Requests

// Authenticate
- (void)login
{
	if ([[self networkQueue] isSuspended]) {
		[[self networkQueue] go];
	}
	
	User *user = [User findFirst];
	NSString * _key = @"wTGMqLubzizPgylAsHGgfPfLDoclQt+YAIzM1ugFMko=";
	StringEncryption *crypto = [[[StringEncryption alloc] init] autorelease];
	NSData *secretData = [[user password] dataUsingEncoding:NSUTF8StringEncoding];
	CCOptions padding = kCCOptionPKCS7Padding;
	NSData *encryptedData = [crypto 
							 encrypt:secretData
							 key:[_key dataUsingEncoding:NSUTF8StringEncoding]
							 padding:&padding];
	
	NSString *encryptedString = [encryptedData base64EncodingWithLineLength:0];
	NSString *encryptedEncodedString = [self urlencode:encryptedString];
	NSString *urlString = [NSString 
						   stringWithFormat:@"%@STS/Authenticate?userName=%@&securePwd=%@&domain=%@&org=%@&apiKey=%@",
						   kLoginURL,
						   [user username],
						   encryptedEncodedString,
						   [user domain],
						   [user organization],
						   [user serviceKey]];
	
	NSURL *url = [NSURL URLWithString:urlString];
	ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
	[request setRequestMethod:@"GET"];
	[request addRequestHeader:@"Content-Type" value:@"application/json"];
	[request setDelegate:self];
	[request setDidFinishSelector:@selector(loginRequestFinished:)];
	[request setDidFailSelector:@selector(loginRequestFailed:)];
	[request setTimeOutSeconds:60];
	[request setNumberOfTimesToRetryOnTimeout:3];
	[request setQueuePriority:NSOperationQueuePriorityVeryHigh];
	[request setShouldContinueWhenAppEntersBackground:YES];
	[[self networkQueue] addOperation:request];
	[request release];
}

- (void)loginRequestFinished:(ASIHTTPRequest *)request
{
	if ([request responseStatusCode] != 200) {
		[self loginRequestFailed:request];
		return;
	}
	NSString *responseString = [request responseString];
	NSString *jsonString = [responseString JSONFragmentValue];
	NSString * encodedString = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes(NULL, (__bridge CFStringRef)jsonString, NULL, (CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8 );
	User *user = [User findFirst];
	user.token = encodedString;
	[self.managedObjectContext save];
	[encodedString release];
}

- (void)loginRequestFailed:(ASIHTTPRequest *)request
{
	NSError *error = [request error];
	NSLog(@"Request Error: %@", [error localizedDescription]);
	
	[[NSNotificationCenter defaultCenter] postNotificationName:@"Login Failure" object:request];	
}

- (void)logout
{
	Access_Sales_AssistantAppDelegate *appDelegate = (Access_Sales_AssistantAppDelegate *)[[UIApplication sharedApplication] delegate];
	MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[appDelegate window] animated:YES];
	hud.labelText = @"Logging Out";
	hud.dimBackground = YES;
	
	[Producer truncateAll];
	[QAResolutionForm truncateAll];
	[ReasonNotSeen truncateAll];
	[AUNTK truncateAll];
	[ClaimFrequecyTrendReportData truncateAll];
	[LossRatioTrendReportData truncateAll];
	[PolicyCountReportData truncateAll];
	[ProductionReportData truncateAll];
	[OperationHour truncateAll];
	[ProducerImage truncateAll];
	[PersonSpokeWithTitle truncateAll];
	[CommissionStructure truncateAll];
	[ProducerAddOn truncateAll];
	[BarrierToBusiness truncateAll];
	[ContactType truncateAll];
	[Note truncateAll];
	[PersonSpokeWith truncateAll];
	[Competitor truncateAll];
	[DailySummary truncateAll];
	[Phase truncateAll];
	[PurposeOfCall truncateAll];
	[Rater2 truncateAll];
	[SuspensionReason truncateAll];
	[SubTerritory truncateAll];
	[Status truncateAll];
	[State truncateAll];
	[Rater truncateAll];
	[QuestionListItem truncateAll];
	[PhoneListItem truncateAll];
	[IneligibleReason truncateAll];
	[HoursOfOperation truncateAll];
	[EmailListItem truncateAll];
	[Contact truncateAll];
	[AddressListItem truncateAll];
	
	[[User findFirst] setPassword:@""];
	[self.managedObjectContext save];
	[hud hide:YES];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"Producers Successful" object:nil];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"Login Failure" object:nil];
}

- (void)refreshProducers
{
	[self requestPickLists];
}

// Pick Lists
- (void)requestPickLists
{
	if ([[self networkQueue] isSuspended]) {
		[[self networkQueue] go];
	}
	
	User *user = [User findFirst];
	NSString *urlString = [NSString 
						   stringWithFormat:@"%@VisitApplicationService/Picklists?token=%@",
						   kURL,
						   [user token]];
	NSURL *url = [NSURL URLWithString:urlString];
	ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
	[request setRequestMethod:@"GET"];
	[request addRequestHeader:@"Content-Type" value:@"application/json"];
	[request setDelegate:self];
	[request setDidFinishSelector:@selector(requestPickListsFinished:)];
	//[request setDidFailSelector:@selector(requestPickListsFailed:)];
	[request setNumberOfTimesToRetryOnTimeout:3];
	[request setQueuePriority:NSOperationQueuePriorityVeryHigh];
	[request setShouldContinueWhenAppEntersBackground:YES];
	[[self networkQueue] addOperation:request];
	[request release];
}

- (void)requestPickListsFinished:(ASIHTTPRequest *)request
{
	NSString *responseString = [request responseString];
	
	NSArray *results = [responseString objectFromJSONString];
    
	
	for (NSDictionary *dict in results) {
		NSString *pickListType = [dict valueForKey:@"name"];
		NSArray *pickListItems = [dict objectForKey:@"pickList"];
		for (NSDictionary *itemDict in pickListItems) {
			NSManagedObject *item = [NSClassFromString(pickListType) ai_objectForProperty:@"uid" value:[itemDict valueForKey:@"uid"] managedObjectContext:self.managedObjectContext];
			[item safeSetValuesForKeysWithDictionary:itemDict dateFormatter:nil managedObjectContext:self.managedObjectContext];
		}
	}
	
	[self.managedObjectContext save];
	
	[[NSNotificationCenter defaultCenter] postNotificationName:@"PickList Successful" object:request];
	
	NSNumber *page = [NSNumber numberWithInt:1];
	
	[self requestCompetitors:page];
}

- (void)requestPickListsFailed:(ASIHTTPRequest *)request
{
	NSError *error = [request error];
	NSLog(@"Request Error: %@", [error localizedDescription]);
	
	[[NSNotificationCenter defaultCenter] postNotificationName:@"PickList Failure" object:request];
}

// Competitors
- (void)requestCompetitors:(NSNumber *)page
{
	if ([[self networkQueue] isSuspended]) {
		[[self networkQueue] go];
	}
	
	User *user = [User findFirst];
	NSString *urlString = [NSString 
						   stringWithFormat:@"%@VisitApplicationService/Competitors?pageNbr=%d&pageSize=%d&token=%@",
						   kURL, 
						   [page integerValue],
						   kPAGESIZE,
						   [user token]];
	NSURL *url = [NSURL URLWithString:urlString];
	GetCompetitorRequest *request = [[GetCompetitorRequest alloc] initWithURL:url];
	[request setDelegate:self];
	[request setDidFinishSelector:@selector(requestCompetitorsFinished:)];
	[request setTimeOutSeconds:60];
	[request setShouldContinueWhenAppEntersBackground:YES];
	[[self networkQueue] addOperation:request];
	[request release];
}

- (void)requestCompetitorsFinished:(ASIHTTPRequest *)request
{	
	GetCompetitorRequest *competitorRequest = (GetCompetitorRequest *)request;
	NSLog(@"%d", competitorRequest.currentPage);
	[[NSNotificationCenter defaultCenter] postNotificationName:@"Competitors Successful" object:request];
	if (competitorRequest.currentPage == 1) {
		for (int i = 2; i <= competitorRequest.totalPages; i++) {
			[self requestCompetitors:[NSNumber numberWithInt:i]];
		}
	} else if (competitorRequest.currentPage == competitorRequest.totalPages) {
		
		NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
		NSEntityDescription *entity = [NSEntityDescription entityForName:@"Producer"
												  inManagedObjectContext:[NSManagedObjectContext defaultContext]];
		[fetchRequest setEntity:entity];
		NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
		[dateFormatter setDateFormat:@"MM-dd-yyyy"];
		NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
		NSPredicate *datePredicate = [NSPredicate predicateWithFormat:@"nextScheduledVisitDate != %@", dateString];
		[fetchRequest setPredicate:datePredicate];
		[fetchRequest setReturnsObjectsAsFaults:YES];
		NSError *error = nil;
		NSArray *producers = [[NSManagedObjectContext defaultContext] executeFetchRequest:fetchRequest error:&error];
		if (producers == nil) {
			NSLog(@"No producers found!");
		}
		[producers makeObjectsPerformSelector:@selector(deleteEntity)];
		[[NSManagedObjectContext defaultContext] save];
		NSNumber *page = [NSNumber numberWithInt:1];
		[self requestProducers:page];
	}
}

- (void)requestCompetitorsFailed:(ASIHTTPRequest *)request
{
	NSError *error = [request error];
	NSLog(@"Request Error: %@", [error localizedDescription]);
	
	[[NSNotificationCenter defaultCenter] postNotificationName:@"Competitors Failure" object:nil];
}

// Get Producers
- (void)requestProducers:(NSNumber *)page
{
	if ([[self networkQueue] isSuspended])
		[[self networkQueue] go];
	
	User *user = [User findFirst];
	NSString *urlString = [NSString stringWithFormat:@"%@VisitApplicationService/TSM/Schedule?pageNbr=%d&pageSize=%d&partialLoad=false&token=%@", kURL, [page integerValue], 1, [user token]];
	NSURL *aURL = [NSURL URLWithString:urlString];
	
	GetProducerRequest *request = [[GetProducerRequest alloc] initWithURL:aURL];
	[request setDelegate:self];
	[request setDidFinishSelector:@selector(requestProducersFinished:)];
	[request setDidFailSelector:@selector(requestProducersFailed:)];
	[request setTimeOutSeconds:60];
	[request setShouldContinueWhenAppEntersBackground:YES];
	[[self networkQueue] addOperation:request];
	[request release];
}

- (void)requestProducersFinished:(ASIHTTPRequest *)request
{	
	[[NSNotificationCenter defaultCenter] postNotificationName:@"Producers Successful" object:nil];
	
	GetProducerRequest *producerRequest = (GetProducerRequest *)request;
	if (producerRequest.currentPage == 1) {
		for (int i = 2; i <= producerRequest.totalPages; i++) {
			[self requestProducers:[NSNumber numberWithInt:i]];
		}
	}
}

- (void)requestProducersFailed:(ASIHTTPRequest *)request
{
	NSError *error = [request error];
	NSLog(@"Request Producer Error: %@", [error localizedDescription]);
	
	[[NSNotificationCenter defaultCenter] postNotificationName:@"Producers Failure" object:request];
}

// Post Producer
- (void)postProducerProfile:(NSString *)profile
{
	if ([[self networkQueue] isSuspended]) {
		[[self networkQueue] go];
	}
	
	User *user = [User findFirst];
	NSString *urlString = [NSString stringWithFormat:@"%@VisitApplicationService/Producers?token=%@", kURL, [user token]];
	NSURL *url = [NSURL URLWithString:urlString];
	ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
	[request setRequestMethod:@"POST"];
	[request addRequestHeader:@"Content-Type" value:@"application/json"];
	[request setDelegate:self];
	[request setDidFinishSelector:@selector(postProducerProfileFinished:)];
	[request setDidFailSelector:@selector(postProducerProfileFailed:)];
	[request setPostBody:[NSMutableData dataWithData:[profile dataUsingEncoding:NSASCIIStringEncoding]]];
	[request setNumberOfTimesToRetryOnTimeout:3];
	[request setQueuePriority:NSOperationQueuePriorityVeryHigh];
	[request setShouldContinueWhenAppEntersBackground:YES];
	[[self networkQueue] addOperation:request];
	[request release];
}

- (void)postProducerProfileFinished:(ASIHTTPRequest *)request
{
	if ([request responseStatusCode] != 200) {
		[self postProducerProfileFailed:request];
	} else {
		NSString *responseString = [request responseString];
		NSDictionary *responseJSON = [responseString JSONValue];
		if (responseJSON) {
			Producer *producer = [Producer ai_objectForProperty:@"uid" value:[responseJSON valueForKey:@"uid"] managedObjectContext:self.managedObjectContext];
			producer.editedValue = NO;
			NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
			[formatter setDateFormat:@"MM/dd/yyyy HH:mm:ss"];
			[producer safeSetValuesForKeysWithDictionary:responseJSON dateFormatter:formatter managedObjectContext:self.managedObjectContext];
			[formatter release];
			// Hours of Operation
			HoursOfOperation *hoursOfOperation = producer.hoursOfOperation;
			[hoursOfOperation safeSetValuesForKeysWithDictionary:[responseJSON valueForKey:@"hoursOfOperation"] dateFormatter:nil managedObjectContext:self.managedObjectContext];
			// Contacts
			NSArray *contactsArray = [responseJSON valueForKey:@"contacts"];
			if (contactsArray.count > 0) {
				@autoreleasepool {
					for (Contact *contact in producer.contacts) {
						[contact deleteInContext:self.managedObjectContext];
					}
					for (NSDictionary *contactDictionary in contactsArray) {
						Contact *contact = [Contact createInContext:self.managedObjectContext];
						[contact setProducer:producer];
						[contact safeSetValuesForKeysWithDictionary:contactDictionary dateFormatter:nil managedObjectContext:self.managedObjectContext];
					}
				}
			}
			NSArray *phoneArray = [responseJSON valueForKey:@"phoneNumbers"];
			if (contactsArray.count > 0) {
				@autoreleasepool {
					for (PhoneListItem *phone in producer.phoneNumbers) {
						[phone deleteInContext:self.managedObjectContext];
					}
					for (NSDictionary *phoneDictionary in phoneArray) {
						PhoneListItem *phone = [PhoneListItem createInContext:self.managedObjectContext];
						[phone setProducer:producer];
						[phone safeSetValuesForKeysWithDictionary:phoneDictionary dateFormatter:nil managedObjectContext:self.managedObjectContext];
					}
				}
			}
			NSArray *emailArray = [responseJSON valueForKey:@"emails"];
			if (emailArray.count > 0) {
				@autoreleasepool {
					for (EmailListItem *email in producer.emails) {
						[email deleteInContext:self.managedObjectContext];
					}
					for (NSDictionary *emailDictionary in emailArray) {
						EmailListItem *email = [EmailListItem createInContext:self.managedObjectContext];
						[email setProducer:producer];
						[email safeSetValuesForKeysWithDictionary:emailDictionary dateFormatter:nil managedObjectContext:self.managedObjectContext];
					}
				}
			}
			NSArray *addressArray = [responseJSON valueForKey:@"addresses"];
			if (addressArray.count > 0) {
				@autoreleasepool {
					for (AddressListItem *address in producer.addresses) {
						[address deleteInContext:self.managedObjectContext];
					}
					for (NSDictionary *addressDictionary in addressArray) {
						AddressListItem *address = [AddressListItem createInContext:self.managedObjectContext];
						[address setProducer:producer];
						[address safeSetValuesForKeysWithDictionary:addressDictionary dateFormatter:nil managedObjectContext:self.managedObjectContext];
					}
				}
			}
			[self.managedObjectContext save];
			//NSLog(@"%@", [producer jsonStringValue]);
		}
		[[NSNotificationCenter defaultCenter] postNotificationName:@"Post Producer Successful" object:request];
	}
}

- (void)postProducerProfileFailed:(ASIHTTPRequest *)request
{
	NSError *error = [request error];
	NSLog(@"Request Error: %@", [error localizedDescription]);
    
    NSString *profileFailed = [NSString stringWithFormat:PRODUCER_PROFILE_REQUEST_FAILED,[error localizedDescription]];
    [UIHelpers showAlertWithTitle:@"Error" msg:profileFailed buttonTitle:@"OK"];
}

// Post Daily Summary
- (void)postDailySummary:(NSString *)summary
{
	NSLog(@"%@", summary);
	if ([[self networkQueue] isSuspended]) {
		[[self networkQueue] go];
	}
	
	User *user = [User findFirst];
	NSString *urlString = [NSString stringWithFormat:@"%@VisitApplicationService/DailySummaryReports?token=%@", kURL, [user token]];
	NSURL *url = [NSURL URLWithString:urlString];
	ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
	[request setRequestMethod:@"POST"];
	[request addRequestHeader:@"Content-Type" value:@"application/json"];
	[request setDelegate:self];
	[request setDidFinishSelector:@selector(postDailySummaryFinished:)];
	[request setDidFailSelector:@selector(postDailySummaryFailed:)];
	[request setPostBody:[NSMutableData dataWithData:[summary dataUsingEncoding:NSASCIIStringEncoding]]];
	[request setNumberOfTimesToRetryOnTimeout:3];
	[request setQueuePriority:NSOperationQueuePriorityVeryHigh];
	[request setShouldContinueWhenAppEntersBackground:YES];
	[[self networkQueue] addOperation:request];
	[request release];
}

- (void)postDailySummaryFinished:(ASIHTTPRequest *)request
{
	if ([request responseStatusCode] != 200) {
		[self postDailySummaryFailed:request];
	} else {
		NSString *responseString = [request responseString];
		NSDictionary *responseJSON = [responseString JSONValue];
		if (responseJSON) {
			NSLog(@"Daily Summary Response: %@",responseJSON);
			Producer *producer = [Producer ai_objectForProperty:@"uid" value:[responseJSON valueForKeyPath:@"producerId.uid"] managedObjectContext:self.managedObjectContext];
			producer.dailySummary.editedValue = NO;
			producer.submittedValue = YES;
			NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
			[formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
			producer.dailySummary.uid = [responseJSON valueForKey:@"uid"];
			//[producer.dailySummary safeSetValuesForKeysWithDictionary:responseJSON dateFormatter:formatter managedObjectContext:self.managedObjectContext];
			[formatter release];
			// Contacts
			NSArray *notesArray = [responseJSON valueForKey:@"notes"];
			if (notesArray.count > 0) {
				for (Note *note in producer.dailySummary.notes) {
					[note deleteInContext:self.managedObjectContext];
				}
				[self.managedObjectContext save];
				for (NSDictionary *noteDictionary in notesArray) {
					Note *note = [Note createInContext:self.managedObjectContext];
					[note setDailySummary:producer.dailySummary];
					[note safeSetValuesForKeysWithDictionary:noteDictionary dateFormatter:nil managedObjectContext:self.managedObjectContext];
				}
			}
			[self.managedObjectContext save];
			[UIHelpers showAlertWithTitle:@"Success" msg:PRODUCER_SUMMARY_REQUEST_SUCCESS buttonTitle:@"OK"];
		}
	}
}

- (void)postDailySummaryFailed:(ASIHTTPRequest *)request
{
	NSError *error = [request error];
	NSLog(@"Request Error: %@", [error localizedDescription]);
	
    NSString *summaryFailed = [NSString stringWithFormat:PRODUCER_SUMMARY_REQUEST_FAILED,[error localizedDescription]];
    [UIHelpers showAlertWithTitle:@"Error" msg:summaryFailed buttonTitle:@"OK"];
}

// Post Image for Producer
- (void)postImage:(UIImage *)image forProducer:(NSString *)producerID
{
	if ([[self networkQueue] isSuspended]) {
		[[self networkQueue] go];
	}
	
	User *user = [User findFirst];
	NSString *imageName = [NSString stringWithFormat:@"%@_%d.png", producerID, [image hash]];
	NSString *urlString = [NSString stringWithFormat:@"%@VisitApplicationService/Producers/%@/Images?fileName=%@&token=%@", kURL, producerID, imageName, [user token]];
	NSURL *url = [NSURL URLWithString:urlString];
	ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
	[request setRequestMethod:@"POST"];
	NSData *tempData = UIImageJPEGRepresentation(image, 2.0);
	NSMutableData *imageData = [NSMutableData dataWithData:tempData];
	[request setPostBody:imageData];
	[request setDelegate:self];
	[request setDidFinishSelector:@selector(postImageForProducerFinished:)];
	[request setDidFailSelector:@selector(postImageForProducerFailed:)];
	[request setNumberOfTimesToRetryOnTimeout:3];
	[request setQueuePriority:NSOperationQueuePriorityVeryHigh];
	[request setShouldContinueWhenAppEntersBackground:YES];
	[[self networkQueue] addOperation:request];
	[request release];
}

- (void)postImageForProducerFinished:(ASIHTTPRequest *)request
{	
	[[NSNotificationCenter defaultCenter] postNotificationName:@"Post Image Successful" object:request];
    
	[UIHelpers showAlertWithTitle:@"Success" msg:POST_IMAGE_SUCCESS buttonTitle:@"OK"];
    
}

- (void)postImageForProducerFailed:(ASIHTTPRequest *)request
{
	NSError *error = [request error];
	NSLog(@"Request Error: %@", [error localizedDescription]);
    
    NSString *imageFailed = [NSString stringWithFormat:POST_IMAGE_FAILED,[error localizedDescription]];
    [UIHelpers showAlertWithTitle:@"Error" msg:imageFailed buttonTitle:@"OK"];
	
	
	//	[[NSNotificationCenter defaultCenter] postNotificationName:@"Post Image Failure" object:request];
}

// Delete Image for Producer
- (void)deleteImage:(NSString *)imageName forProducer:(NSString *)producerID
{
	if ([[self networkQueue] isSuspended]) {
		[[self networkQueue] go];
	}
	
	User *user = [User findFirst];
	NSString *urlString = [NSString stringWithFormat:@"%@VisitApplicationService/Producers/%@/Images?fileName=%@&token=%@", kURL, producerID, imageName, [user token]];
	NSURL *url = [NSURL URLWithString:urlString];
	ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
	[request setRequestMethod:@"DELETE"];
	[request setDelegate:self];
	[request setDidFinishSelector:@selector(deleteImageForProducerFinished:)];
	[request setDidFailSelector:@selector(deleteImageForProducerFailed:)];
	[request setNumberOfTimesToRetryOnTimeout:3];
	[request setQueuePriority:NSOperationQueuePriorityVeryHigh];
	[request setShouldContinueWhenAppEntersBackground:YES];
	[[self networkQueue] addOperation:request];
	[request release];
}

- (void)deleteImageForProducerFinished:(ASIHTTPRequest *)request
{	
	[[NSNotificationCenter defaultCenter] postNotificationName:@"Delete Image Successful" object:request];
    
	[UIHelpers showAlertWithTitle:@"Success" msg:@"Deleted image successfully" buttonTitle:@"OK"];
    
}

- (void)deleteImageForProducerFailed:(ASIHTTPRequest *)request
{
	NSError *error = [request error];
	NSLog(@"Request Error: %@", [error localizedDescription]);
    [UIHelpers showAlertWithTitle:@"Error" msg:@"Failed to delete image" buttonTitle:@"OK"];
}

// Get Image for Producer
- (void)getImagesForProducer:(NSString *)producerID
{
	if ([[self networkQueue] isSuspended]) {
		[[self networkQueue] go];
	}
	
	User *user = [User findFirst];
	NSString *urlString = [NSString stringWithFormat:@"%@VisitApplicationService/Producers/%@/Images?token=%@", kURL, producerID, [user token]];
	NSURL *url = [NSURL URLWithString:urlString];
	ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
	[request setRequestMethod:@"GET"];
	[request addRequestHeader:@"Content-Type" value:@"application/json"];
	[request setDelegate:self];
	[request setDidFinishSelector:@selector(getImagesForProducerFinished:)];
	[request setDidFailSelector:@selector(getImagesForProducerFailed:)];
	NSDictionary *userInfoDict = [NSDictionary dictionaryWithObjectsAndKeys:producerID, @"producerUID", nil];
	[request setUserInfo:userInfoDict];
	[request setNumberOfTimesToRetryOnTimeout:3];
	[request setQueuePriority:NSOperationQueuePriorityVeryHigh];
	[request setShouldContinueWhenAppEntersBackground:YES];
	[[self networkQueue] addOperation:request];
	[request release];
}

- (void)getImagesForProducerFinished:(ASIHTTPRequest *)request
{
	NSString *responseString = [request responseString];
	NSString *escapedString = [responseString stringByReplacingOccurrencesOfString:@"\\" withString:@""];
	NSArray *responseJSON = [escapedString JSONValue];
	if (responseJSON) {
		for (NSDictionary *dict in responseJSON) {
			NSString *producerUID = [[request userInfo] valueForKey:@"producerID"];
			[self getImage:[dict valueForKey:@"url"] forProducer:producerUID];
		}
	}
	[[NSNotificationCenter defaultCenter] postNotificationName:@"Get Images Successful" object:request];
}

- (void)getImagesForProducerFailed:(ASIHTTPRequest *)request
{
	NSError *error = [request error];
	NSLog(@"Request Error: %@", [error localizedDescription]);
	
	[[NSNotificationCenter defaultCenter] postNotificationName:@"Get Images Failure" object:request];
}

// Get Image
- (void)getImage:(NSString *)urlString forProducer:(NSString *)producerID
{
	if ([[self networkQueue] isSuspended]) {
		[[self networkQueue] go];
	}
	
	NSURL *url = [NSURL URLWithString:urlString];
	ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
	[request setRequestMethod:@"GET"];
	[request setDelegate:self];
	[request setDidFinishSelector:@selector(getImageFinished:)];
	[request setDidFailSelector:@selector(getImageFailed:)];
	NSArray *pathComps = [urlString pathComponents];
	NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDir = [documentPaths objectAtIndex:0];
	NSString *imagePath = [documentsDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", [pathComps lastObject]]];
	[request setDownloadDestinationPath:imagePath];
	[request setNumberOfTimesToRetryOnTimeout:3];
	[request setQueuePriority:NSOperationQueuePriorityVeryHigh];
	[request setShouldContinueWhenAppEntersBackground:YES];
	[[self networkQueue] addOperation:request];
	[request release];
}

- (void)getImageFinished:(ASIHTTPRequest *)request
{
	NSString *urlString = [[request url] absoluteString];
	NSArray *pathComps = [urlString pathComponents];
	NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDir = [documentPaths objectAtIndex:0];
	NSString *imagePath = [documentsDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", [pathComps lastObject]]];
	NSArray *producerIDStringArray = [[pathComps lastObject] componentsSeparatedByString:@"_"];
	NSString *producerUID;
	if (producerIDStringArray.count > 1) {
		producerUID = [producerIDStringArray objectAtIndex:0];
		Producer *producer = [Producer findFirstByAttribute:@"uid" withValue:producerUID];
		ProducerImage *image = [ProducerImage ai_objectForProperty:@"imagePath" value:imagePath managedObjectContext:self.managedObjectContext];
		[image setImageName:[pathComps lastObject]];
		
		if (![producer.images containsObject:image]) {
			[producer addImagesObject:image];
		}
		[self.managedObjectContext save];
		[[NSNotificationCenter defaultCenter] postNotificationName:@"Get Image Successful" object:request];
	}
}

- (void)getImageFailed:(ASIHTTPRequest *)request
{
	NSError *error = [request error];
	NSLog(@"Request Error: %@", [error localizedDescription]);
	
	[[NSNotificationCenter defaultCenter] postNotificationName:@"Get Image Failure" object:request];
}
#pragma mark - Training Videos
-(void)getTrainingVideos
{
	if ([[self networkQueue] isSuspended]) {
		[[self networkQueue] go];
	}
	User *user = [User findFirst];
	
	NSString *urlString = [NSString 
						   stringWithFormat:@"%@VisitApplicationService/AccessAcademy/Videos?token=%@",kURL,[user token]];
	NSURL *url = [NSURL URLWithString:urlString];
	ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
	[request setRequestMethod:@"GET"];
	[request addRequestHeader:@"Content-Type" value:@"application/json"];
	[request setDelegate:self];
	[request setDidFinishSelector:@selector(getTrainingVideosFinished:)];
	[request setDidFailSelector:@selector(getTrainingVideosFailed:)];
	[request setNumberOfTimesToRetryOnTimeout:3];
	[request setQueuePriority:NSOperationQueuePriorityVeryHigh];
	[request setShouldContinueWhenAppEntersBackground:YES];
	[[self networkQueue] addOperation:request];
	[request release];
}
-(void)getTrainingVideosFinished:(ASIHTTPRequest *)request
{
    NSString *responseString = [request responseString];
	NSString *escapedString = [responseString stringByReplacingOccurrencesOfString:@"\\" withString:@""];
	NSArray *responseJSON = [escapedString JSONValue];
	if (responseJSON) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Get Videos Success" object:responseJSON];
    }
}

-(void)getTrainingVideosFailed:(ASIHTTPRequest *)request
{
    NSLog(@"Video Request Failed");
}

#pragma mark - Search Producer

-(void)searchProducer:(NSString *)searchString
{
    
	if ([[self networkQueue] isSuspended]) {
		[[self networkQueue] go];
	}
	User *user = [User findFirst];
    NSString* escapedString = [self urlencode:searchString];
	NSString *urlString = [NSString 
						   stringWithFormat:@"%@VisitApplicationService/Producers/Search?producerName=%@&producerCode=%@&pageNbr=1&pageSize=100&partialLoad=false&token=%@", kURL, escapedString, escapedString, [user token]];
	NSURL *url = [NSURL URLWithString:urlString];
	ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
	[request setRequestMethod:@"GET"];
	[request addRequestHeader:@"Content-Type" value:@"application/json"];
	[request setDelegate:self];
	[request setDidFinishSelector:@selector(searchProducerFinished:)];
	[request setDidFailSelector:@selector(searchProducerFailed:)];
	[request setShouldContinueWhenAppEntersBackground:YES];
	[request setTimeOutSeconds:60];
	[[self networkQueue] addOperation:request];
	[request release];
	
}

-(void)searchProducerFinished:(ASIHTTPRequest *)request
{
    NSString* responseString = [request responseString];
    NSDictionary *responseJSON = [responseString JSONValue];
	NSArray *results = [responseJSON objectForKey:@"results"];
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"MM/dd/yyyy HH:mm:ss"];
	NSMutableArray* producernameArray = [[NSMutableArray alloc] init];
    if([results count]>0)
    {
		for (NSDictionary *dict in results) {
			NSMutableDictionary *newDict = [[NSMutableDictionary alloc] init];
			@autoreleasepool {
                Producer *producer = [Producer findFirstByAttribute:@"uid" withValue:[dict valueForKey:@"uid"] inContext:self.managedObjectContext];
                if (!producer) 
                {
                    producer = [Producer createInContext:self.managedObjectContext];
                    QuestionListItem *question = [QuestionListItem createInContext:self.managedObjectContext];
                    [producer addQuestionsObject:question];
                    HoursOfOperation *hours = [HoursOfOperation createInContext:self.managedObjectContext];
                    [producer setHoursOfOperation:hours];
                }
                if (!producer.editedValue)
                {
                    [producer safeSetValuesForKeysWithDictionary:dict dateFormatter:formatter managedObjectContext:self.managedObjectContext];
                    // Calc schedule values
                    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                    [dateFormatter setDateFormat:@"EEEE, MM-dd-yyyy"];
                    producer.nextScheduledVisitDate = [dateFormatter stringFromDate:[producer nextScheduledVisit]];
                    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
                    [timeFormatter setDateFormat:@"hh:mm a"];
                    producer.nextScheduledVisitTime = [timeFormatter stringFromDate:[producer nextScheduledVisit]];
                    producer.address = [NSString stringWithFormat:@"%@,%@", producer.latitude, producer.longitude];
                    // Hours of Operation
                    HoursOfOperation *hoursOfOperation = producer.hoursOfOperation;
                    if (!hoursOfOperation) {
                        hoursOfOperation = [HoursOfOperation createInContext:self.managedObjectContext];
                        [producer setHoursOfOperation:hoursOfOperation];
                    }
                    [hoursOfOperation safeSetValuesForKeysWithDictionary:[dict valueForKey:@"hoursOfOperation"] dateFormatter:nil managedObjectContext:self.managedObjectContext];
                    // Contacts
                    NSArray *contactsArray = [dict valueForKey:@"contacts"];
                    if (contactsArray.count > 0) {
                        for (Contact *contact in producer.contacts) {
                            [contact deleteInContext:self.managedObjectContext];
                        }
                        for (NSDictionary *contactDictionary in contactsArray) {
                            Contact *contact = [Contact createInContext:self.managedObjectContext];
                            [contact setProducer:producer];
                            [contact safeSetValuesForKeysWithDictionary:contactDictionary dateFormatter:nil managedObjectContext:self.managedObjectContext];
                        }
                    }
					NSDictionary *dailySummary = [dict valueForKey:@"dailySummary"];
					if (dailySummary) {
						[producer.dailySummary deleteInContext:self.managedObjectContext];
						DailySummary *summary = [DailySummary createInContext:self.managedObjectContext];
						[summary safeSetValuesForKeysWithDictionary:dailySummary dateFormatter:dateFormatter managedObjectContext:self.managedObjectContext];
						producer.dailySummary = summary;
					}
					
					NSArray *addressesArray = [dict valueForKey:@"addresses"];
					if (addressesArray.count > 0) {
						for (AddressListItem *address in producer.addresses) {
							[address deleteInContext:self.managedObjectContext];
						}
						for (NSDictionary *addressDictionary in addressesArray) {
							AddressListItem *address = [AddressListItem createInContext:self.managedObjectContext];
							[address setProducer:producer];
							[address safeSetValuesForKeysWithDictionary:addressDictionary dateFormatter:nil managedObjectContext:self.managedObjectContext];
						}
					}
					
					
					else {
						NSLog(@"Producer has been editted:\n %@", [producer jsonStringValue]);
					}
				}
				
				
				NSLog(@"%@",[producer jsonStringValue]);
				[newDict setValue:producer.uid forKey:@"uid"];
				[newDict setValue:producer.name forKey:@"name"];
				[newDict setValue:producer.producerCode forKey:@"producerCode"];
				[producernameArray addObject:newDict];
				
				
				
				///////////////////
				BOOL isCommissionAddrFound = FALSE,isPhysicalAddrFound,isMailingAddrFound=FALSE;
				
				AddressListItem *mailingAddress=nil, *commissionAddress=nil, *physicalAddress=nil;
				for(AddressListItem *addrItem in producer.addresses)
				{
					if(addrItem.addressTypeValue == 3)
					{
						isPhysicalAddrFound = TRUE;
						physicalAddress = addrItem;
					}
					
				}
				
				NSString *producerAddress = nil;
				
				if(isPhysicalAddrFound)
				{
					producerAddress = [[NSString alloc] initWithFormat:@"%@, %@, %@, %@",physicalAddress.addressLine1,physicalAddress.city,physicalAddress.state.name,physicalAddress.postalCode];
					// [self FillAddressCellForType:addressCell :physicalAddress:forType];
				}
				
				NSLog(@"Address is:%@",producerAddress);
				if(!producerAddress)
					producerAddress = [[NSString alloc] initWithFormat:@"No Address Found"];
				
				[newDict setValue:producerAddress forKey:@"producerAddress"];
				
			}
		}
		[self.managedObjectContext save];
		
		[[NSNotificationCenter defaultCenter] postNotificationName:@"searchProducer" object:producernameArray];
		
	}
	else
	{
		[UIHelpers showAlertWithTitle:@"Alert" msg:@"No Producers found" buttonTitle:@"OK"];
	}
	[producernameArray release];
	[formatter release];
	
}
-(void)searchProducerFailed:(ASIHTTPRequest *)request
{
	NSError *error = [request error];
	NSLog(@"Request Error: %@", [error localizedDescription]);
	
	NSString *summaryFailed = [NSString stringWithFormat:SEARCH_PRODUCER_FAILED,[error localizedDescription]];
	[UIHelpers showAlertWithTitle:@"Error" msg:summaryFailed buttonTitle:@"OK"];
}

#pragma mark -
#pragma mark AUNTKs

-(void)getAUNTKsForProducer:(NSString *)producerCode
{
	if ([[self networkQueue] isSuspended]) {
		[[self networkQueue] go];
	}
	
	User *user = [User findFirst];
	NSString *urlString = [NSString stringWithFormat:@"%@VisitApplicationService/AUNTk/%@?token=%@", kURL, producerCode, [user token]];
	NSURL *url = [NSURL URLWithString:urlString];
	ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
	[request setRequestMethod:@"GET"];
	[request addRequestHeader:@"Content-Type" value:@"application/json"];
	[request setDelegate:self];
	[request setDidFinishSelector:@selector(getAUNTKsForProducerFinished:)];
	[request setDidFailSelector:@selector(getAUNTKsForProducerFailed:)];
	NSDictionary *userInfoDict = [NSDictionary dictionaryWithObjectsAndKeys:producerCode, @"producerUID", nil];
	[request setUserInfo:userInfoDict];
	[request setNumberOfTimesToRetryOnTimeout:3];
	[request setQueuePriority:NSOperationQueuePriorityVeryHigh];
	[request setShouldContinueWhenAppEntersBackground:YES];
	[[self networkQueue] addOperation:request];
	[request release];
}

-(void)getAUNTKsForProducerFinished:(ASIHTTPRequest*)request
{
	NSString *responseString = [request responseString];
	NSString *escapedString = [responseString stringByReplacingOccurrencesOfString:@"\\" withString:@""];
	NSArray *responseJSON = [escapedString JSONValue];
	
	Producer *producer = [Producer findFirstByAttribute:@"producerCode" withValue:[[request userInfo] valueForKey:@"producerUID"]];
	
	for (NSDictionary *dict in responseJSON) {
		NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
		[formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
		AUNTK *auntk = [AUNTK createEntity];
		[auntk safeSetValuesForKeysWithDictionary:[dict valueForKey:@"value"] dateFormatter:formatter managedObjectContext:self.managedObjectContext];
		if ([[dict valueForKey:@"key"] isEqualToString:@"auntk"]) {
			producer.auntk = auntk;
		} else if ([[dict valueForKey:@"key"] isEqualToString:@"chain"]) {
			producer.chainAuntk = auntk;
		}
		[formatter release];
	}
	[self.managedObjectContext save];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"AUNTK" object:nil];
}

-(void)getAUNTKsForProducerFailed:(ASIHTTPRequest*)request
{
	
}

-(void)postQAResolutionForm:(NSString*)qaResolutionForm
{
	if ([[self networkQueue] isSuspended]) {
		[[self networkQueue] go];
	}
	
	User *user = [User findFirst];
	NSString *urlString = [NSString stringWithFormat:@"%@VisitApplicationService/QAResolutionRequest?token=%@", kURL, [user token]];
	NSURL *url = [NSURL URLWithString:urlString];
	ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
	[request setRequestMethod:@"POST"];
	[request addRequestHeader:@"Content-Type" value:@"application/json"];
	[request setDelegate:self];
	[request setDidFinishSelector:@selector(postQAResolutionFormFinished:)];
	[request setDidFailSelector:@selector(postQAResolutionFormFailed:)];
	[request setPostBody:[NSMutableData dataWithData:[qaResolutionForm dataUsingEncoding:NSASCIIStringEncoding]]];
	[request setTimeOutSeconds:60];
	[request setQueuePriority:NSOperationQueuePriorityVeryHigh];
	[request setShouldContinueWhenAppEntersBackground:YES];
	[[self networkQueue] addOperation:request];
	[request release];
}

-(void)postQAResolutionFormFinished:(ASIHTTPRequest*)request
{
	[UIHelpers showAlertWithTitle:@"Success" msg:@"Request submitted successfully" buttonTitle:@"OK"];
}

-(void)postQAResolutionFormFailed:(ASIHTTPRequest*)request
{
	[UIHelpers showAlertWithTitle:@"Failed" msg:@"Request Failed" buttonTitle:@"OK"];
}

#pragma mark - Delete Contact

- (void)deleteContact:(NSString *)contact
{
	if ([[self networkQueue] isSuspended]) {
		[[self networkQueue] go];
	}
	
	User *user = [User findFirst];
	NSString *urlString = [NSString stringWithFormat:@"%@VisitApplicationService/Contacts/%@?token=%@", kURL, contact, [user token]];
	NSURL *url = [NSURL URLWithString:urlString];
	ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
	[request setRequestMethod:@"DELETE"];
	[request setDelegate:self];
	[request setDidFinishSelector:@selector(deleteContactFinished:)];
	[request setDidFailSelector:@selector(deleteContactFailed:)];
	[request setNumberOfTimesToRetryOnTimeout:3];
	[request setQueuePriority:NSOperationQueuePriorityVeryHigh];
	[request setShouldContinueWhenAppEntersBackground:YES];
	[[self networkQueue] addOperation:request];
	[request release];
}

- (void)deleteContactFinished:(ASIHTTPRequest *)request
{
	if ([request responseStatusCode] != 200) {
		[self deleteContactFailed:request];
	}
}

- (void)deleteContactFailed:(ASIHTTPRequest *)request
{
	[UIHelpers showAlertWithTitle:@"Delete Failed" msg:@"Failed to delete contact" buttonTitle:@"OK"];
}

#pragma mark - 
#pragma mark URL Encode

-(NSString *) urlencode: (NSString *) url
{
	NSArray *escapeChars = [NSArray arrayWithObjects:@";" , @"/" , @"?" , @":" ,
							@"@" , @"&" , @"=" , @"+" ,
							@"$" , @"," , @"[" , @"]",
							@"#", @"!", @"'", @"(", 
							@")", @"*", @" ",nil];
	
	NSArray *replaceChars = [NSArray arrayWithObjects:@"%3B" , @"%2F" , @"%3F" ,
							 @"%3A" , @"%40" , @"%26" ,
							 @"%3D" , @"%2B" , @"%24" ,
							 @"%2C" , @"%5B" , @"%5D", 
							 @"%23", @"%21", @"%27",
							 @"%28", @"%29", @"%2A", @"%20",nil];
	
	int len = [escapeChars count];
	
	NSMutableString *temp = [[url mutableCopy] autorelease];
	
	int i;
	for(i = 0; i < len; i++)
	{
		
		[temp replaceOccurrencesOfString: [escapeChars objectAtIndex:i]
							  withString:[replaceChars objectAtIndex:i]
								 options:NSLiteralSearch
								   range:NSMakeRange(0, [temp length])];
	}
	
	NSString *out = [NSString stringWithString: temp];
	
	return out;
}

@end
