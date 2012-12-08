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

static char prevResponse[256] = "";
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
    char* response = [RootViewController getResponse];
    
    if( strcmp(prevResponse, response) == 0 )
        return RESPONSE_NONE;
    
    strcpy(prevResponse, response);
    
    if( strcmp(prevResponse, "start") == 0 )
        return RESPONSE_NONE;
    
    if( strcmp(prevResponse, "Processing") == 0 )
        return RESPONSE_PROCESSING;
    
    //NSLog(@"[%s]",response);
    cocos2d::CCLog("RecognitionAnalyzer::getResponseFromView : %s", response);
    
    if( strcmp(response, "미사일" ) == 0 )
    {
        return RESPONSE_DOUBLE;
    }
    else if( strcmp(response, "치료" ) == 0 )
    {
        return RESPONSE_MEDICINE;
    }
    else
    {
        return RESPONSE_MISSILE;
    }
}