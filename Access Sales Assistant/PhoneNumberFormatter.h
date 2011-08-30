//
//  PhoneNumberFormatter.h
//  Access Sales Assistant
//
//  Created by Easwara Reddy Illuri on 8/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface PhoneNumberFormatter : NSObject {
    
    //stores predefiend formats for each locale
    
    NSDictionary *predefinedFormats;
    
}



/*
 
 Loads predefined formats for each locale.
 
 
 
 The formats should be sorted so as more restrictive formats should come first.
 
 
 
 This is necessary as the formatting code processes the formats in order and
 
 selects the first one that matches the whole input string.
 
 */

- (id)init;



/*
 
 Attemps to format the phone number to the specified locale.
 
 */

- (NSString *)format:(NSString *)phoneNumber withLocale:(NSString *)locale;



/*
 
 Strips the input string from characters added by the formatter.
 
 Namely, it removes any character that couldn't have been entered by the user.
 
 */

- (NSString *)strip:(NSString *)phoneNumber;



/*
 
 Returns true if the character comes from a phone pad.
 
 */

- (BOOL)canBeInputByPhonePad:(char)c;



@end
