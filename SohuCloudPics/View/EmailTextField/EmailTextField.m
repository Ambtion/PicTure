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

static BOOL isInOrder(NSString *a, NSString *b)
{
    int a_len, b_len, i, j;
    a_len = a.length;
    b_len = b.length;
    for (i = 0, j = 0; i < a_len && j < b_len; ++i, ++j) {
        if ([a characterAtIndex:i] > [b characterAtIndex:j]) {
            return NO;
        } else if ([a characterAtIndex:i] < [b characterAtIndex:j]) {
            return YES;
        }
    }
    if (a_len > b_len) {
        return NO;
    }
    return YES;
}

static int compareNSString(const void *a, const void *b)
{
    NSString *sa = *((NSString **) a), *sb = *((NSString **) b);
    if ([sa isEqualToString:sb]) {
        return 0;
    }
    return isInOrder(sa, sb) ? -1 : 1;
}

static NSArray *sort(NSArray *array)
{
    int length = array.count;
    NSArray **arr = malloc(length * sizeof(NSArray *));
    for (int i = 0; i < length; ++i) {
        arr[i] = [array objectAtIndex:i];
    }
    qsort(arr, length, sizeof(NSArray *), compareNSString);
    NSArray *result = [NSArray arrayWithObjects:arr count:length];
    free(arr);
    return result;
}

static void check(NSArray **p_domains)
{
    NSArray *domains = *p_domains;
    BOOL isOK = YES;
    int length = domains.count;
    for (int i = 0; i < length - 1; ++i) {
        if (!isInOrder([domains objectAtIndex:i], [domains objectAtIndex:i + 1])) {
            isOK = NO;
            break;
        }
    }
    
    if (!isOK) {
        NSArray *sorted = sort(domains);
        [*p_domains release];
        *p_domains = [sorted retain]; 
    }
}

@implementation NSString (indexOfChar)
- (NSInteger)firstIndexOfChar:(unichar)c
{
    //    int i = self.length - 1;
    //    for (; i > -1 && [self characterAtIndex:i] != c; --i) {
    //        ;
    //    }
    //    return i;
    
    // For different strategies: lastIndexOfChar is above; firstIndexOfChar is below.
    
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
    NSRange emailDomainRange;
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
        emailDomainRange.location = 0;
        emailDomainRange.length = 0;
    }
    return self;
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
        emailDomainRange.location = 0;
        emailDomainRange.length = domains.count;
        [eTextField freshDropDownList];
        
    } else { // there is an @
        emailAccount = [[email substringToIndex:lastIndexOfAt] copy];
        NSString *emailDomain = [email substringFromIndex:lastIndexOfAt + 1];
        emailDomainRange = [self rangeOfDomain:emailDomain inArray:domains];
        [eTextField freshDropDownList];
    }
}

// private method used as a tool
// the time complexity of this solution must be O(log(n)), O(n) is not acceptable
- (NSRange)rangeOfDomain:(NSString *)domain inArray:(NSArray *)array
{
    NSRange result = {0, 0};
    int left = 0, right = array.count - 1;
    for (int i = 0; i < domain.length; ++i) {
        unichar c = [domain characterAtIndex:i];
        if (left == right) {
            NSString *s = (NSString *) [array objectAtIndex:left];
            if (s.length <= i || [s characterAtIndex:i] != c) {
                return result;
            } else {
                continue;
            }
        }
        
        // first, find the most left location of c, start will be the result
        int start = left, end = right;
        while (start < end) {
            int middle = (start + end) / 2;
            if (((NSString *) [array objectAtIndex:middle]).length <= i) {
                start = middle + 1;
                continue;
            }
            unichar middleChar = [[array objectAtIndex:middle] characterAtIndex:i];
            if (middleChar < c) {
                start = middle + 1;
            } else if (middleChar > c) {
                end = middle - 1;
            } else {
                if (middle == left) {
                    start = left;
                    break;
                } else if ([[array objectAtIndex:(middle - 1)] characterAtIndex:i] == c) {
                    end = middle - 1;
                } else {
                    start = middle;
                    break;
                }
            }
        }
        if ([[array objectAtIndex:start] characterAtIndex:i] == c) {
            left = start;
        } else {
            return result;
        }
        
        // then, find the most right location of c, end will be the result
        start = left, end = right;
        while (start < end) {
            int middle = (start + end) / 2;
            if (((NSString *) [array objectAtIndex:middle]).length <= i) {
                start = middle + 1;
                continue;
            }
            unichar middleChar = [[array objectAtIndex:middle] characterAtIndex:i];
            if (middleChar > c) {
                end = middle - 1;
            } else if (middleChar < c) {
                start = middle + 1;
            } else {
                if (middle == right) {
                    end = right;
                    break;
                } else if ([[array objectAtIndex:(middle + 1)] characterAtIndex:i] == c) {
                    start = middle + 1;
                } else {
                    end = middle;
                    break;
                }
            }
        }
        if ([[array objectAtIndex:start] characterAtIndex:i] == c) {
            right = end;
        } else {
            return result;
        }
    }
    result.location = left;
    result.length = right - left + 1;
    return result;
}

#pragma mark methods from UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 24.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    eTextField.text = [NSString stringWithFormat:@"%@@%@", emailAccount, [domains objectAtIndex:(emailDomainRange.location + indexPath.row)]];
    [eTextField resignFirstResponder];
}

#pragma mark methods from UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return emailDomainRange.length;
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
    NSString *text = [NSString stringWithFormat:@"%@@%@", emailAccount, [domains objectAtIndex:(emailDomainRange.location + indexPath.row)]];
    
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
        
        _domains = [domains retain];
        check(&_domains);
        
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
    [_dropDownListTable release];
    [[NSNotificationCenter defaultCenter] removeObserver:_manager];
    [_manager release];
    [_domains release];
    [super dealloc];
}

@end
