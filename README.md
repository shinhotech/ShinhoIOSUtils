# 使用方法
### Utils
* Shortcut 快捷方法、属性
```
statusBarHeight：状态栏高度
windowSafeAreaInsets：安全区域
isNotchScreen: 是否刘海屏
isIPhoneX: 是否 iPhoneX
appDelegate: App代理
screenHeight: 屏幕高度
screenWidth: 屏幕宽度
```
* Constant 常用常量
```
photoSize: photo size
navBarHeight: bottom navgation bar height 
titleBarHeight: title bar height
addPhotoHeight: photo height
maxTextCount: 最大文字数量
pageSize: 一页20条数据
```
* UIImageUtil Image工具
```
imageCacheURL: 图片缓存文件夹
defaultGradiantImage: 默认渐变图片

图片左下角添加时间水印
func dateImage(font: UIFont = .systemFont(ofSize: 18)) -> UIImage
创建渐变图片
static func gradiantImage(leftColor: UIColor, rightColor: UIColor) -> UIImage?
缓存图片到本地
func cacheLocal() -> String
读取缓存图片
static func localImage(fileUrl: String?) -> UIImage?
base64 to UIImage
static func image(with base64: String) -> UIImage?
重设图片大小
func reSizeImage(reSize: CGSize) -> UIImage
等比率缩放
func scaleImage(scaleSize: CGFloat) -> UIImage
多张图片拼接
static func drawImages(imageArray: [UIImage], row: Int = 1) -> UIImage
调整图片方向
func fixOrientation() -> UIImage
圆点图片
static func circlePoint(color: UIColor, diameter: CGFloat) -> UIImage?
```
* UIColorUtil Color工具
```
leftGradientColor: 默认渐变色左侧颜色
rightGradientColor: 默认渐变色右侧颜色
```
* SystemConfigure 系统配置
```
appVersion: 当前app版本
isFirstInstall: 第一次安装App，或者删掉重新安装
isUpdateVersion: 更新版本
modelName: 手机模型名
systemVersion: 系统版本
isSimulator: 是否模拟器
appVersionNum: 当前App版本号
networkStatus: 网络状态
```
* UIFontUtil 字体工具
```
pingFangSCLight
pingFangSCRegular 
pingFangSCMedium
pingFangSCSemibold
pingFangHKRegular 
```

### Category
* UIApplication+AXExtension  
```
appVersion: app版本
buildVersion: build版本
displayName: app名称
bundleName: bundle名称
bundleId: bundle id
documentsURL: 沙盒路径
cachesURL: 缓存路径
preferencesPath: 首选项路径
tmpPath: tmp路径
libraryURL: library路径
topViewController: 最上层控制器
```
* UserDefaultsWrapper
* UIDevice+AXExtension
```
modelName: model名称
```
* UIView+AXExtension
```
snapshotImage: 截图

递归枚举sub view
func enumSubview(_ closure: @escaping (UIView) -> Bool)
```
* Date+AXExtension
```
ts: 毫秒
dateString: 格式化为yyyy.M.d
timeString: 格式化为HH:mm
dateTimeString: 格式化为yyyy.M.d HH:mm
hour: 时
month: 月
day2Second: 这一天的0时0分0秒的秒数
month2Second: 这一月的0日0时0分0秒的秒数
monthFirstDay: 这个月的第一天
monthLastDay: 这个月的最后一天
比较两个时间是否相同
func same(with other: Date?) -> Bool
根据输入的年月日生成日期对象
static func from(year: Int, month: Int, day: Int, hour: Int = 5, min: Int = 30, sec: Int = 30) -> Foundation.Date?
返回根据历法所取到的值
func getComponent(_ component: NSCalendar.Unit) -> Int
提前几天
func beforeDate(_ befor: Int) -> Foundation.Date
推迟几天
func nextDate(_ befor: Int) -> Foundation.Date
获取阴历的日子
func getLunarDayInfo() -> Int
当月有几天
public func numOfDayFormMouth() -> Int
```
* String+AXExtension
* Array+AXExtension
* Dictionary+AXExtension
* Date+AXExtension
* Data+AXExtension
* UIControl+AXExtension

### API
* API 网络请求方法
```
网络请求接口
func request(_ method: Alamofire.HTTPMethod, _ url: String, parameters: Any? = nil, manager: Session? = nil) -> Observable<Any>
序列化方法
static func parse<T>(json: Any?, to model: T.Type) -> T? where T : Decodable
反序列化方法
static func encode<T>(model: T) -> Any? where T : Encodable
```
* RequestUrl  接口url



