//
//  VMIPAlbumTableViewModelCell.m
//  VMImagePicker
//
//  Created by ItghostFan on 2024/8/21.
//

#import "VMIPAlbumTableViewModelCell.h"
#import "VMIPAlbumTableCellViewModel.h"
#import "VMIPAlbumCellViewModel.h"

#import <Masonry/Masonry.h>

@interface VMIPAlbumTableViewModelCell ()
@property (weak, nonatomic) UILabel *nameLabel;
@end

@implementation VMIPAlbumTableViewModelCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
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

#pragma mark - Public

#pragma mark - Actions

#pragma mark - Private

#pragma mark - Getter

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        UILabel *nameLabel = UILabel.new;
        _nameLabel = nameLabel;
        _nameLabel.textColor = UIColor.redColor;
        _nameLabel.font = [UIFont systemFontOfSize:30.0f];
        [self.contentView addSubview:_nameLabel];
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsZero);
        }];
    }
    return _nameLabel;
}

#pragma mark - TableViewModelCell

+ (CGFloat)heightForWidth:(CGFloat *)width viewModel:(VMIPAlbumTableCellViewModel *)viewModel {
    return 50.0f;
}

@end
