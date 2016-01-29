//
//  ViewController.m
//  SirThaddeus
//
//  Created by Klaudyna Marciniak on 28.01.2016.
//  Copyright © 2016 Klaudyna Marciniak. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextField *submittedNumberTextField;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (weak, nonatomic) IBOutlet UITableView *frequencyTable;

@end

@implementation ViewController

 NSArray *frequencyTableNSArray;

- (void)viewDidLoad {
    [super viewDidLoad];
    frequencyTableNSArray = [self createFrequencyTable];
}

- (NSArray*)createFrequencyTable {
    NSCountedSet *countedSet = [NSCountedSet new];
    NSMutableArray *dictArray = [NSMutableArray array];
    NSError *error = nil;
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"pTadek" ofType:@"txt"];
    NSString *text = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
    
    [text enumerateSubstringsInRange:NSMakeRange(0, [text length])
        options:NSStringEnumerationByWords | NSStringEnumerationLocalized
        usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
        [countedSet addObject:[substring lowercaseString]];
        }];
    
    
    [countedSet enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
        [dictArray addObject:@{@"object": obj,
                               @"count": @([countedSet countForObject:obj])}];
    }];
    
    NSSortDescriptor * countDescriptor = [[NSSortDescriptor alloc] initWithKey:@"count" ascending:NO];
    NSArray * sortDescriptors = [NSArray arrayWithObject:countDescriptor];
    NSArray *sortedFrequencyArray = [dictArray sortedArrayUsingDescriptors:sortDescriptors];
    return sortedFrequencyArray;
}

- (IBAction)submitNumber:(id)sender {
    [self.frequencyTable reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSString *submittedNumber = [_submittedNumberTextField text];
    int intValue = ([submittedNumber respondsToSelector:@selector(intValue)]) ? [submittedNumber intValue] : 0;
    return intValue;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *tableIdentifier = @"tableItem";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableIdentifier];
    }
    cell.textLabel.text = [[frequencyTableNSArray objectAtIndex:indexPath.row] valueForKey: @"object"];
    return cell;
}

@end
