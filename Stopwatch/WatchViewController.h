//
//  WatchViewController.h
//  Stopwatch
//
//  Created by Jason Berk on 8/15/13.
//  Copyright (c) 2013 Jason Berk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WatchViewController : UIViewController <UITableViewDataSource> // <- Suggests that we implement methods that UITableView will use
- (IBAction)startStop:(UIBarButtonItem *)sender;
- (IBAction)clearLap:(UIBarButtonItem *)sender;



@property (weak, nonatomic) IBOutlet UITableView *lapsTable;
@property (weak, nonatomic) IBOutlet UILabel *timeCountLabel;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *startStopButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *clearLapButton;


@property (strong, nonatomic) CADisplayLink *displayLink;

NSString *StopwatchStringFromTimeInterval(NSTimeInterval timeInterval);

@end
