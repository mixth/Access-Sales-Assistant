// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Producer.h instead.

#import <CoreData/CoreData.h>


@class AddressListItem;
@class AUNTK;
@class AUNTK;
@class Contact;
@class DailySummary;
@class EmailListItem;
@class HoursOfOperation;
@class ProducerImage;
@class IneligibleReason;
@class PhoneListItem;
@class QuestionListItem;
@class Rater;
@class Rater2;
@class Status;
@class SubTerritory;
@class SuspensionReason;



























@interface ProducerID : NSManagedObjectID {}
@end

@interface _Producer : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (ProducerID*)objectID;




@property (nonatomic, retain) NSString *address;


//- (BOOL)validateAddress:(id*)value_ error:(NSError**)error_;




@property (nonatomic, retain) NSDate *appointedDate;


//- (BOOL)validateAppointedDate:(id*)value_ error:(NSError**)error_;




@property (nonatomic, retain) NSDate *dateEstablished;


//- (BOOL)validateDateEstablished:(id*)value_ error:(NSError**)error_;




@property (nonatomic, retain) NSDate *eAndOExpires;


//- (BOOL)validateEAndOExpires:(id*)value_ error:(NSError**)error_;




@property (nonatomic, retain) NSNumber *edited;


@property BOOL editedValue;
- (BOOL)editedValue;
- (void)setEditedValue:(BOOL)value_;

//- (BOOL)validateEdited:(id*)value_ error:(NSError**)error_;




@property (nonatomic, retain) NSNumber *hasAccessSign;


@property BOOL hasAccessSignValue;
- (BOOL)hasAccessSignValue;
- (void)setHasAccessSignValue:(BOOL)value_;

//- (BOOL)validateHasAccessSign:(id*)value_ error:(NSError**)error_;




@property (nonatomic, retain) NSNumber *isEligible;


@property BOOL isEligibleValue;
- (BOOL)isEligibleValue;
- (void)setIsEligibleValue:(BOOL)value_;

//- (BOOL)validateIsEligible:(id*)value_ error:(NSError**)error_;




@property (nonatomic, retain) NSDate *lastVisit;


//- (BOOL)validateLastVisit:(id*)value_ error:(NSError**)error_;




@property (nonatomic, retain) NSString *lastVisitSummaryNote;


//- (BOOL)validateLastVisitSummaryNote:(id*)value_ error:(NSError**)error_;




@property (nonatomic, retain) NSNumber *latitude;


@property float latitudeValue;
- (float)latitudeValue;
- (void)setLatitudeValue:(float)value_;

//- (BOOL)validateLatitude:(id*)value_ error:(NSError**)error_;




@property (nonatomic, retain) NSNumber *longitude;


@property float longitudeValue;
- (float)longitudeValue;
- (void)setLongitudeValue:(float)value_;

//- (BOOL)validateLongitude:(id*)value_ error:(NSError**)error_;




@property (nonatomic, retain) NSString *name;


//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;




@property (nonatomic, retain) NSNumber *neverVisit;


@property BOOL neverVisitValue;
- (BOOL)neverVisitValue;
- (void)setNeverVisitValue:(BOOL)value_;

//- (BOOL)validateNeverVisit:(id*)value_ error:(NSError**)error_;




@property (nonatomic, retain) NSDate *nextScheduledVisit;


//- (BOOL)validateNextScheduledVisit:(id*)value_ error:(NSError**)error_;




@property (nonatomic, retain) NSString *nextScheduledVisitDate;


//- (BOOL)validateNextScheduledVisitDate:(id*)value_ error:(NSError**)error_;




@property (nonatomic, retain) NSString *nextScheduledVisitTime;


//- (BOOL)validateNextScheduledVisitTime:(id*)value_ error:(NSError**)error_;




@property (nonatomic, retain) NSNumber *numberOfEmployees;


@property int numberOfEmployeesValue;
- (int)numberOfEmployeesValue;
- (void)setNumberOfEmployeesValue:(int)value_;

//- (BOOL)validateNumberOfEmployees:(id*)value_ error:(NSError**)error_;




@property (nonatomic, retain) NSNumber *numberOfLocations;


@property short numberOfLocationsValue;
- (short)numberOfLocationsValue;
- (void)setNumberOfLocationsValue:(short)value_;

//- (BOOL)validateNumberOfLocations:(id*)value_ error:(NSError**)error_;




@property (nonatomic, retain) NSString *primaryContact;


//- (BOOL)validatePrimaryContact:(id*)value_ error:(NSError**)error_;




@property (nonatomic, retain) NSString *producerCode;


//- (BOOL)validateProducerCode:(id*)value_ error:(NSError**)error_;




@property (nonatomic, retain) NSNumber *prospect;


@property BOOL prospectValue;
- (BOOL)prospectValue;
- (void)setProspectValue:(BOOL)value_;

//- (BOOL)validateProspect:(id*)value_ error:(NSError**)error_;




@property (nonatomic, retain) NSDate *statusDate;


//- (BOOL)validateStatusDate:(id*)value_ error:(NSError**)error_;




@property (nonatomic, retain) NSNumber *submitted;


