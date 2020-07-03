//
//  OLDViewController.m
//  OpenGLDemo
//
//  Created by 罗海雄 on 2020/7/2.
//  Copyright © 2020 luohaixiong. All rights reserved.
//

#import "OLDViewController.h"

@interface DemoModel : NSObject

///
@property(nonatomic, strong) NSString *title;

///
@property(nonatomic, strong) Class cls;

+ (instancetype)modelWithTitle:(NSString*) title cls:(Class) cls;

@end

@implementation DemoModel

+ (instancetype)modelWithTitle:(NSString *)title cls:(Class)cls
{
    DemoModel *model = [DemoModel new];
    model.title = title;
    model.cls = cls;
    
    return model;
}

@end

@interface OLDViewController ()

@property(nonatomic, strong) NSArray<DemoModel*> *models;

@end

@implementation OLDViewController

- (instancetype)init
{
    return [self initWithStyle:UITableViewStyleGrouped];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.
    self.navigationItem.title = @"OpenGLDemo";
    self.models = @[[DemoModel modelWithTitle:@"图形" cls:NSClassFromString(@"OLDGraphicsViewController")]];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.models.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.textLabel.text = self.models[indexPath.row].title;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UIViewController *vc = self.models[indexPath.row].cls.new;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
