//
//  FlashCardFlipView.m
//  Access Sales Assistant
//
//  Created by Easwara Reddy Illuri on 7/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//



#import "FlashCardFlipView.h"

@implementation FlashCardFlipView

#define CALLS_TITLES @"Prospect",@"ZeroProducer",@"Producer",nil
#define FLASH_TITLES@"Objective",@"Overview",@"SalesPitch",@"Visit_Questions",@"Close",nil

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
                self.backgroundColor = [UIColor blueColor];
        // Initialization code
    }
    return self;
}


-(id) initWithFrame:(CGRect)frame :(int)forFlashCard :(int)forIndex
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor redColor];
        
        callTitleArray = [[NSArray alloc] initWithObjects:CALLS_TITLES];
        flashTitleArray = [[NSArray alloc] initWithObjects:FLASH_TITLES];
        
        
      //  UIImageView* imageView = [[UIImageView alloc] initWithFrame:frame];
        //imageView.image = [UIImage imageNamed:@"calls-background.png"];
        //[self addSubview:imageView];
        CGRect rec = CGRectMake(frame.origin.x + 10, frame.origin.y + 10, frame.size.width-20, frame.size.height-20);
        UIWebView *webView = [[UIWebView alloc] initWithFrame:frame];
        webView.userInteractionEnabled = NO;
      //  webView.layer.cornerRadius = 5;
        webView.clipsToBounds = YES;
        
        [self addSubview:webView];
        
        NSString *urlAddress = [[NSString alloc] initWithFormat:@"%@_%@_Content",[callTitleArray objectAtIndex:forFlashCard],[flashTitleArray objectAtIndex:forIndex]];
     //   NSURL *url = [NSURL URLWithString:urlAddress];
        
        
        NSString *path = [[NSBundle mainBundle] pathForResource:urlAddress ofType:@"html"];
        NSURL *url = [NSURL fileURLWithPath:path];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [webView loadRequest:request];
            
        //URL Requst Object
     //   NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
        
     //   [webView loadRequest:requestObj];

        

       }
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