@property BOOL submittedValue;
- (BOOL)submittedValue;
- (void)setSubmittedValue:(BOOL)value_;

//- (BOOL)validateSubmitted:(id*)value_ error:(NSError**)error_;




@property (nonatomic, retain) NSString *uid;


//- (BOOL)validateUid:(id*)value_ error:(NSError**)error_;




@property (nonatomic, retain) NSString *webAddress;


//- (BOOL)validateWebAddress:(id*)value_ error:(NSError**)error_;





@property (nonatomic, retain) NSSet* addresses;

- (NSMutableSet*)addressesSet;




@property (nonatomic, retain) AUNTK* auntk;

//- (BOOL)validateAuntk:(id*)value_ error:(NSError**)error_;




@property (nonatomic, retain) AUNTK* chainAuntk;

//- (BOOL)validateChainAuntk:(id*)value_ error:(NSError**)error_;




@property (nonatomic, retain) NSSet* contacts;

- (NSMutableSet*)contactsSet;




@property (nonatomic, retain) DailySummary* dailySummary;

//- (BOOL)validateDailySummary:(id*)value_ error:(NSError**)error_;




@property (nonatomic, retain) NSSet* emails;

- (NSMutableSet*)emailsSet;




@property (nonatomic, retain) HoursOfOperation* hoursOfOperation;

//- (BOOL)validateHoursOfOperation:(id*)value_ error:(NSError**)error_;




@property (nonatomic, retain) NSSet* images;

- (NSMutableSet*)imagesSet;




@property (nonatomic, retain) IneligibleReason* ineligibleReason;

//- (BOOL)validateIneligibleReason:(id*)value_ error:(NSError**)error_;




@property (nonatomic, retain) NSSet* phoneNumbers;

- (NSMutableSet*)phoneNumbersSet;




@property (nonatomic, retain) NSSet* questions;

- (NSMutableSet*)questionsSet;




@property (nonatomic, retain) Rater* rater;

//- (BOOL)validateRater:(id*)value_ error:(NSError**)error_;




@property (nonatomic, retain) Rater2* rater2;

//- (BOOL)validateRater2:(id*)value_ error:(NSError**)error_;




@property (nonatomic, retain) Status* status;

//- (BOOL)validateStatus:(id*)value_ error:(NSError**)error_;




@property (nonatomic, retain) SubTerritory* subTerritory;

//- (BOOL)validateSubTerritory:(id*)value_ error:(NSError**)error_;




@property (nonatomic, retain) SuspensionReason* suspensionReason;

//- (BOOL)validateSuspensionReason:(id*)value_ error:(NSError**)error_;




@end

@interface _Producer (CoreDataGeneratedAccessors)

- (void)addAddresses:(NSSet*)value_;
- (void)removeAddresses:(NSSet*)value_;
- (void)addAddressesObject:(AddressListItem*)value_;
- (void)removeAddressesObject:(AddressListItem*)value_;

- (void)addContacts:(NSSet*)value_;
- (void)removeContacts:(NSSet*)value_;
- (void)addContactsObject:(Contact*)value_;
- (void)removeContactsObject:(Contact*)value_;

- (void)addEmails:(NSSet*)value_;
- (void)removeEmails:(NSSet*)value_;
- (void)addEmailsObject:(EmailListItem*)value_;
- (void)removeEmailsObject:(EmailListItem*)value_;

- (void)addImages:(NSSet*)value_;
- (void)removeImages:(NSSet*)value_;
- (void)addImagesObject:(ProducerImage*)value_;
- (void)removeImagesObject:(ProducerImage*)value_;

- (void)addPhoneNumbers:(NSSet*)value_;
- (void)removePhoneNumbers:(NSSet*)value_;
- (void)addPhoneNumbersObject:(PhoneListItem*)value_;
- (void)removePhoneNumbersObject:(PhoneListItem*)value_;

- (void)addQuestions:(NSSet*)value_;
- (void)removeQuestions:(NSSet*)value_;
- (void)addQuestionsObject:(QuestionListItem*)value_;
- (void)removeQuestionsObject:(QuestionListItem*)value_;

@end

