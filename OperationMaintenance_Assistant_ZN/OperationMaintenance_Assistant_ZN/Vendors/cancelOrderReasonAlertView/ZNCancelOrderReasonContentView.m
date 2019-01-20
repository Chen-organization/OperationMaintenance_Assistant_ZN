//
//  ZNCancelOrderReasonContentView.m
//  OperationMaintenance_Assistant_ZN
//
//  Created by Chen on 2019/1/20.
//  Copyright © 2019年 Chen. All rights reserved.
//

#import "ZNCancelOrderReasonContentView.h"
#import "ZNCancelOrderReasonCell.h"

@interface ZNCancelOrderReasonContentView ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIButton *sureBtn;

@property (weak, nonatomic) IBOutlet UITableView *tableView;



@end

@implementation ZNCancelOrderReasonContentView



- (void)awakeFromNib{
    
    [super awakeFromNib];
    
//    [self.sureBtn setBackgroundImage:[self imageWithColor:[UIColor colorWithRed:210/255.0 green:210/255.0 blue:210/255.0 alpha:1.0]] forState:UIControlStateHighlighted];
//    [self.cancelBtn setBackgroundImage:[self imageWithColor:[UIColor colorWithRed:210/255.0 green:210/255.0 blue:210/255.0 alpha:1.0]] forState:UIControlStateHighlighted];
    
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ZNCancelOrderReasonCell" bundle:nil] forCellReuseIdentifier:ZNCancelOrderReasonCell_id];
    
}

- (IBAction)cancelBtnClick:(UIButton *)sender {
    
    if (self.SureCompletion) {
        
        self.SureCompletion(NO, 0);
    }
}

- (IBAction)sureBtnClick:(UIButton *)sender {
    
    if (self.SureCompletion) {
        
        self.SureCompletion(YES, self.selectedIndex);
    }
}

- (UIImage *)imageWithColor:(UIColor *)color

{
    
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    
    UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    
    CGContextFillRect(context, rect);
    
    
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    
    
    return image;
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.array.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ZNCancelOrderReasonCell *cell = [tableView dequeueReusableCellWithIdentifier:ZNCancelOrderReasonCell_id];
    
    cell.contentL.text = self.array[indexPath.row];
    
    if (indexPath.row == self.selectedIndex) {
        
        cell.selectImg.image = [UIImage imageNamed:@"点击"];
    }else{
        
        cell.selectImg.image = [UIImage imageNamed:@"未点击"];

    }
    

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 53;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    self.selectedIndex = (int)indexPath.row;
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.tableView reloadData];
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
