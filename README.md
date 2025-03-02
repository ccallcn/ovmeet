OvMeet2 H5轻会议、视频会议视频教学平台</br>
老项目基于adobe的flash开发，由于adobe已经不再维护，后继启用新技术开发了全新的ovmeet-轻会议产品线,老版本不再维护</br>
新一代Web、H5视频会议采用了新的技术架构，融合了新的视频技术，又保持完善的兼容性，在PC、android、IOS全平台实施。</br>
功能完整全平台视频会议，包括：白板，ppt演示，群聊，单聊，文件共享,桌面共享，多会议平台</br>
</br>
1，采用全新的Webrtc技术，在所有的web端实施，兼容IOS,android,pc，便捷接入5分钟就能集成好。</br>
2，技术兼容性强， 支持目前主要的协议(rtsp,rtmp,webrtc,sip)参会，支持sip硬终端，rtsp监控设备，rtmp推流编码器接入。</br>
</br>

OvMeet商业化需求，可以联系下面QQ</br>
商务(非技术)QQ:1410919373 QQ群：108712418</br>
<a href="https://w.ovmeet.com:9301/login.html">MCU(支持SIP)演示：https://w.ovmeet.com:9301/login.html</a></br>
<a href="https://w.ovmeet.com:9301/ovmeetar/login.html">OvMeetAR演示：https://w.ovmeet.com:9301/ovmeetar/login.html</a></br>
<a href="https://v.ovmeet.com:9902/index.html">SFU/MCU融合架构：https://v.ovmeet.com:9902/index.html</a></br>
主要功能和特点：</br>
**Web极低延时200毫秒左右的直播推流和播放，web在线低延时会议直播推流（可定调Web会议在线直播推流）**

Win64测试包：<a href='https://m.ovmeet.com/ovsyunlive.zip'>https://m.ovmeet.com/ovsyunlive.zip</a><br />
Linux测试包：<a href='https://m.ovmeet.com/ovsyunlive11-linux.zip'>https://m.ovmeet.com/ovsyunlive11-linux.zip</a><br />
双击运行，start.bat  停止：stop.bat  商用版支持Windows,Linux系统<br />
服务程序在公网上，要配ovmedia.ini的exthost=公网IP.(内网也可以配内网IP重启)<br />
<br />
1.启动会议地址:<a href='https://localhost:9903'>https://localhost:9903</a> <br />
在线融合会议:<a href='https://m.ovmeet.com:9903'>https://m.ovmeet.com:9903</a> <br />
在线一键会议:<a href='https://m.ovmeet.com:7777'>https://m.ovmeet.com:7777</a> <br />
<br />
视频会议，媒体中心，指挥调度功能（其它视频互动商用产品）：
<br />
多协议rtmp/rtsp/webrtc/sip/融合 多屏多硬件HDMI/AV/USB/TYPE-C接入
<br />
MCU+SFU媒体中心(流媒体内核)演示：https://v.ovmeet.com:9902/index.html
<br />
MCU-SIP(VOIP)演示：https://w.ovmeet.com:9301/login.html

2.超低延播放器代码集成：网页代码接入，两行代码接入,参考play/demo.html代码，网页嵌入ovplayer.min.js，指定ovsyunlive服务器地址，播放rtsp/rtmp流。<br />
//ovsyunlive运行的服务地址 <br />
var srvurl="http://localhost:7701";<br />
this.ovplayer = new OvPlayer("video",srvurl);<br />
//要播放的rtsp/rtmp视频地址<br />
ovplayer.connect("rtsp://196.21.92.82/axis-media/media.amp"); <br />
<br />

3，功能列表：</br>
视频会议 </br>
视频发言，审请发言，管理人员发言，视频部局，视频设备设置，管理人员设备音量，踢人，设置发言人标签，</br>
设置主屏和部局位置，MCU视频会议系统，最高64方融屏，全Web平台方案（支持PC,ANDROID,IOS平台上使用）</br>

桌面共享 </br>
支持PC桌面共享 </br>

聊天消息</br>
会议内消息</br>

电子白板</br>
会议电子白板，自由笔，直线，圆，正方形，橡皮，清屏，缩放</br>

文档白板</br>
支持格式PDF,PPT,DOC,PNG,JPG,翻页，缩放</br>

文档共享</br>
上传，下载，删除，打开</br>


会议级联接入</br>
支持跨服务器之间，会议与会议级联（各上级会议和下级会级联）</br>

视频直播监控接入</br>
RTSP摄像头接入，RTMP接入，HTTP 在线视频接入会议</br>

视频共享点播</br>
视频上传，下载，删除，在线观看，格式Mp4</br>

会议在线录制</br>
支持会议视频融屏录制，服务端存录，Mp4格式
在线录制观看点播

会议旁路直播</br>
支持会议视频RTMP远程推流直播</br>

基于全新的架构开发的AR类应用产品：OvMeetAR可视化远程协助系统</br>
OvMeetAR基于全新的架构，一体化调度，一体化录存，全平台多硬件接入</br>
<a href="https://w.ovmeet.com:9301/ovmeetar/login.html">OvMeetAR演示：https://w.ovmeet.com:9301/ovmeetar/login.html</a>
<p align="center"><img src="https://github.com/ccallcn/ovmeet/blob/master/ovsyunAR1.png" /></p>
<p align="center"><img src="https://github.com/ccallcn/ovmeet/raw/master/TIM图片20190324100853.png" /></p>
<p align="center"><img src="https://github.com/ccallcn/ovmeet/raw/master/TIM图片20190417110432.png" /></p>
<p align="center"><img src="https://github.com/ccallcn/ovmeet/raw/master/TIM图片20190423104528.png" /></p>

硬件接入：</br>
<p align="center"><img src="https://github.com/ccallcn/ovmeet/blob/master/QQ%E6%88%AA%E5%9B%BE20220428145920.png" /></p>
<p align="center"><img src="https://github.com/ccallcn/ovmeet/blob/master/QQ%E6%88%AA%E5%9B%BE20220428144346.png" /></p>
对讲广播，人员定位，资料录存一体化</br>
<a href="https://w.ovmeet.com:9301/ovmeetar/login.html">OvMeetAR演示：https://w.ovmeet.com:9301/ovmeetar/login.html</a>
