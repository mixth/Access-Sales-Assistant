#import "Contact.h"

@implementation Contact

- (void)safeSetValuesForKeysWithDictionary:(NSDictionary *)keyedValues dateFormatter:(NSDateFormatter *)dateFormatter managedObjectContext:(NSManagedObjectContext *)context
{
	[super safeSetValuesForKeysWithDictionary:keyedValues dateFormatter:dateFormatter managedObjectContext:context];
	self.type = [ContactType findFirstByAttribute:@"uid" withValue:[keyedValues valueForKeyPath:@"type.uid"] inContext:context];
}

- (PhoneListItem *)mobilePhoneInManagedObjectContext:(NSManagedObjectContext *)context
{
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"type = 5"];
	PhoneListItem *phone = [[self.phoneList.allObjects filteredArrayUsingPredicate:predicate] lastObject];
	if (!phone) {
		phone = [PhoneListItem createInContext:context];
		phone.typeValue = 5;
	}
	return phone;
}

@end
