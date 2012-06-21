//
//  IGA01TableViewCell.m
//  IGT001
//
//  Created by 鹏 李 on 12-4-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "IGA01TableViewCell.h"

#pragma mark -
#pragma mark RecipeTableViewCell implementation

@implementation IGA01TableViewCell

@synthesize travlTpyeiImageView;
@synthesize startTimeLabel;
@synthesize desadrLabel;
@synthesize overLabel;
@synthesize clockImageView;
@synthesize travlDetailLabel;
@synthesize hotelLabel;

#define STARTIME_SIZE       14.0
#define OVER_SIZE           16.0
#define DESADR_SIZE         22.0
#define TRAVL_TYPE_SIZE     40.0
#define TRAVL_DETAIL_SIZE   14.0
#define HOTEL_SIZE          14.0

#pragma mark -
#pragma mark Initialization

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
	if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        travlTpyeiImageView = [IGBusinessUtil getTrvalTypeImageForType:TrvalTypeWalking];
        travlTpyeiImageView.font = [UIFont fontWithName:@"AppleColorEmoji" size:TRAVL_TYPE_SIZE];
        travlTpyeiImageView.frame = CGRectMake(A01CellTravlTypeX, A01CellTravlTypeY, A01CellTravlTypeW, A01CellTravlTypeH);
        [self.contentView addSubview:travlTpyeiImageView];

        startTimeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [startTimeLabel setFont:[UIFont systemFontOfSize:STARTIME_SIZE]];
        [startTimeLabel setTextColor:[UIColor darkGrayColor]];
        [startTimeLabel setHighlightedTextColor:[UIColor whiteColor]];
        [startTimeLabel setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:startTimeLabel];

        overLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        overLabel.textAlignment = UITextAlignmentCenter;
        [overLabel setFont:[UIFont systemFontOfSize:OVER_SIZE]];
        [overLabel setTextColor:[UIColor blackColor]];
        [overLabel setHighlightedTextColor:[UIColor whiteColor]];
		overLabel.lineBreakMode = UILineBreakModeTailTruncation;
        [overLabel setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:overLabel];

        desadrLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [desadrLabel setFont:[UIFont boldSystemFontOfSize:DESADR_SIZE]];
        [desadrLabel setTextColor:[UIColor blackColor]];
        [desadrLabel setHighlightedTextColor:[UIColor whiteColor]];
        [desadrLabel setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:desadrLabel];
        
//        clockImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
//		clockImageView.contentMode = UIViewContentModeScaleAspectFit;
        clockImageView = [[IGCheckBox alloc] initWithFrame:CGRectZero withImageName:@"alert" isChecked:NO target:nil selector:nil];
        [self.contentView addSubview:clockImageView];
        
        travlDetailLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        travlDetailLabel.textAlignment = UITextAlignmentCenter;
        [travlDetailLabel setFont:[UIFont boldSystemFontOfSize:TRAVL_DETAIL_SIZE]];
        [travlDetailLabel setTextColor:[UIColor darkGrayColor]];
        [travlDetailLabel setHighlightedTextColor:[UIColor whiteColor]];
        [travlDetailLabel setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:travlDetailLabel];
        
        hotelLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [hotelLabel setFont:[UIFont boldSystemFontOfSize:HOTEL_SIZE]];
        [hotelLabel setTextColor:[UIColor darkGrayColor]];
        [hotelLabel setHighlightedTextColor:[UIColor whiteColor]];
        [hotelLabel setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:hotelLabel];
    }

    return self;
}

-(void)updateCell:(IGA01TableViewCell*) cell :(Plan*) newPlan{
    
    [cell.travlTpyeiImageView setText: [IGBusinessUtil getTrvalTypeImageNameForType:[newPlan.travltype intValue]]];
    cell.desadrLabel.text = newPlan.desadr;
    cell.overLabel.text = [IGBusinessUtil getCheckedRate:newPlan];
    //设定时间格式,这里可以设置成自己需要的格式
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:NSLocalizedString(@"yyyy年MM月dd日 HH:mm", @"yyyy年MM月dd日 HH:mm 日期格式")];
    cell.startTimeLabel.text= [dateFormatter stringFromDate:newPlan.starttime];
    cell.travlDetailLabel.text = newPlan.travldetail;
    cell.hotelLabel.text = newPlan.hotelname;
    if ([newPlan.isalarm isEqualToNumber:[NSNumber numberWithBool:YES]]) {
        [cell.clockImageView check];
    }else{
        [cell.clockImageView unCheck];
    }
}

#pragma mark -
#pragma mark Laying out subviews

/*
 To save space, the prep time label disappears during editing.
 */
- (void)layoutSubviews {
    [super layoutSubviews];
	
//    [travlTpyeiImageView setFrame:[self _travlTpyeiImageViewFrame]];
    [desadrLabel setFrame:[self _desadrLabelFrame]];
    [overLabel setFrame:[self _overLabelFrame]];
    [startTimeLabel setFrame:[self _startTimeLabelFrame]];
    [clockImageView setFrame:[self _clockImageViewFrame]];
    [travlDetailLabel setFrame:[self _travlDetailLabelFrame]];
    [hotelLabel setFrame:[self _hotelLabelFrame]];
    if (self.editing) {
        overLabel.alpha = 0.0;
        clockImageView.alpha = 0.0;
    } else {
        overLabel.alpha = 1.0;
        clockImageView.alpha = 1.0;
    }
}

/*
 Return the frame of the various subviews -- these are dependent on the editing state of the cell.
 */
//- (CGRect)_travlTpyeiImageViewFrame {
//    return CGRectMake(CONTENT_MARGIN, IMAGE_SIZE_MARGIN, IMAGE_SIZE, IMAGE_SIZE);
//}

#define A01

- (CGRect)_startTimeLabelFrame {
    return CGRectMake(A01CellStartTimeX, A01CellStartTimeY, A01CellStartTimeW, A01CellStartTimeH);
}

- (CGRect)_desadrLabelFrame {
    return CGRectMake(A01CellDesadrX, A01CellDesadrY, A01CellDesadrW, A01CellDesadrH);
}

- (CGRect)_overLabelFrame {
    return CGRectMake(A01CellOverX, A01CellOverY, A01CellOverW, A01CellOverH);
}

- (CGRect)_clockImageViewFrame {
    return CGRectMake(A01CellClockImageX, A01CellClockImageY, A01CellClockImageW, A01CellClockImageH);
}
- (CGRect)_travlDetailLabelFrame {
    return CGRectMake(A01CellTravldetailX, A01CellTravldetailY, A01CellTravldetailW, A01CellTravldetailH);
}

- (CGRect)_hotelLabelFrame {
    return CGRectMake(A01CellHotelX, A01CellHotelY, A01CellHotelW, A01CellHotelH);
}
@end
