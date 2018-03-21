

--/* 密码秘钥 */
SERVER_KEY = "l$`h.V,&";


--/*LAYER tag 值*/
MAIN_LAYER = 1000
DOWNLOAD_LAYER = 1001
LOGIN_LAYER = 1002
ABOUT_LAYER = 1003
ANSWER_LAYER = 1004
DAILY_REWARD_LAYER = 1005
HONOUR_LAYER = 1006
ACTIVITY_LAYER = 1007
PAY_LAYER = 1008
--/* scene tag*/
const int MAIN_SCENE = 100


--/* CODE*/
 CODE_REG_RE = 1001 --注册
 CODE_REG_RS = 1002 --注册返回

 CODE_LOGIN_RE = 1003 --登录
 CODE_LOGIN_RS = 1004 --登录返回
 CODE_LOGIN_FROM_CENTER_RE = 1005 --远程登录

 CODE_GAME_GET_COIN_RE = 1110--请求金币
 CODE_GAME_GET_COIN_RS = 1111--请求金币返回
 MSG_BET_SAMPLE_REQ = 1116--请求下注请求
 MSG_BET_SAMPLE_RSP = 1117--请求下注请求返回
 MSG_ODDS_SAMPLE_REQ = 1118--普通版请求跑马倍率
 MSG_ODDS_SAMPLE_RSP = 1119--普通版请求跑马倍率返回
 MSG_FRUIYS_DA_XIA_REQ = 1120--水果机赌大小
 MSG_FRUIYS_DA_XIA_RSP = 1121--水果机赌大小返回



--music
 BG_MUSIC = "mp3/bgm.mp3"
 BUTTON_EFFECT = "mp3tton.mp3"
 ANSWER_EFFECT = "mp3/click.mp3"
 WIN_EFFECT = "mp3/pass.mp3"
 FAILURE_EFFECT = "mp3/error.mp3"

--每日奖励
 dailyCoin[7]={100,150,150,200,200,300,800}
 passCoin = 3
 gzwxCoin = 50
 firsetShareCoin = 20
 delErrCoin = -30
 getOneAnswerCoin = -90
 passAdCoin = 50
 promptCoin = -1

 PayNum = 6
 PayCoinMap[PayNum] = {90, 280,750,1600,3800,8000}
 PayRmbMap[PayNum] = {2, 6 ,15,30,68,128}
