//
//  PickerView_Model.m
//  chronometer
//
//  Created by Giovani Ferreira Silvério da Silva on 20/04/15.
//  Copyright (c) 2015 Giovani Ferreira Silvério da Silva. All rights reserved.
//

#import "PickerView_Model.h"

@interface PickerView_Model ()

@property (nonatomic) UIPickerView *pickerView;
@property (nonatomic) NSMutableArray *timeData;

@end

@implementation PickerView_Model

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.timeData = [[NSMutableArray alloc] init];
        for (int i = 0; i <= 59; i++) {
            [self.timeData addObject:[NSNumber numberWithInt:i]];
        }
        
        self.pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.width)];
        self.pickerView.dataSource = self;
        self.pickerView.delegate = self;
        
        [self.pickerView selectRow:30 inComponent:0 animated:YES];
        [self.pickerView selectRow:30 inComponent:1 animated:YES];
        
        [self addSubview:self.pickerView];
    }
    return self;
}

// The number of columns of data
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

// The number of rows of data
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.timeData.count;
}

// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [NSString stringWithFormat:@"%d", [self.timeData[row] intValue] ];
}

// Catpure the picker view selection
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0) {
        self.min = [[self.timeData objectAtIndex:row] intValue];
    }else{
        self.sec = [[self.timeData objectAtIndex:row] intValue];
    }
}

@end
