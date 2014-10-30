//
//  UIZooTableViewController.m
//  UITableZoo
//
//  Created by Samuel Drozdov on 10/26/14.
//  Copyright (c) 2014 MoonAnimals. All rights reserved.
//

#import "UIZooTableViewController.h"
#import "CustomTableViewCell.h"

@interface UIZooTableViewController () {
    UISegmentedControl *headerMenu;
    float lastOffset;
    float originalOffset;
}

@end

@implementation UIZooTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    headerMenu = [[UISegmentedControl alloc] initWithItems:@[@"Category1",@"Category2",@"Category3"]];
    [headerMenu setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    
    //
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(cellSwipedRight:)];
    [swipeRight setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [self.tableView addGestureRecognizer:swipeRight];
    
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(cellSwipedLeft:)];
    [swipeLeft setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    [self.tableView addGestureRecognizer:swipeLeft];
    
    //Colors
    [self.tableView setBackgroundColor:[UIColor colorWithRed:44/255.0 green:62/255.0 blue:80/255.0 alpha:1]];
}

-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}


#pragma mark - Table view data source

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 120;

}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,
                                                                  self.view.frame.size.width,
                                                                  120)];
    NSInteger headerMenuPadding = 10;
    
    [headerMenu setFrame:CGRectMake(headerMenuPadding,
                                    headerView.frame.size.height*0.7 - headerMenuPadding,
                                    self.view.frame.size.width - headerMenuPadding*2,
                                    headerView.frame.size.height*0.3)];
    [headerView addSubview:headerMenu];
    
    [headerView setBackgroundColor:[UIColor colorWithRed:44/255.0 green:62/255.0 blue:80/255.0 alpha:1]];
    [headerMenu setTintColor:[UIColor colorWithRed:236/255.0 green:240/255.0 blue:241/255.0 alpha:1.0]];
    [headerMenu setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:236/255.0 green:240/255.0 blue:241/255.0 alpha:1],
                                         NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:15]}
                              forState:UIControlStateNormal];

    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.mainTextLabel.text = @"0";
    [cell setBackgroundColor:[UIColor whiteColor]];
    
    return cell;
}

#pragma mark - Header View Mechanic

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //table view properties
    CGFloat currentOffset = self.tableView.contentOffset.y;
    CGFloat currentInset = scrollView.frame.origin.y;
    CGFloat headerHeight = 120;
    //amount scrolled since last method call
    CGFloat offSetDifference = currentOffset - lastOffset;
    
    if(currentInset <= 0 && currentInset >= -headerHeight
        && currentOffset >= 0 && currentOffset <= (self.tableView.contentSize.height - self.tableView.bounds.size.height)) {
        //downward scroll, drag upward, hides header
        if(scrollView.contentOffset.y > lastOffset) {
            if(currentInset-offSetDifference < -headerHeight) {
                offSetDifference = headerHeight + currentInset;
                [scrollView setFrame:CGRectMake(0, currentInset-offSetDifference,
                                                self.view.frame.size.width,
                                                self.view.frame.size.height+offSetDifference)];
            } else {
                [scrollView setFrame:CGRectMake(0, currentInset-offSetDifference,
                                                self.view.frame.size.width,
                                                self.view.frame.size.height+offSetDifference)];
            }
            
        //upward scroll, drag downward, shows header
        } else {
            if(currentOffset < headerHeight - headerMenu.frame.size.height - 20) {
                if(currentInset-offSetDifference > 0) {
                    offSetDifference = currentInset - 0;
                    [scrollView setFrame:CGRectMake(0, currentInset-offSetDifference,
                                                    self.view.frame.size.width,
                                                    self.view.frame.size.height+offSetDifference)];
                } else {
                    [scrollView setFrame:CGRectMake(0, currentInset-offSetDifference,
                                                    self.view.frame.size.width,
                                                    self.view.frame.size.height+offSetDifference)];
                }
            } else {
                if(currentInset-offSetDifference > -(headerHeight - headerMenu.frame.size.height-20)) {
                    offSetDifference = currentInset - -(headerHeight - headerMenu.frame.size.height-20);
                    [scrollView setFrame:CGRectMake(0, currentInset-offSetDifference,
                                                    self.view.frame.size.width,
                                                    self.view.frame.size.height+offSetDifference)];
                } else {
                    [scrollView setFrame:CGRectMake(0, currentInset-offSetDifference,
                                                    self.view.frame.size.width,
                                                    self.view.frame.size.height+offSetDifference)];
                }
            }
        }
    }
    
    //update new offset
    lastOffset = currentOffset;
}

#pragma mark - Buttons and Gestures

-(void)cellSwipedLeft:(UIGestureRecognizer*)gesture {
    CGPoint location = [gesture locationInView:self.tableView];
    NSIndexPath *swipedIndexPath = [self.tableView indexPathForRowAtPoint:location];
    CustomTableViewCell *cell = (CustomTableViewCell*)[self.tableView cellForRowAtIndexPath:swipedIndexPath];
    
    if(cell)
    [UIView animateWithDuration:0.3 animations:^{
        [cell setFrame:CGRectMake(-cell.frame.size.width*5/4, cell.frame.origin.y, cell.frame.size.width, cell.frame.size.height)];
    } completion:^(BOOL finished) {
        if(finished)
            [UIView animateWithDuration:0 animations:^{
                [cell setFrame:CGRectMake(cell.frame.size.width*5/4, cell.frame.origin.y, cell.frame.size.width, cell.frame.size.height)];
            } completion:^(BOOL finished) {
                if(finished) {
                    //Perform actions here while cell is not visible
                    int number = [cell.mainTextLabel.text intValue];
                    cell.mainTextLabel.text = [NSString stringWithFormat:@"%i",++number];
                    
                    [UIView animateWithDuration:0.3 animations:^{
                        [cell setFrame:CGRectMake(0, cell.frame.origin.y, cell.frame.size.width, cell.frame.size.height)];
                    }];
                }
            }];
    }];
}

-(void)cellSwipedRight:(UIGestureRecognizer*)gesture {
    CGPoint location = [gesture locationInView:self.tableView];
    NSIndexPath *swipedIndexPath = [self.tableView indexPathForRowAtPoint:location];
    CustomTableViewCell *cell = (CustomTableViewCell*)[self.tableView cellForRowAtIndexPath:swipedIndexPath];
    
    if(cell)
    [UIView animateWithDuration:0.3 animations:^{
        [cell setFrame:CGRectMake(cell.frame.size.width*5/4, cell.frame.origin.y, cell.frame.size.width, cell.frame.size.height)];
    } completion:^(BOOL finished){
        if(finished) {
            [UIView animateWithDuration:0 animations:^{
                [cell setFrame:CGRectMake(-cell.frame.size.width*5/4, cell.frame.origin.y, cell.frame.size.width, cell.frame.size.height)];
            } completion:^(BOOL finished){
                if(finished) {
                    //Perform actions here while cell is not visible
                    int number = [cell.mainTextLabel.text intValue];
                    cell.mainTextLabel.text = [NSString stringWithFormat:@"%i",--number];
                    
                    [UIView animateWithDuration:0.3 animations:^{
                        [cell setFrame:CGRectMake(0, cell.frame.origin.y, cell.frame.size.width, cell.frame.size.height)];
                    }];
                }
            }];
        }
    }];
}



@end
