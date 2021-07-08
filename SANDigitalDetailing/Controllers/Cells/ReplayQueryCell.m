//
//  ReplayQueryCell.m
//  SANDigitalDetailing
//
//  Created by SANeForce.com on 01/11/18.
//  Copyright © 2018 SANeForce.com. All rights reserved.
//

#import "ReplayQueryCell.h"

@implementation ReplayQueryCell
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
-(void)awakeFromNib{
    [super awakeFromNib];
    
    self.tbQryReply.delegate = self;
    self.tbQryReply.dataSource = self;
    
}

/*-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
 
 TBSelectionBxCell* cell =[tableView dequeueReusableCellWithIdentifier:@"ReplayCell"];
    NSLog(@"%f=>%f",cell.frame.size.height,((cell.frame.size.height+cell.lOptText.frame.size.height)-70));
    return ((cell.frame.size.height+cell.lOptText.frame.size.height)-70);
}*/
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tblOptList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *optLst=self.tblOptList[indexPath.row];
    TBSelectionBxCell* cell =[tableView dequeueReusableCellWithIdentifier:@"ReplayCell" forIndexPath:indexPath];
    
    [cell.lOptText setNumberOfLines:0]; // for multiline label
    cell.lOptText.text = [optLst objectForKey:@"Msg"];
    cell.lOptVal.text = [optLst objectForKey:@"Msg"];
    [cell.lOptVal sizeToFit];
    [cell.lOptText sizeToFit];
    [cell.lOptText layoutIfNeeded];
    [cell.lOptVal layoutIfNeeded];
    [cell layoutIfNeeded];
    if([[optLst objectForKey:@"FrmQ"] isEqualToString:@"F"]){
        cell.lOptText.hidden=NO;
        cell.lOptVal.hidden=YES;
    }else{
        cell.lOptText.hidden=YES;
        cell.lOptVal.hidden=NO;
        //cell.lOptVal.frame=CGRectMake(cell.frame.size.width-cell.lOptVal.frame.size.width, 0, cell.lOptVal.frame.size.width, cell.lOptVal.frame.size.height);
        
    }
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
@end
