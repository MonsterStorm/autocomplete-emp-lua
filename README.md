# EMP Lua 函数库自动补全

当前支持
=======
- lua扩展功能模块（例如：`window.alert(content)`）;
- 控件操作函数（例如：`control:getMatrix()`）；

注意事项
=======
1. 自动补全在输入完模块名或对象名后按`:`或`.`触发；
2. 控件操作函数的自动补全目前需要获取的对象变量命名要求如下：
  * 以`control`结尾(忽略大小写)。eg：xControl, buttonCONTROL
  * 或者以`ctrl`结尾(忽略大小写)。eg：ctrl, imgCtrl
