#ifndef SF_Project6_SF_Scene_h
#define SF_Project6_SF_Scene_h
#include "cocos2d.h"
#include "SF_Aircraft.h"
#include "SF_Missile.h"
#include "SF_Item.h"
#include "SF_Shield_Item.h"
#include <math.h>

#define MAX_SHOOT_POWER 40

class SF_Scene: public cocos2d::CCLayer
{
public:
	// Here's a difference. Method 'init' in cocos2d-x returns bool, instead of returning 'id' in cocos2d-iphone
	virtual bool init();  
    
	// there's no 'id' in cpp, so we recommand to return the exactly class pointer
	static cocos2d::CCScene* scene();
	
	// a selector callback
	virtual void menuShootCallback(CCObject* pSender);
    virtual void select1(CCObject* pSender);
    virtual void select2(CCObject* pSender);
    
    cocos2d::CCSprite* wait_backgroud;
    cocos2d::CCMenu* pMenu1;
    cocos2d::CCMenu* pMenu2;
    
	// implement the "static node()" method manually
	LAYER_NODE_FUNC(SF_Scene);
    
    void frame(float dt);
    cocos2d::CCSprite* pMiniMap;
    
    cocos2d::CCSprite* pFighter;
    cocos2d::CCSprite* pFighter_HPbar;
    SF_Aircraft Fighter;
    cocos2d::CCSprite* pEnemy;
    cocos2d::CCSprite* pEnemy_HPbar;
    SF_Aircraft Enemy;
    
    cocos2d::CCLabelTTF *pLabel;
    cocos2d::CCLabelTTF *pTimer;
    cocos2d::CCSize winSize;
    cocos2d::CCSprite* pArrow;
    cocos2d::CCSprite* pPowergauge;
    cocos2d::CCSprite* pCheckbar;
    cocos2d::CCSprite* pGreendot;
    cocos2d::CCSprite* pReddot;
    cocos2d::CCSprite* pYellowdot;
    
    int player_num;
    int present_turn;
    int Layer_operator;
    int voice_type;
    double target_angle; //360도법, 터치에 의해 생성된 목표가 되는 각도
    
    //미사일 관련
    cocos2d::CCSprite* pMissile;
    SF_Missile Missile;
    bool check_shoot;
    bool check_END;
    
    virtual void didAccelerate(cocos2d::CCAcceleration* pAccelerationValue);
    void setting_scene();
    
    //파워게이지
    bool Powerbar_Direction;
    void Move_Powerbar();
    double Get_Powerposition();//파워를 계산해줌
    //미니맵
    void MiniMap_dot();         //미니맵의 포인트를 조정해줌
    //프레임수를 카운팅함
    float count_frame;
    //체력바
    void Draw_HPbar();
    void Write_Time();
    void Check_hit();
    void Game_END();
    
    //아이템 관
    cocos2d::CCSprite* pItem_Heal;
    cocos2d::CCSprite* pItem_double;
    cocos2d::CCSprite* pItem_teleport;
    SF_Shield_Item Item_Heal;
    
    //터치터치
    void registerWithTouchDispatcher();
    void ccTouchMoved(cocos2d::CCTouch* touch, UIEvent* event );
    bool ccTouchBegan(cocos2d::CCTouch *pTouch, cocos2d::CCEvent *pEvent);
    void ccTouchEnded(cocos2d::CCTouch *pTouch, cocos2d::CCEvent *pEvent);
    
    //매 프레임 각도를 타겟에 맞추어 바꿔줄 함수
    void Move_angle();
    
private:
    float prev_elapsedTime;
};

#endif
