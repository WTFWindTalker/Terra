//
//  FaceDecode.m
//  HospitalFaceAI
//
//  Created by song on 2019/9/24.
//  Copyright © 2019 song. All rights reserved.
//

#include <stdlib.h>
#include <math.h>
#include <set>
#include <vector>
#include <algorithm>
#include <assert.h>
#include <queue>
#include <set>
#include <limits>

#include <iostream>

//人脸
typedef struct Bbox{
    std::vector<int> loc;
    float score;
}Bbox;

typedef struct Anchors_Cfg{
    std::vector<int> strides;
    std::vector<std::vector<int>> scales;
    int baseSize;
    
}anchors_cfg;

anchors_cfg a_cfg = {{32,16,8}, {{32,16},{8,4},{2,1}}, 16};


int genAnchors(anchors_cfg a_cfg, int input_w, int input_h, std::vector<std::vector<int> >& anchors){
    int fpn_c = a_cfg.strides.size();
    std::vector<int> baseAnchor = {0, 0, 15, 15};
    for(int i=0; i<fpn_c; i++){
        int stride = a_cfg.strides[i];
        std::vector<int> scales = a_cfg.scales[i];
        int baseSize = a_cfg.baseSize;
        
        int w_ = ceil(static_cast<float>(input_w) / stride);
        int h_ = ceil(static_cast<float>(input_h) / stride);
        std::vector<int> anchorSize;
        for(int s:scales){
            anchorSize.push_back(s*baseSize);
        }
        
        for(int h=0; h<h_; h++){
            for(int w=0; w<w_; w++){
                for(int as:anchorSize){
                    int xmin = baseAnchor[0] + stride*w - (as - 16)/2;
                    int ymin = baseAnchor[1] + stride*h - (as - 16)/2;
                    int xmax = baseAnchor[2] + stride*w + (as - 16)/2;
                    int ymax = baseAnchor[3] + stride*h + (as - 16)/2;
                    anchors.push_back({xmin,ymin,xmax,ymax});
                }
            }
        }
    }
    return 0;
    
    
}


int bbox_rgs(float* bbox, float* cls, int num_anchors, std::vector<std::vector<int> >& anchors, std::vector<Bbox>& bbox_, int input_w, int input_h, float score ){
    for(int i=0; i<num_anchors; i++){
        float s = cls[i];
        if(s > score){
            float weights = static_cast<float>(anchors[i][2] - anchors[i][0]);
            float heights = static_cast<float>(anchors[i][3] - anchors[i][1]);
            float ctr_x = static_cast<float>(anchors[i][0]) + 0.5*(weights - 1.0);
            float ctr_y = static_cast<float>(anchors[i][1]) + 0.5*(heights - 1.0);
            
            float dx = bbox[i*4 + 0];
            float dy = bbox[i*4 + 1];
            float dw = bbox[i*4 + 2];
            float dh = bbox[i*4 + 3];
            
            dx = dx*weights + ctr_x;
            dy = dy*heights + ctr_y;
            dw = exp(dw) * weights;
            dh = exp(dh) * heights;
            
            int xmin = static_cast<int>(dx - 0.5*(dw - 1.0)) > 0 ? static_cast<int>(dx - 0.5*(dw - 1.0)) : 0;
            int ymin = static_cast<int>(dy - 0.5*(dh - 1.0)) > 0 ? static_cast<int>(dy - 0.5*(dh - 1.0)) : 0;
            int xmax = static_cast<int>(dx + 0.5*(dw - 1.0)) < input_w ? static_cast<int>(dx + 0.5*(dw - 1.0)) : input_w;
            int ymax = static_cast<int>(dy + 0.5*(dh - 1.0)) < input_h ? static_cast<int>(dy + 0.5*(dh - 1.0)) : input_h;
            Bbox bbox = {{xmin, ymin, xmax, ymax}, s};
            bbox_.push_back(bbox);
            
        }
        
    }
    if(bbox_.size() == 0){
        return 1;
    }
    return 0;
    
}

//int lm_rgs(float* lm, int num_anchors, )

bool sort_score(Bbox a, Bbox b){
    return (a.score > b.score);
}

float iou(Bbox a, Bbox b){
    int x1 = std::max(a.loc[0], b.loc[0]);
    int y1 = std::max(a.loc[1], b.loc[1]);
    int x2 = std::min(a.loc[2], b.loc[2]);
    int y2 = std::min(a.loc[3], b.loc[3]);
    int w = std::max(0, x2 - x1 + 1);
    int h = std::max(0, y2 - y1 + 1);
    int area_a = (a.loc[2]-a.loc[0]+1)*(a.loc[3]-a.loc[1]+1);
    int area_b = (b.loc[2]-b.loc[0]+1)*(b.loc[3]-b.loc[1]+1);
    
    float over_area = w*h;
    float iou = over_area / (area_a + area_b - over_area);
    
    return iou;
    
    
}




int nms(std::vector<Bbox>& bbox_, float nms_th, std::vector<Bbox>& res){
    if(bbox_.empty()){
        return 1;
    }
    sort(bbox_.begin(), bbox_.end(), sort_score);
    while(bbox_.size()>0){
        res.push_back(bbox_[0]);
        auto iter = bbox_.begin();
        for(int i=0; i<bbox_.size()-1; i++){
            float iou_value = iou(bbox_[0], bbox_[i+1]);
            if(iou_value > nms_th ){
                bbox_.erase(iter+i+1);
                i--;
            }
        }
        bbox_.erase(iter);
        
    }
    return 0;
}

Bbox filterFace(std::vector<Bbox> faces){
    int max_id = 0;
    int max_area = 0;
    for(int i=0; i<faces.size(); i++){
        int w = faces[i].loc[2] - faces[i].loc[0] + 1;
        int h = faces[i].loc[3] - faces[i].loc[1] + 1;
        int area = w*h;
        if(area > max_area){
            max_area = area;
            max_id = i;
        }
    }
    return faces[max_id];
}



extern "C"
int getDetection(float* cls, float* bbox, int input_w, int input_h, float score, float* faceBox){
    printf("==========OUTPUT1===========");
    std::vector<std::vector<int> > anchors;
    for (int index = 0; index < 1050; index++) {
//        printf("index:%d=%lf \n",index,cls[index]);
        if (cls[index]>=0.6) {
            printf("index:%d=%lf \n",index,cls[index]);
        }
    }
    printf("\n");
//    printf("==========OUTPUT2===========");
//    for (int index = 0; index < 4200; index++) {
//        printf("index:%d=%lf \n",index,bbox[index]);
//    }
    int rst = genAnchors(a_cfg, input_w, input_h, anchors);
    
    int num_anchors = anchors.size();
    std::vector<Bbox> bbox_;
    std::vector<Bbox> res_;
    rst = bbox_rgs(bbox, cls, num_anchors, anchors, bbox_, input_w, input_h, score);
    if(rst!=0){
        return 1;
    }
    
    rst = nms(bbox_, 0.4, res_);
    Bbox resFace = filterFace(res_);
    
    faceBox[0] = resFace.loc[0];
    faceBox[1] = resFace.loc[1];
    faceBox[2] = resFace.loc[2];
    faceBox[3] = resFace.loc[3];
    
    
    return 0;
    
}
