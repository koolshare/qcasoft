#  **qcasoft**

> qcasoft软件中心基于kollshare开发的1.5代软件中心，适用于`koolshare 官改 qca-ipq806x`固件平台，目前仅支持华硕高通机型：RT-AX89X

## 机型支持

| 机型/固件下载                                           | 类型 | CPU/SOC | 平台        | 架构  | 内核   | 皮肤    |
| ------------------------------------------------------- | ---- | ------- | ----------- | ----- | ------ | ------- |
| [RT-AC89X](https://koolshare.cn/thread-188090-1-1.html) | 官改 | IPQ8078 | qca-ipq806x | ARMV7 | 4.4.60 | asuswrt |

## 用户须知

- 本项目，即`qca软件中心（qcasoft）`与[hnd软件中心（rogsoft）](https://github.com/koolshare/rogsoft)、梅林[arm380](https://github.com/koolshare/koolshare.github.io)/[arm384](https://github.com/koolshare/armsoft)软件中心的插件不兼容！所以不要用离线安装功能安装其它平台的软件中心！！
- 除非你要安装的插件作者明确表示他的插件可以用于`qca-ipq806x`平台的软件中心，或者插件来源于qcasoft内本身的插件，才可以安装！！

## 开发须知：

如果你是开发者，想要为qcasoft开发新的插件，并用离线包的方式进行传播，请了解qcasoft是基于koolshare 1.5代软件中心api开发，其和前代梅林380软件中心不同，并且不兼容（因为web api）！：

1. 在web方面：此版软件中心在web上使用的是软件中心1.5代的api，与[ledesoft](https://github.com/koolshare/ledesoft)、[armsoft](https://github.com/koolshare/armsoft)和[rogsoft](https://github.com/koolshare/rogsoft)一致
2. 在程序方面：qcasoft目前支持的机型：`RT-AX89X`CPU虽然为`armv8`架构，但是固件的linux内核为32位的，所以RT-AX89X固件后台显示`armv7l`，所以RT-AX89X仅支持32位程序。为了兼容以后可能出现的华硕高通机型，建议全部采用32位程序
3. 程序编译建议使用`RT-AX89X`源码包中提供的工具链：openwrt-gcc463.arm，并且为了保证在不同固件之间的正常运行，尽量使用全静态编译。
6. 为了避免用户使用其它平台的离线安装包进行安装，因此，rogsoft软件中心需要对离线安装包需要做验证。安装时需要验证安装包内是否含有`.valid`文件，且文件内含有`qca`字符串。
7. 为了避免用户讲本项目内的离线安装包用于其它不兼容的软件中心平台，为了避免用户讲本项目内的离线安装包用于其它不兼容的软件中心平台，因此本项目中所有的安装包内的`install.sh`都需要进对安装的固件/平台进行检测，可以参考[示例](https://github.com/koolshare/qcasoft/blob/master/rog/rog/install.sh#L44-L56)。

## **koolshare几个版本的软件中心区别：**

|  软件中心   |                        arm380软件中心                        |                        arm384软件中心                        |                         hnd软件中心                          | qca软件中心(本项目)                                          |                    软路由-酷软                    |
| :---------: | :----------------------------------------------------------: | :----------------------------------------------------------: | :----------------------------------------------------------: | ------------------------------------------------------------ | :-----------------------------------------------: |
|  项目名称   | [koolshare.github.io](https://github.com/koolshare/koolshare.github.io) |       [armsoft](https://github.com/koolshare/armsoft)        |       [rogsoft](https://github.com/koolshare/rogsoft)        | [qcasoft](https://github.com/koolshare/qcasoft)              | [ledesoft](https://github.com/koolshare/ledesoft) |
|  适用架构   |                            armv7l                            |                            armv7l                            |                         armv7l/armv8                         | armv7l                                                       |                        x64                        |
|    平台     |                         4708/7/7114                          |                         4708/7/7114                          |                     hnd/axhnd/axhnd.675x                     | qca-ipq806x                                                  |                     by fw867                      |
|  linux内核  |                           2.6.36.4                           |                           2.6.36.4                           |                            4.1.xx                            | 4.4.60                                                       |                       很新                        |
|     CPU     |                          bcm4708/9                           |                          bcm4708/9                           |                       bcm490x/bcm67xx                        | IPQ8074                                                      |                     intel/AMD                     |
|  固件版本   |                    koolshare 梅林**380**                     |                    koolshare 梅林**384**                     |                     koolshare 梅林/官改                      | koolshare 官改                                               |                   OpenWRT/LEDE                    |
| 软件中心api |                          **1.0** 代                          |                          **1.5** 代                          |                          **1.5** 代                          | **1.5** 代                                                   |                    **1.5** 代                     |
| 代表机型-1  | [RT-AC68U 改版梅林380](https://koolshare.cn/thread-139322-1-1.html) | [RT-AC88U 改版梅林384](https://koolshare.cn/thread-164857-1-1.html) | [RT-AC86U 改版梅林](https://koolshare.cn/thread-127878-1-1.html) | [RT-AX89X 官改固件](https://koolshare.cn/thread-188090-1-1.html) |                         \                         |
| 代表机型-2  | [RT-AC88U 改版梅林380](https://koolshare.cn/thread-139322-1-1.html) | [RT-AC5300 改版梅林384](https://koolshare.cn/thread-164857-1-1.html) | [GT-AC5300 华硕官改](https://koolshare.cn/thread-130902-1-1.html) |                                                              |                         \                         |
| 代表机型-3  | [R7000 改版梅林380](https://koolshare.cn/thread-139324-1-1.html) |                                                              | [RT-AX88U 改版梅林](https://koolshare.cn/thread-158199-1-1.html) |                                                              |                         \                         |
