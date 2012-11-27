//
//  RecognitionAnalyzer.cpp
//  SF_Project6
//
//  Created by 김정호 on 12. 11. 28..
//  Copyright (c) 2012년 frf1226@nate.com. All rights reserved.
//

#include "RecognitionAnalyzer.h"
#include "RootViewController.h"
#include "cocos2d.h"

void RecognitionAnalyzer::startRecognition()
{
    [RootViewController startRecognition];
}

void RecognitionAnalyzer::endRecognition()
{
    [RootViewController endRecognition];
}

RESPONSE_TYPE RecognitionAnalyzer::getResponseFromView()
{
    static char prevResponse[256] = "";
    char* response = [RootViewController getResponse];
    
    if( strcmp(prevResponse, response) == 0 )
        return RESPONSE_NONE;
    
    strcpy(prevResponse, response);
    
    //NSLog(@"[%s]",response);
    cocos2d::CCLog("RecognitionAnalyzer::getResponseFromView : %s", response);
    
    if( strcmp(response, "미사일" ) == 0 )
    {
        return RESPONSE_MISSILE2;
    }
    else if( strcmp(response, "유도탄" ) == 0 )
    {
        return RESPONSE_MISSILE3;
    }
//    else if( strcmp(response, "박" ) == 0 )
//    {
//        return RESPONSE_MISSILE3;
//    }
    else if( strcmp(response, "회복" ) == 0 )
    {
        return RESPONSE_MEDICINE;
    }
    else
    {
        return RESPONSE_MISSILE1;
    }
}