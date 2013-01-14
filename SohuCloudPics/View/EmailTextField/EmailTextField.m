//
//  DropDownTextField.m
//  TestDropDownList
//
//  Created by Zhong Sheng on 12-9-10.
//  Copyright (c) 2012年 sohu.com. All rights reserved.
//

#import "EmailTextField.h"

#import <stdlib.h>
#import <QuartzCore/QuartzCore.h>


@implementation NSString (indexOfChar)
- (NSInteger)firstIndexOfChar:(unichar)c
{
    int i = 0, len = self.length;
    for (; i < len && [self characterAtIndex:i] != c; ++i) {
        ;
    }
    if (i == len) {
        return -1;
    }
    return i;
}
@end



@interface EmailTextFieldManager : NSObject <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
{
    EmailTextField *eTextField;
    NSArray *domains;
    
    NSString *emailAccount;
	NSMutableArray *filtered_domains;
}

- (id)initWithEmailTextField:(EmailTextField *)textField;

@end

@implementation EmailTextFieldManager

- (id)initWithEmailTextField:(EmailTextField *)textField
{
    self = [super init];
    if (self) {
        eTextField = textField;
        domains = eTextField.domains;
		filtered_domains = [[NSMutableArray arrayWithCapacity:0] retain];
    }
    return self;
}

- (void)dealloc
{
	if (emailAccount) {
		[emailAccount release];
	}
	if (filtered_domains) {
		[filtered_domains release];
	}
	
	[super dealloc];
}

#pragma mark methods for UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSString *email = eTextField.text;
    if (email != nil && email.length != 0) {
        [eTextField showDropDownList];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [eTextField hideDropDownList];
}

#pragma mark methods for notification center
- (void)textFieldValueChanged:(id)sender
{
    NSString *email = eTextField.text;
    if (email != nil && email.length != 0) {
        [eTextField showDropDownList];
    } else {
        [eTextField hideDropDownList];
        return;
    }
    
    int lastIndexOfAt = [email firstIndexOfChar:'@'];
    if (lastIndexOfAt == -1) { // there is no @
        emailAccount = [email copy];
		
		[filtered_domains removeAllObjects];
		[filtered_domains addObjectsFromArray:domains];
        
		[eTextField freshDropDownList];
        
    } else { // there is an @
        emailAccount = [[email substringToIndex:lastIndexOfAt] copy];
        NSString *emailDomain = [email substringFromIndex:lastIndexOfAt + 1];
		
		[filtered_domains removeAllObjects];
		if (!emailDomain || [emailDomain isEqualToString:@""]) {
			[filtered_domains addObjectsFromArray:domains];
		} else {
			for (NSString *domain in domains) {
				NSRange range = [domain rangeOfString:emailDomain];
				if (range.location == 0) {
					[filtered_domains addObject:domain];
				}
			}
		}
		
        [eTextField freshDropDownList];
    }
}

#pragma mark methods from UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 24.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	eTextField.text = [NSString stringWithFormat:@"%@@%@", emailAccount, [filtered_domains objectAtIndex:(indexPath.row)]];
    [eTextField resignFirstResponder];
}

#pragma mark methods from UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return filtered_domains.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *EmailCellIdentifier = @"EmailCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:EmailCellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:EmailCellIdentifier] autorelease];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.textLabel.textColor = [UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1];
    }
	NSString *text = [NSString stringWithFormat:@"%@@%@", emailAccount, [filtered_domains objectAtIndex:(indexPath.row)]];
    
    cell.textLabel.text = text;
    return cell;
}

@end

@implementation EmailTextField

// domains is read only

@synthesize domains = _domains;

- (id)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame dropDownListFrame:CGRectZero domainsArray:nil];
}
- (id)initWithFrame:(CGRect)frame dropDownListFrame:(CGRect)dFrame domainsArray:(NSArray *)domains
{
    self = [super initWithFrame:frame];
    if (self) {
        self.keyboardType = UIKeyboardTypeEmailAddress;
        self.autocapitalizationType = UITextAutocapitalizationTypeNone;
        self.autocorrectionType = UITextAutocorrectionTypeNo;
        
        _dropDownListTable = [[UITableView alloc] initWithFrame:dFrame style:UITableViewStylePlain];
        _dropDownListTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        _dropDownListTable.layer.cornerRadius = 6.0;
        _dropDownListTable.layer.borderWidth = 0.6;
        _dropDownListTable.layer.borderColor = [[UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1] CGColor];
        _isOn = NO;
        
        _domains = [[NSArray arrayWithArray:domains] retain];
        
        _manager = [[EmailTextFieldManager alloc] initWithEmailTextField:self];
        _dropDownListTable.delegate = _manager;
        _dropDownListTable.dataSource = _manager;
        self.delegate = _manager;
        
        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
        [center addObserver:_manager selector:@selector(textFieldValueChanged:) name:UITextFieldTextDidChangeNotification object:self];
    }
    return self;
}

- (BOOL)resignFirstResponder
{
    [self hideDropDownList];
    return [super resignFirstResponder];
}

- (BOOL)isDropDownListOn
{
    return _isOn;
}

- (void)showDropDownList
{
    if (![self isDropDownListOn]) {
        [self.superview addSubview:_dropDownListTable];
        _isOn = YES;
    }
    [self.superview bringSubviewToFront:_dropDownListTable];
}

- (void)hideDropDownList
{
    if ([self isDropDownListOn]) {
        [_dropDownListTable removeFromSuperview];
        _isOn = NO;
    }
}

- (void)freshDropDownList
{
    [_dropDownListTable reloadData];
    if ([_dropDownListTable numberOfRowsInSection:0] == 0) {
        [self hideDropDownList];
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:_manager];
    [_manager release];
    [_domains release];
    [_dropDownListTable release];
    [super dealloc];
}

@end
