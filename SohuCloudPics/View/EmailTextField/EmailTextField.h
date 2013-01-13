//
//  DropDownTextField.h
//  TestDropDownList
//
//  Created by Zhong Sheng on 12-9-10.
//  Copyright (c) 2012年 sohu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EmailTextFieldManager;

@interface EmailTextField : UITextField
{
    UITableView *_dropDownListTable;
    BOOL _isOn;
    
    NSArray *_domains;
    EmailTextFieldManager *_manager;
}

@property (nonatomic, readonly) NSArray *domains;

- (id)initWithFrame:(CGRect)frame dropDownListFrame:(CGRect)dFrame domainsArray:(NSArray *)domains;

- (BOOL)isDropDownListOn;
- (void)showDropDownList;
- (void)hideDropDownList;
- (void)freshDropDownList;

@end
