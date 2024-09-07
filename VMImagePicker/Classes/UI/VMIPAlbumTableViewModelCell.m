//
//  VMIPAlbumTableViewModelCell.m
//  VMImagePicker
//
//  Created by ItghostFan on 2024/8/21.
//

#import "VMIPAlbumTableViewModelCell.h"
#import "VMIPAlbumTableCellViewModel.h"
#import "VMIPAlbumCellViewModel.h"
#import "VMIPAlbumTableController.h"
#import "VMImagePickerStyle.h"

#import <Masonry/Masonry.h>
#import <ViewModel/TableViewModel.h>

@interface VMIPAlbumTableViewModelCell ()
@property (weak, nonatomic) VMImagePickerStyle *vmipStyle;
@property (weak, nonatomic) UILabel *nameLabel;
@end

@implementation VMIPAlbumTableViewModelCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setViewModel:(VMIPAlbumTableCellViewModel *)viewModel {
    BOOL same = self.viewModel == viewModel;
    [super setViewModel:viewModel];
    if (same) {
        // 防止这里不必要的UI刷新。
        return;
    }
    self.nameLabel.text = ((VMIPAlbumCellViewModel *)viewModel).name;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.nameLabel.textColor = [self.vmipStyle colorWithCellThemeColors:self.vmipStyle.albumCellNameColors selected:selected];
    self.nameLabel.font = [self.vmipStyle fontWithCellFonts:self.vmipStyle.albumCellNameFonts selected:selected];
    self.contentView.backgroundColor = [self.vmipStyle colorWithCellThemeColors:self.vmipStyle.albumCellBkgColors selected:selected];
}

#pragma mark - Public

#pragma mark - Actions

#pragma mark - Private

#pragma mark - Getter

- (VMImagePickerStyle *)vmipStyle {
    if (!_vmipStyle) {
        VMIPAlbumTableController *controller = (VMIPAlbumTableController *)self;
        do {
            controller = controller.nextResponder;
        } while ([controller isKindOfClass:UIView.class]);
        _vmipStyle = controller.style;
    }
    return _vmipStyle;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        UILabel *nameLabel = UILabel.new;
        _nameLabel = nameLabel;
        _nameLabel.textColor = [self.vmipStyle colorWithCellThemeColors:self.vmipStyle.albumCellNameColors selected:NO];
        _nameLabel.font = [self.vmipStyle fontWithCellFonts:self.vmipStyle.albumCellNameFonts selected:NO];
        [self.contentView addSubview:_nameLabel];
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(0.0f, 6.0f, 0.0f, 0.0f));
        }];
    }
    return _nameLabel;
}

#pragma mark - TableViewModelCell

+ (CGFloat)heightForWidth:(CGFloat *)width viewModel:(VMIPAlbumTableCellViewModel *)viewModel {
    VMIPAlbumTableController *controller = (VMIPAlbumTableController *)viewModel.tableSectionViewModel.tableViewModel.tableView;
    do {
        controller = controller.nextResponder;
    } while ([controller isKindOfClass:UIView.class]);
    return controller.style.albumCellHeight;
}

@end
