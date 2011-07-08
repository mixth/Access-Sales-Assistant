//
//  ProducerStatusTableViewCell.m
//  Access Sales Assistant
//
//  Created by Ross Chapman on 7/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ProducerStatusTableViewCell.h"

@implementation ProducerStatusTableViewCell
@synthesize appointedDateTextField=_appointedDateTextField;
@synthesize statusTextField = _statusTextField;
@synthesize statusDateTextField = _statusDateTextField;
@synthesize reasonIneligibleTextField = _reasonIneligibleTextField;
@synthesize suspensionReasonTextField = _suspensionReasonTextField;
@synthesize eligibleTextField = _eligibleTextField;
@synthesize statusButton = _statusButton;
@synthesize suspensionReasonButton = _suspensionReasonButton;
@synthesize eligibleButton = _eligibleButton;
@synthesize reasonIneligibleButton = _reasonIneligibleButton;
@synthesize statusDateButton = _statusDateButton;
@synthesize appointedDateButton = _appointedDateButton;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
