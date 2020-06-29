//
//  ObjcTool.h
//  HospitalFaceAI
//
//  Created by song on 2019/9/24.
//  Copyright © 2019 song. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ObjcTool : NSObject
- (NSArray *)getDetectResult:(float*)cls
                        bbox:(float*)bbbox
                     input_w:(int)input_w
                     input_h:(int)input_h
                       score:(float)score
                     faceBox:(float*)faceBox;
@end

NS_ASSUME_NONNULL_END
