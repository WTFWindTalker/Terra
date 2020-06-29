//
//  ObjcTool.m
//  HospitalFaceAI
//
//  Created by song on 2019/9/24.
//  Copyright © 2019 song. All rights reserved.
//

#import "ObjcTool.h"
#import "FaceDecode.h"

@implementation ObjcTool
- (NSArray *)getDetectResult:(float*)cls
                        bbox:(float*)bbbox
                     input_w:(int)input_w
                     input_h:(int)input_h
                       score:(float)score
                     faceBox:(float*)faceBox {
    
    float *faceData = (float *)malloc(4*sizeof(float));
    int num_r = 4;
    getDetection(cls, bbbox, input_w, input_h, score, faceBox);
    return [NSArray array];
}
@end
