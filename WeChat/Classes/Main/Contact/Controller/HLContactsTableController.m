//
//  HLContactsTableController.m
//  WeChat
//
//  Created by 韩露露 on 2016/10/16.
//  Copyright © 2016年 HLL. All rights reserved.
//

#import "HLContactsTableController.h"

@interface HLContactsTableController () <NSFetchedResultsControllerDelegate>
@property (strong, nonatomic) NSFetchedResultsController *resultsController;
@end

@implementation HLContactsTableController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.resultscontroller.fetchedObjects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"friendCell" forIndexPath:indexPath];
    XMPPUserCoreDataStorageObject *user = self.resultscontroller.fetchedObjects[indexPath.row];
    cell.textLabel.text = user.jid.user;
    switch ([user.sectionNum integerValue]) {
        case 0:
            cell.detailTextLabel.text = @"在线";
            cell.detailTextLabel.textColor = [UIColor orangeColor];
            break;
        case 1:
            cell.detailTextLabel.text = @"离开";
            cell.detailTextLabel.textColor = [UIColor lightGrayColor];
            break;
        case 2:
            cell.detailTextLabel.text = @"离线";
            cell.detailTextLabel.textColor = [UIColor lightGrayColor];
            break;
    }
    return cell;
}

- (NSFetchedResultsController *)resultscontroller {
    if (!_resultsController) {
        // 获取上下文
        NSManagedObjectContext *context = [HLXMPPTool sharedHLXMPPTool].rosterStorage.mainThreadManagedObjectContext;
        // 创建数据抓取请求
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"XMPPUserCoreDataStorageObject"];
        // 指定过滤条件
        NSString *user = [NSString stringWithFormat:@"%@@%@", [HLUserInfo sharedHLUserInfo].userName, [HLXMPPTool sharedHLXMPPTool].domainName];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"streamBareJidStr == %@", user];
        request.predicate = predicate;
        // 指定结果排序
        NSSortDescriptor *sortDesc = [NSSortDescriptor sortDescriptorWithKey:@"jidStr" ascending:YES];
        request.sortDescriptors = @[sortDesc];
        
        _resultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
        _resultsController.delegate = self;
        // 执行查询
        NSError *error = nil;
        if (![_resultsController performFetch:&error]) {
            HLLog(@"好友数据加载失败:%@", error.localizedDescription);
        }
    }
    return _resultsController;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        XMPPUserCoreDataStorageObject *user = self.resultscontroller.fetchedObjects[indexPath.row];
        [[HLXMPPTool sharedHLXMPPTool].roster removeUser:user.jid];
    }
}

@end
