//
//  RecognitionAnalyzer.h
//  SF_Project6
//
//  Created by 김정호 on 12. 11. 28..
//  Copyright (c) 2012년 frf1226@nate.com. All rights reserved.
//

#ifndef __SF_Project6__RecognitionAnalyzer__
#define __SF_Project6__RecognitionAnalyzer__

#include <iostream>
#include <cstring>

enum RESPONSE_TYPE {
    RESPONSE_NONE,
    RESPONSE_MISSILE,
    RESPONSE_TELEPORT,
    RESPONSE_DOUBLE,
    RESPONSE_MEDICINE,
    RESPONSE_PROCESSING,
    };

class RecognitionAnalyzer
{
public:
    static void             startRecognition();
    static void             endRecognition();
    static RESPONSE_TYPE    getResponseFromView();
};

#endif /* defined(__SF_Project6__RecognitionAnalyzer__) */
