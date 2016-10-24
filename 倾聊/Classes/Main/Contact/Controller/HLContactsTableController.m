//
//  HLContactsTableController.m
//  倾聊
//
//  Created by 韩露露 on 2016/10/16.
//  Copyright © 2016年 HLL. All rights reserved.
//

#import "HLContactsTableController.h"
#import "HLChatViewController.h"

@interface HLContactsTableController () <NSFetchedResultsControllerDelegate>
@property (strong, nonatomic) NSFetchedResultsController *resultsController;
@end

@implementation HLContactsTableController

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.resultscontroller.fetchedObjects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"friendCell" forIndexPath:indexPath];
    UIImageView *icon = [cell viewWithTag:1];
    UILabel *name = [cell viewWithTag:2];
    UILabel *status = [cell viewWithTag:3];
    XMPPUserCoreDataStorageObject *user = self.resultscontroller.fetchedObjects[indexPath.row];
    name.text = user.jid.user;
    if (user.photo) {
        icon.image = user.photo;
    } else {
        NSData *photo = [[HLXMPPTool sharedHLXMPPTool].vCarAvatar photoDataForJID:user.jid];
        if (photo) {
            icon.image = [UIImage imageWithData:photo];
        } else {
            icon.image = [UIImage imageNamed:@"fts_default_headimage"];
        }
    }
    
    switch ([user.sectionNum integerValue]) {
        case 0:
            status.text = @"在线";
            status.textColor = [UIColor orangeColor];
            break;
        case 1:
            status.text = @"离开";
            status.textColor = [UIColor lightGrayColor];
            break;
        case 2:
            status.text = @"离线";
            status.textColor = [UIColor lightGrayColor];
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

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView reloadData];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        XMPPUserCoreDataStorageObject *user = self.resultscontroller.fetchedObjects[indexPath.row];
        [[HLXMPPTool sharedHLXMPPTool].roster removeUser:user.jid];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    XMPPUserCoreDataStorageObject *user = self.resultscontroller.fetchedObjects[indexPath.row];
    [self performSegueWithIdentifier:@"chatSegue" sender:user.jid];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    id dest = segue.destinationViewController;
    if ([dest isMemberOfClass:HLChatViewController.class]) {
        HLChatViewController *chatVC = (HLChatViewController *)dest;
        chatVC.jid = sender;
    }
}

@end
