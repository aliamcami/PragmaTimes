//
//  PickerView_Model.h
//  chronometer
//
//  Created by Giovani Ferreira Silvério da Silva on 20/04/15.
//  Copyright (c) 2015 Giovani Ferreira Silvério da Silva. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PickerView_Model : UIView <UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic) int min;
@property (nonatomic) int sec;

@end
