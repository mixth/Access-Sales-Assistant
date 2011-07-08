//
//  ProducerGeneralTableViewCell.h
//  Access Sales Assistant
//
//  Created by Ross Chapman on 7/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProducerGeneralTableViewCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UITextField *producerCodeTextField;
@property (nonatomic, strong) IBOutlet UITextField *subTerritoryTextField;
@property (nonatomic, strong) IBOutlet UITextField *producerNameTextField;
@property (nonatomic, strong) IBOutlet UITextField *eOExpiresTextField;
@property (nonatomic, strong) IBOutlet UITextField *numberOfLocationsTextField;
@property (nonatomic, strong) IBOutlet UITextField *accessSignTextField;
@property (nonatomic, strong) IBOutlet UITextField *dateEstablishedTextField;

@property (nonatomic, strong) IBOutlet UIButton *numberOfLocationsButton;
@property (nonatomic, strong) IBOutlet UIButton *dateEstablishedButton;
@property (nonatomic, strong) IBOutlet UIButton *subTerritoryButton;
@property (nonatomic, strong) IBOutlet UIButton *eOExpiresButton;
@property (nonatomic, strong) IBOutlet UIButton *accessSignButton;

@end