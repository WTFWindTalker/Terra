//
//  FaceDecode.h
//  HospitalFaceAI
//
//  Created by song on 2019/9/24.
//  Copyright © 2019 song. All rights reserved.
//

//获取人脸点位
int getDetection(float* cls, float* bbox, int input_w, int input_h, float score, float* faceBox);
