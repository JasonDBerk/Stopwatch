//
//  WatchViewController.m
//  Stopwatch
//
//  Created by Jason Berk on 8/15/13.
//  Copyright (c) 2013 Jason Berk. All rights reserved.
//




/*
-Is there a way to make the tableview auto scroll down when a new lap is added beneath the bottom?
 
Best times design:
 -lists = course names, accessed by drop down menu (with "new course" option).
 -saved laps colored blue, very best time on course colored green
 -laps have date stamps and can have tags for details. 
 
 -tap saved laps to access tag / send-to-list menu
 -"Star" laps to save them, will not be cleared when hit clear.
    OR
 -tap unsaved laps to replace lap label with "Save / Cancel"
 -tap saved laps to replace lap label with "Add tag / Send to list / Unsave"

 
 Implementation:
 -will need to use didSelectRowAtIndexPath (kind of like an action?)
    -upon tap, save contents (the lap time is stored in an array that is about to be modified [I think])
    -upon tap, load appropriate buttons with [cell.contentView addSubview:theButton]
 
 
 -Will need a new array for each list (and an array of these arrays)
 
 
 */



#import "WatchViewController.h"
#import <QuartzCore/QuartzCore.h>

NSString *StopwatchStringFromTimeInterval(NSTimeInterval timeInterval) {
    int hourCount = (int)timeInterval / 3600;
    timeInterval -= hourCount * 3600;
    int minuteCount = (int)timeInterval / 60;
    timeInterval -= minuteCount * 60;
    int secondCount = (int)timeInterval;
    timeInterval -= (int)timeInterval;
    int milliSecondCount = timeInterval * 1000;
    NSString *timeString = [NSString stringWithFormat:@"%.2i:%.2i:%.2i:%.3i",hourCount,minuteCount,secondCount,milliSecondCount];
    return timeString;
}


@interface WatchViewController ()
@property NSMutableArray *lapTimes;
@end



@implementation WatchViewController



// VARIABLES:               //use properties instead?
BOOL runTimer = NO;
BOOL firstStart = YES;
NSDate *startTime;
NSDate *stopTime;
NSTimeInterval timeCount = 0;
NSTimeInterval stopCount = 0;



// USER ACTIONS:
- (IBAction)startStop:(UIBarButtonItem *)sender
{

    
    if (runTimer == NO) {         //Start button hit
        runTimer = YES;
        [self.startStopButton setTitle:@"Stop"];
        [self.clearLapButton setTitle:@"Lap"];
        
        /////
        if (firstStart == YES) {
            firstStart = NO;
            startTime = [NSDate date];
            self.displayLink.paused = NO;
        }
        else {
            stopCount += [[NSDate date] timeIntervalSinceDate:stopTime];
        }
        //////
        
    }
    else {        //Pause button hit
        stopTime = [NSDate date];
        runTimer = NO;
        [self.startStopButton setTitle:@"Start"];
        [self.clearLapButton setTitle:@"Clear"];
    }

    
}

- (IBAction)clearLap:(UIBarButtonItem *)sender
{
    if (runTimer == NO) {
        //Clear button hit
        firstStart = YES;
        timeCount = 0;
        stopCount = 0;
        [self updateTimeCountLabel];
        self.lapTimes = [NSMutableArray array];                                             // !!!!! dirty way to do this?
        [self.lapsTable reloadData];
        //reset
    }
    else {
        //Lap button hit
        [self.lapTimes addObject:StopwatchStringFromTimeInterval(timeCount)];
        [self.lapsTable reloadData];
        [self scrollToLastRow];
        //create TableViewCell and print (timeCount or timeCountLabel.text? Should be the same)
    }

}



// COUNTER LABEL:
- (void)updateTimeCountLabel
{
    [self.timeCountLabel setText:StopwatchStringFromTimeInterval(timeCount)];
}

- (void)updateTimeCount
{
    timeCount = [[NSDate date] timeIntervalSinceDate:startTime] - stopCount;
    NSAssert(!isnan(timeCount), @"Timecount should not be NaN");
}

- (void)performAtScreenRefresh:(CADisplayLink *)sender
{
   if (runTimer == YES) {
       [self updateTimeCount];
       [self updateTimeCountLabel];
    }
}









// LAPS TABLE:
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.lapTimes.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Table view: "What should I show at (3,5) ?"
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Lap Cell"];  //get cell from here
    
    // Configure the cell for indexPath
    cell.textLabel.text = self.lapTimes[indexPath.row];
    return cell;
}



-(void)scrollToLastRow {
    NSIndexPath *bottomCell = [NSIndexPath indexPathForRow:(self.lapTimes.count - 1) inSection:0];
    [self.lapsTable scrollToRowAtIndexPath:bottomCell atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}





// SETUP:
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.displayLink=[CADisplayLink displayLinkWithTarget:self selector:@selector(performAtScreenRefresh:)];
    [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    self.displayLink.paused = YES;
    self.lapTimes = [NSMutableArray array];
    //self.lapsTable.backgroundColor = [UIColor blackColor];
    //self.lapsTableCell.textLabel.textColor = [UIColor whiteColor];
    //self.lapsTableCell.backgroundColor = [UIColor blackColor];

}



@end
