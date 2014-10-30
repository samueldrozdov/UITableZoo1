//
//  CustomTableViewCell.m
//  UITableZoo
//
//  Created by Samuel Drozdov on 10/29/14.
//  Copyright (c) 2014 MoonAnimals. All rights reserved.
//

#import "CustomTableViewCell.h"

@implementation CustomTableViewCell {
    __weak IBOutlet UIButton *randomColorButton;
}


- (void)awakeFromNib {
    [super awakeFromNib];

    [randomColorButton setTitle:@"Color" forState:UIControlStateNormal];

    //Make the button into a circle
    randomColorButton.clipsToBounds = YES;
    randomColorButton.layer.cornerRadius = 60/2.0f;
    randomColorButton.layer.borderWidth = 2.0f;
    randomColorButton.layer.borderColor = [UIColor blackColor].CGColor;
    
    [randomColorButton setTintColor:[UIColor blackColor]];
    [randomColorButton setBackgroundColor:[UIColor whiteColor]];
}

- (IBAction)randomColorButtonPressed:(id)sender {
    float colorValue1 = arc4random_uniform(255) + 1;
    float colorValue2 = arc4random_uniform(255) + 1;
    float colorValue3 = arc4random_uniform(255) + 1;
    [self setBackgroundColor:[UIColor colorWithRed:colorValue1/255.0 green:colorValue2/255.0 blue:colorValue3/255.0 alpha:1.0]];
}

@end
