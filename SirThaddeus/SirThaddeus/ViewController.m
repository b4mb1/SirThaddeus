//
//  ViewController.m
//  SirThaddeus
//
//  Created by Klaudyna Marciniak on 28.01.2016.
//  Copyright © 2016 Klaudyna Marciniak. All rights reserved.
//

#import "ViewController.h"
#import "customCell.h"

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

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 30)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, 162, 18)];
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(162, 5, 162, 18)];
    [label setFont:[UIFont boldSystemFontOfSize:14]];
    [label2 setFont:[UIFont boldSystemFontOfSize:14]];
    [label setText:@"WORD"];
    [label setTextAlignment: NSTextAlignmentCenter];
    [label2 setText:@"COUNT"];
    [view addSubview:label];
    [view addSubview:label2];
    [view setBackgroundColor:[UIColor colorWithRed:166/255.0 green:177/255.0 blue:186/255.0 alpha:1.0]];
    return view;
}

- (IBAction)submitNumber:(id)sender {
    [_submittedNumberTextField resignFirstResponder];
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
    static NSString *CellIdentifier = @"tableItem";
    customCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSString *word = [[frequencyTableNSArray objectAtIndex:indexPath.row] valueForKey: @"object"];
    NSString *count = [NSString stringWithFormat:@"%@", [[frequencyTableNSArray objectAtIndex:indexPath.row] objectForKey: @"count"]];
    cell.wordlabel.text = word;
    cell.countLabel.text = count;
    return cell;
}

@end