@interface _Producer (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveAddress;
- (void)setPrimitiveAddress:(NSString*)value;




- (NSDate*)primitiveAppointedDate;
- (void)setPrimitiveAppointedDate:(NSDate*)value;




- (NSDate*)primitiveDateEstablished;
- (void)setPrimitiveDateEstablished:(NSDate*)value;




- (NSDate*)primitiveEAndOExpires;
- (void)setPrimitiveEAndOExpires:(NSDate*)value;




- (NSNumber*)primitiveEdited;
- (void)setPrimitiveEdited:(NSNumber*)value;

- (BOOL)primitiveEditedValue;
- (void)setPrimitiveEditedValue:(BOOL)value_;




- (NSNumber*)primitiveHasAccessSign;
- (void)setPrimitiveHasAccessSign:(NSNumber*)value;

- (BOOL)primitiveHasAccessSignValue;
- (void)setPrimitiveHasAccessSignValue:(BOOL)value_;




- (NSNumber*)primitiveIsEligible;
- (void)setPrimitiveIsEligible:(NSNumber*)value;

- (BOOL)primitiveIsEligibleValue;
- (void)setPrimitiveIsEligibleValue:(BOOL)value_;




- (NSDate*)primitiveLastVisit;
- (void)setPrimitiveLastVisit:(NSDate*)value;




- (NSString*)primitiveLastVisitSummaryNote;
- (void)setPrimitiveLastVisitSummaryNote:(NSString*)value;




- (NSNumber*)primitiveLatitude;
- (void)setPrimitiveLatitude:(NSNumber*)value;

- (float)primitiveLatitudeValue;
- (void)setPrimitiveLatitudeValue:(float)value_;




- (NSNumber*)primitiveLongitude;
- (void)setPrimitiveLongitude:(NSNumber*)value;

- (float)primitiveLongitudeValue;
- (void)setPrimitiveLongitudeValue:(float)value_;




- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;




- (NSNumber*)primitiveNeverVisit;
- (void)setPrimitiveNeverVisit:(NSNumber*)value;

- (BOOL)primitiveNeverVisitValue;
- (void)setPrimitiveNeverVisitValue:(BOOL)value_;




- (NSDate*)primitiveNextScheduledVisit;
- (void)setPrimitiveNextScheduledVisit:(NSDate*)value;




- (NSString*)primitiveNextScheduledVisitDate;
- (void)setPrimitiveNextScheduledVisitDate:(NSString*)value;




- (NSString*)primitiveNextScheduledVisitTime;
- (void)setPrimitiveNextScheduledVisitTime:(NSString*)value;




- (NSNumber*)primitiveNumberOfEmployees;
- (void)setPrimitiveNumberOfEmployees:(NSNumber*)value;

- (int)primitiveNumberOfEmployeesValue;
- (void)setPrimitiveNumberOfEmployeesValue:(int)value_;




- (NSNumber*)primitiveNumberOfLocations;
- (void)setPrimitiveNumberOfLocations:(NSNumber*)value;

- (short)primitiveNumberOfLocationsValue;
- (void)setPrimitiveNumberOfLocationsValue:(short)value_;




- (NSString*)primitivePrimaryContact;
- (void)setPrimitivePrimaryContact:(NSString*)value;




- (NSString*)primitiveProducerCode;
- (void)setPrimitiveProducerCode:(NSString*)value;




- (NSNumber*)primitiveProspect;
- (void)setPrimitiveProspect:(NSNumber*)value;

- (BOOL)primitiveProspectValue;
- (void)setPrimitiveProspectValue:(BOOL)value_;




- (NSDate*)primitiveStatusDate;
- (void)setPrimitiveStatusDate:(NSDate*)value;




- (NSNumber*)primitiveSubmitted;
- (void)setPrimitiveSubmitted:(NSNumber*)value;

- (BOOL)primitiveSubmittedValue;
- (void)setPrimitiveSubmittedValue:(BOOL)value_;




- (NSString*)primitiveUid;
- (void)setPrimitiveUid:(NSString*)value;




- (NSString*)primitiveWebAddress;
- (void)setPrimitiveWebAddress:(NSString*)value;





- (NSMutableSet*)primitiveAddresses;
- (void)setPrimitiveAddresses:(NSMutableSet*)value;



- (AUNTK*)primitiveAuntk;
- (void)setPrimitiveAuntk:(AUNTK*)value;



- (AUNTK*)primitiveChainAuntk;
- (void)setPrimitiveChainAuntk:(AUNTK*)value;



- (NSMutableSet*)primitiveContacts;
- (void)setPrimitiveContacts:(NSMutableSet*)value;



- (DailySummary*)primitiveDailySummary;
- (void)setPrimitiveDailySummary:(DailySummary*)value;



- (NSMutableSet*)primitiveEmails;
- (void)setPrimitiveEmails:(NSMutableSet*)value;



- (HoursOfOperation*)primitiveHoursOfOperation;
- (void)setPrimitiveHoursOfOperation:(HoursOfOperation*)value;



- (NSMutableSet*)primitiveImages;
- (void)setPrimitiveImages:(NSMutableSet*)value;



- (IneligibleReason*)primitiveIneligibleReason;
- (void)setPrimitiveIneligibleReason:(IneligibleReason*)value;



- (NSMutableSet*)primitivePhoneNumbers;
- (void)setPrimitivePhoneNumbers:(NSMutableSet*)value;



- (NSMutableSet*)primitiveQuestions;
- (void)setPrimitiveQuestions:(NSMutableSet*)value;



- (Rater*)primitiveRater;
- (void)setPrimitiveRater:(Rater*)value;



- (Rater2*)primitiveRater2;
- (void)setPrimitiveRater2:(Rater2*)value;



- (Status*)primitiveStatus;
- (void)setPrimitiveStatus:(Status*)value;



- (SubTerritory*)primitiveSubTerritory;
- (void)setPrimitiveSubTerritory:(SubTerritory*)value;



- (SuspensionReason*)primitiveSuspensionReason;
- (void)setPrimitiveSuspensionReason:(SuspensionReason*)value;


@end
